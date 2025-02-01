#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <PubSubClient.h>
#include <FS.h>
#include <Bounce2.h>

String device_mode = "setup";

// Initial AP configuration 
String ssid = "DOMUS-SWITCH";
String password = "";
IPAddress   apIP(192, 168, 4, 200);

String mqtt_server = "";
int    mqtt_port = 1883;
String mqtt_user = "";
String mqtt_pass = "";

String switch_id = "switch-" + String(random(0xffff), HEX);
bool registered = false;

ESP8266WebServer server(80);

WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE	(50)
char msg[MSG_BUFFER_SIZE];
int value = 0;

bool is_onA = false;
bool is_onB = false;
bool is_onC = false;
bool is_onD = false;

#define BUTTON_A D5 // gpio 14
#define BUTTON_B D7 // gpio 13
#define BUTTON_C D1 // gpio 5
#define BUTTON_D D2 // gpio 4
#define FACTORY_RESET D6 // gpio 12

Bounce debouncerA = Bounce();
Bounce debouncerB = Bounce();
Bounce debouncerC = Bounce();
Bounce debouncerD = Bounce();
Bounce debouncerReset = Bounce();

String status_topicA = switch_id + "/switch_statusA";
String status_topicB = switch_id + "/switch_statusB";
String status_topicC = switch_id + "/switch_statusC";
String status_topicD = switch_id + "/switch_statusD";

String switch_topicA = switch_id + "/switchA";
String switch_topicB = switch_id + "/switchB";
String switch_topicC = switch_id + "/switchC";
String switch_topicD = switch_id + "/switchD";


String register_topic = "register";
String who_am_i_topic = "who_am_i";

void handleRoot() {
  
  String content = "";

  content += "<html><body><b><font color='#9900FF'>Domus Switch</font></b><br>";
  content += "<hr>";
  content += "Mode: " + device_mode + "<br>";
  content += "Device ID: " + switch_id + "<br>";
  content += "<hr>";
  content += "Choose one of the below options:";
  content += "<ul>";
  content += "<li><a href='/register'>Register SSID and MQTT</a><br>";
  content += "<li><a href='/factory_reset'>Factory Reset</a><br>";
  content += "<li><a href='/reboot'>Reboot</a><br>";
  content += "</ul>";
  content += "</body></html>";
      
  server.send(200, "text/html", content.c_str());
  
}

void factory_reset() {  
  SPIFFS.remove(F("/config.txt"));
  ESP.reset();
}

void reboot() {  
  ESP.reset();
}

void register_form() {

  String content = "";

  int n = WiFi.scanNetworks();
  

  // Serial.println("Scan done");
  /*
  if (n == 0)
    Serial.println("no networks found");
  else
  {
    Serial.print(n);
    Serial.println(" networks found");
    for (int i = 0; i < n; ++i)
    {
      // Print SSID and RSSI for each network found
      Serial.print(i + 1);
      Serial.print(": ");
      Serial.print(WiFi.SSID(i));
      Serial.print(" (");
      Serial.print(WiFi.RSSI(i));
      Serial.print(")");
      Serial.println((WiFi.encryptionType(i) == ENC_TYPE_NONE)?" ":"*");
      delay(10);
    }
    Serial.println("");
  }
  */
  content += "<html><body><b><font color='#9900FF'>Domus Switch</font></b><br>";
  content += "<hr>";
  content += "Mode: " + device_mode + "<br>";
  content += "Device ID: " + switch_id + "<br>";
  content += "<hr>";
  if (n==0) {
    content += "<b><font color='#FF0000'>No WiFi network found!</font></b><br>";
    content += "<hr>";
  }
  content += "<form action='/action_form'>";
  content += "<table border=0>";    
  // content += "<tr><td><b>SSID</b></td><td><input type='text' name='ssid'></td></tr>";
  content += "<tr><td><b>Switch ID</b></td><td><input type='text' name='switch_id' value='" + switch_id + "'></td></tr>";
  content += "<tr><td><b>SSID</b></td><td>";
  content += "<select name='ssid' id='ssid'>";
  for (int i = 0; i < n; ++i)
  {  
    content += "<option value='" + WiFi.SSID(i) + "'>" + WiFi.SSID(i) + "</option>";
  }
  content += "</select>";
  content +="</td></tr>";
  content += "<tr><td><b>Password</b></td><td><input type='text' name='password'></td></tr>";
  content += "<tr><td>&nbsp;</td><td>&nbsp;</td></tr>";
  content += "<tr><td><b>MQTT Broker</b></td><td><input type='text' name='mqtt_broker' value='homeassistant.local'></td></tr>";
  content += "<tr><td><b>MQTT Port</b></td><td><input type='text' name='mqtt_port' value='1883'></td></tr>";
  content += "<tr><td><b>MQTT User</b></td><td><input type='text' name='mqtt_user'></td></tr>";
  content += "<tr><td><b>MQTT Password</b></td><td><input type='text' name='mqtt_password'></td></tr>";
  content += "<tr><td>&nbsp;</td><td>&nbsp;</td></tr>";
  content += "<tr><td><input type='submit' value='Submit'></td><td><a href='/'>Go Back</a></td></tr>";    
  content += "</table>";
  content += "</form><br>";
  content += "</body></html>";
      
  server.send(200, "text/html", content.c_str());
  
}

void handle_form() {
  String new_id = server.arg("switch_id");
  String operational_ssid = server.arg("ssid"); 
  String operational_password = server.arg("password"); 
  String mqtt_broker = server.arg("mqtt_broker"); 
  String mqtt_port = server.arg("mqtt_port");
  String mqtt_user = server.arg("mqtt_user"); 
  String mqtt_password = server.arg("mqtt_password"); 
  
  // Serial.print("SSID:");
  // Serial.println(operational_ssid);

  // Serial.print("Password:");
  // Serial.println(operational_password);
  
  String s = "<a href='/'> Go Back </a>";

  String text_to_save = operational_ssid + ":" + operational_password + ":" + mqtt_broker + ":" + mqtt_port + ":" + mqtt_user + ":" + mqtt_password + ":" + new_id;

  if (operational_ssid == "" || mqtt_broker == "" || mqtt_user == "") {

    s = "<a href='/'> Nothing done! ssid, mqtt broker or mqtt user not informed. Go Back </a>";
    
  } else {

    Dir dir = SPIFFS.openDir("/");
    File config_file = SPIFFS.open(F("/config.txt"),"w");
    if (config_file) {
      config_file.print(text_to_save.c_str());
      config_file.close();
      // Serial.print("Saved file with : " + text_to_save);
    } else {      
      // Serial.print("Problem creating file");
    }
  }  
  
  server.send(200, "text/html", s); //Send web page
}

void show_fs() {
  
  // debug pourpose 
  
  FSInfo fs_info;
 
  SPIFFS.info(fs_info);


  Serial.println("File sistem info.");
 
  Serial.print("Total space:      ");
  Serial.print(fs_info.totalBytes);
  Serial.println("byte");
 
  Serial.print("Total space used: ");
  Serial.print(fs_info.usedBytes);
  Serial.println("byte");
 
  Serial.print("Block size:       ");
  Serial.print(fs_info.blockSize);
  Serial.println("byte");
 
  Serial.print("Page size:        ");
  Serial.print(fs_info.totalBytes);
  Serial.println("byte");
 
  Serial.print("Max open files:   ");
  Serial.println(fs_info.maxOpenFiles);
 
  Serial.print("Max path length:  ");
  Serial.println(fs_info.maxPathLength);
 
  Serial.println();

}

void setup_wifi() {

  delay(10);
  
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  // If the device is on setup mode it will start like an access point
  // if it is on operation mode it will be connected to a netword
  
  if (device_mode == "operational") {  
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid.c_str(), password.c_str());

    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    
  } else {
    WiFi.mode(WIFI_AP);
    WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
    WiFi.softAP(ssid.c_str()); // WiFi name
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected"); 
  if (device_mode == "operational") {
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
  } else  {
    Serial.println("IP address: ");
    Serial.println(apIP);        
  }

}

void callback(char* topic, byte* payload, unsigned int length) {
  String PayLoadStr = "";

  Serial.print("Topic: ");  
  Serial.print(topic);
  Serial.print(" -> ");  
  
  for (int i=0; i<length; i++)
  {
    PayLoadStr += (char)payload[i];
  }

  Serial.println(PayLoadStr);      

  if (strcmp(topic, "who_am_i") == 0) {

    String register_msg = switch_id + "," + WiFi.localIP().toString();    
    client.publish(register_topic.c_str(), register_msg.c_str());
    
  } else {

    if (strcmp(topic, switch_topicA.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        client.publish(status_topicA.c_str(), "on");
        is_onA = true;
      } else {
        client.publish(status_topicA.c_str(), "off");
        is_onA = false;
      }

    } 
    
    if (strcmp(topic, switch_topicB.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        client.publish(status_topicB.c_str(), "on");
        is_onB = true;
      } else {
        client.publish(status_topicB.c_str(), "off");
        is_onB = false;
      }

    } 
    
    if (strcmp(topic, switch_topicC.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        client.publish(status_topicC.c_str(), "on");
        is_onC = true;
      } else {
        client.publish(status_topicC.c_str(), "off");
        is_onC = false;
      }

    } 
    
    if (strcmp(topic, switch_topicD.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        client.publish(status_topicD.c_str(), "on");
        is_onD = true;
      } else {
        client.publish(status_topicD.c_str(), "off");
        is_onD = false;
      }

    } 
    
  }
  
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) { 
    // Serial.println();   
    // Serial.print("Attempting MQTT connection...");
    if (client.connect(switch_id.c_str(), mqtt_user.c_str(), mqtt_pass.c_str())) {
      // Serial.println("connected");
      
      // Once connected, publish an announcement...
      client.publish(status_topicA.c_str(), "off");
      client.publish(status_topicB.c_str(), "off");
      client.publish(status_topicC.c_str(), "off");
      client.publish(status_topicD.c_str(), "off");

      Serial.println("Published " + status_topicA);
      Serial.println("Published " + status_topicB);
      Serial.println("Published " + status_topicC);
      Serial.println("Published " + status_topicD);
  
      // ... and resubscribe
      client.subscribe(switch_topicA.c_str());
      client.subscribe(switch_topicB.c_str());
      client.subscribe(switch_topicC.c_str());
      client.subscribe(switch_topicD.c_str());
      
      client.subscribe(who_am_i_topic.c_str());
      
      Serial.println("Subscribed " + switch_topicA);
      Serial.println("Subscribed " + switch_topicB);
      Serial.println("Subscribed " + switch_topicC);
      Serial.println("Subscribed " + switch_topicD);
      
    } else {
      // Serial.print("failed, rc=");
      // Serial.print(client.state());
      // Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {

  int colonIndex;
  int lastIndex = 0;  
  String read_ssid = "";
  String read_password = "";
  String read_mqtt_broker = "";
  String read_mqtt_port = "";
  String read_mqtt_user = "";
  String read_mqtt_password = "";
  String read_switch_id = switch_id;
  
  pinMode(BUTTON_A, INPUT);      
  pinMode(BUTTON_B, INPUT);
  pinMode(BUTTON_C, INPUT);
  pinMode(BUTTON_D, INPUT);
  pinMode(FACTORY_RESET, INPUT);

  debouncerA.attach(BUTTON_A);
  debouncerB.attach(BUTTON_B);
  debouncerC.attach(BUTTON_C);
  debouncerD.attach(BUTTON_D);
  debouncerReset.attach(FACTORY_RESET);

  debouncerA.interval(50);
  debouncerB.interval(50);
  debouncerC.interval(50);
  debouncerD.interval(50);
  debouncerReset.interval(50);
   
  is_onA = false;
  is_onB = false;
  is_onC = false;
  is_onD = false;
  
  Serial.begin(115200);
  Serial.println("");
 
  // Serial.println("Initializing FS...");
  // show_fs();
  
  SPIFFS.begin();

  Dir dir = SPIFFS.openDir("/");
  File config_file = SPIFFS.open(F("/config.txt"),"r");

  if(!config_file) {
    device_mode = "setup";
    
    // Serial.println("Config file not found! set device to setup.");
  } else {
    String setup_str = config_file.readString() + ":";
    
    // Serial.println("config : " + setup_str);

    for(int i = 0; i<7; i++) {
      
      colonIndex = setup_str.indexOf(':', lastIndex);
      String value = setup_str.substring(lastIndex, colonIndex);

      //Serial.println("Index: " + String(i) + " colonIndex: " + String(colonIndex) + " lastIndex: " + String(lastIndex));
      //Serial.println("Value: " + value);
      
     
      if (colonIndex != -1) {
        if (i == 0)
          read_ssid = value;
        if (i == 1)
          read_password = value;
        if (i == 2)
          read_mqtt_broker = value;  
        if (i == 3)
          read_mqtt_port = value;  
        if (i == 4)
          read_mqtt_user = value;  
        if (i == 5)  
          read_mqtt_password = value;  
        if (i == 6)  
          read_switch_id = value;          
      } else
        break; 
      lastIndex = colonIndex + 1;    
    }

    if (read_switch_id == "")
      read_switch_id = switch_id;
      
    // Serial.println(read_switch_id);
    // Serial.println(read_ssid);
    // Serial.println(read_password);
    // Serial.println(read_mqtt_broker);
    // Serial.println(read_mqtt_port);
    // Serial.println(read_mqtt_user);
    // Serial.println(read_mqtt_password);
        
    device_mode = "operational";      
    switch_id = read_switch_id;
    ssid = read_ssid;
    password = read_password;    
    mqtt_server = read_mqtt_broker;
    mqtt_port = read_mqtt_port.toInt();
    mqtt_user = read_mqtt_user;
    mqtt_pass = read_mqtt_password;

    // set topics

    status_topicA = switch_id + "/switch_statusA";
    status_topicB = switch_id + "/switch_statusB";
    status_topicC = switch_id + "/switch_statusC";
    status_topicD = switch_id + "/switch_statusD";
    
    switch_topicA = switch_id + "/switchA";
    switch_topicB = switch_id + "/switchB";
    switch_topicC = switch_id + "/switchC";
    switch_topicD = switch_id + "/switchD";
    
    register_topic = "register";
    who_am_i_topic = "who_am_i";
    
  }

  server.on("/", handleRoot);

  server.on("/action_form", handle_form);
  server.on("/register", register_form);
  server.on("/factory_reset", factory_reset);
  server.on("/reboot", reboot);
  

  setup_wifi();

  if (device_mode == "operational") {
    client.setServer(mqtt_server.c_str(), mqtt_port);
    client.setCallback(callback);    
    registered = false;    
  }   

  server.begin();  
}

void loop() {

  String register_msg;

  debouncerA.update();
  debouncerB.update();
  debouncerC.update();
  debouncerD.update(); 
  debouncerReset.update();
  
  if (!client.connected() && device_mode == "operational") {
    reconnect();
  }

  client.loop();

  if (!registered) {
    register_msg = switch_id + "," + WiFi.localIP().toString();
    client.publish(register_topic.c_str(), register_msg.c_str());
    
    // Serial.println("Register: " + register_msg);    
    registered = true;
  }

  if(debouncerReset.rose()) { 
    
    factory_reset();
    
  }

  if(debouncerA.rose()) { 

    if (is_onA)
      is_onA = false;
    else
      is_onA = true;   

    if (is_onA) {
      client.publish(status_topicA.c_str(), "on");
      is_onA = true;
    } else {
      client.publish(status_topicA.c_str(), "off");
      is_onA = false;
    }

  }

  if(debouncerB.rose()) { 

    if (is_onB)
      is_onB = false;
    else
      is_onB = true;   

    if (is_onB) {
      client.publish(status_topicB.c_str(), "on");
      is_onB = true;
    } else {
      client.publish(status_topicB.c_str(), "off");
      is_onB = false;
    } 

  }

  if(debouncerC.rose()) { 

    if (is_onC)
      is_onC = false;
    else
      is_onC = true;   

    if (is_onC) {
      client.publish(status_topicC.c_str(), "on");
      is_onC = true;
    } else {
      client.publish(status_topicC.c_str(), "off");
      is_onC = false;
    } 

  }

  if(debouncerD.rose()) { 

    if (is_onD)
      is_onD = false;
    else
      is_onD = true;   

    if (is_onD) {
      client.publish(status_topicD.c_str(), "on");
      is_onD = true;
    } else {
      client.publish(status_topicD.c_str(), "off");
      is_onD = false;
    } 

  }
  
  server.handleClient();
  
}
