
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <PubSubClient.h>
#include <FS.h>

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
bool is_on = false;

int LED_RED = 5; // GPIO 5 - D1
int LED_GREEN = 4; // GPIO 4 - D2
int TOUCH_SWITCH = 14; // GPIO 14 - D5
int FACTORY_RESET = 12; // GPIO 12 - D6

bool touch_switch_was_low = false;
bool factory_reset_switch_was_low = false;

String status_topic = switch_id + "/switch_status";
String switch_topic = switch_id + "/switch";
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

  // Serial.print("Topic: ");
  // Serial.println(topic);        
  
  for (int i=0; i<length; i++)
  {
    PayLoadStr += (char)payload[i];
  }

  if (strcmp(topic, "who_am_i") == 0) {

    String register_msg = switch_id + "," + WiFi.localIP().toString();    
    client.publish(register_topic.c_str(), register_msg.c_str());
    
  } else {

    if (PayLoadStr == "on") {
      digitalWrite(LED_GREEN, LOW);
      digitalWrite(LED_RED, HIGH);
      client.publish(status_topic.c_str(), "on");
      is_on = true;
    } else {
      digitalWrite(LED_GREEN, HIGH);
      digitalWrite(LED_RED, LOW);
      client.publish(status_topic.c_str(), "off");
      is_on = false;
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
      client.publish(status_topic.c_str(), "off");
      // ... and resubscribe
      client.subscribe(switch_topic.c_str());
      client.subscribe(who_am_i_topic.c_str());
      // Serial.println("Subscribed " + switch_topic);
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
  
  pinMode(LED_RED, OUTPUT);
  pinMode(LED_GREEN, OUTPUT);
  pinMode(TOUCH_SWITCH, INPUT);
  pinMode(FACTORY_RESET, INPUT);
  
  digitalWrite(LED_GREEN, HIGH);
  digitalWrite(LED_RED, LOW);

  is_on = false;
  // Serial.begin(115200);
  // Serial.println("");
 
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

    status_topic = switch_id + "/switch_status";
    switch_topic = switch_id + "/switch";
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

  if (digitalRead(FACTORY_RESET) == LOW) {
    factory_reset_switch_was_low = true;    
  }
    
  if (digitalRead(TOUCH_SWITCH) == LOW) {
    touch_switch_was_low = true;    
  }

  if(digitalRead(FACTORY_RESET) == HIGH && factory_reset_switch_was_low) { 
    
    factory_reset_switch_was_low = false;
    
    for(int i=0; i < 5; i++) {
      digitalWrite(LED_GREEN, LOW);
      digitalWrite(LED_RED, HIGH);
      delay(1000);
      digitalWrite(LED_GREEN, HIGH);
      digitalWrite(LED_RED, LOW);
      delay(1000);      
    }
    factory_reset();
  }

  if(digitalRead(TOUCH_SWITCH) == HIGH && touch_switch_was_low) { 

    touch_switch_was_low = false;

    if (is_on)
      is_on = false;
    else
      is_on = true;   

    if (is_on) {
      digitalWrite(LED_GREEN, LOW);
      digitalWrite(LED_RED, HIGH);
      client.publish(status_topic.c_str(), "on");
      is_on = true;
    } else {
      digitalWrite(LED_GREEN, HIGH);
      digitalWrite(LED_RED, LOW);
      client.publish(status_topic.c_str(), "off");
      is_on = false;
    } 

  }

  server.handleClient();
  
}
