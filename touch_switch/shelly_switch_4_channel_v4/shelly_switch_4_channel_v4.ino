
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <ESP8266WebServer.h>
#include <pgmspace.h>
#include <time.h>
#include <FS.h>
#include <Bounce2.h>
#include <LittleFS.h>
#include <ArduinoJson.h>
#include "secrets.h"

/* =====================================================
   CONFIGURAÇÃO BÁSICA
   ===================================================== */
/* variable defined on secrets.h
 *  
// -------- MODO --------
String device_mode = "operational";   // "operational" ou "setup"

// -------- WIFI --------

// initial AP configuration
String ssid = "DOMUS-SWITCH";
String password = "";
IPAddress   apIP(192, 168, 4, 200);

// -------- MQTT --------
String mqtt_server  = "";
unsigned int mqtt_port    = 8883;
String mqtt_user    = "";
String mqtt_pass    = "";
String mqtt_ssl_tls = "on";            // "on" ou "off"

// CHANGE FOR YOUR CERTIFICATE 

static const char mqtt_ca_cert[] PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFAzCCAuugAwIBAgIUfta9J9b8LeMEoTBqz04tjrV3ZYMwDQYJKoZIhvcNAQEL
BQAwEDEOMAwGA1UEAwwFTWFyY28wIBcNMjUxMjEzMjI0NTQwWhgPMjEyNTExMTky
MjQ1NDBaMBAxDjAMBgNVBAMMBU1hcmNvMIICIjANBgkqhkiG9w0BAQEFAAOCAg8A
MIICCgKCAgEAkQqEUT3k+/q3MIzHC23vvJrLXu9Uk3PgsBj2DqXGhuQnT23mg3C5
kxEYmVUC7T89FDuDnFVDLcbm57vcjCF5BIPv1ely4pAYIdoKwLyCSKU8nYzjMScf
XSF405qSkmJ8eJlmMgSXqgW0ZSOSlSdyJncUc71DJ0FL8q753vRJB4mfaYiWlqaT
fouqdzO93KSnnDBIPIdTR8oOLbjWi/heKfExzLr+dat9pCm21469jsMGQKJdBxlZ
c09D99JYpWPPRFrjx2bqmsLU8QKCy5iUIqH0ba6HQOkg+NbzatfOcBy4mdo/EANM
bGbO6wNN7VM171Hqstc89MY2e1Tr+GEGPz0VJlzbr9WkAGM8DnLfc+Ezddjba94x
qYKeFvyDHOI6hKxmJ2DriKo6/No9CxqrzwpYJF0qfn85jnBxWG7bjZmhWmixn8Jm
pgqjU1mzupt50mHhBLkm1tvcgDStcrVHEyzIsTOs0YS5yrGSwyUquGZO/i+9gqHV
A+btDWS8MkUdcZsxytSxMd3d+U+R911UYV4LUkOu+JauJg2cvaHuIvuPnkIdwb7Q
Y+MIts100au+xGDI/SP56Qq7gD2QTz7eD/efRtmZOAULwrzJswi/VE9wgP4Rsrk2
3qWgLc1dVj582CIRCrsR+pSby+mNECcH4iYw22WB+qzq1Jh8PUBe9fMCAwEAAaNT
MFEwHQYDVR0OBBYEFNGAR+52DV2sS7/4csbD0+bubupkMB8GA1UdIwQYMBaAFNGA
R+52DV2sS7/4csbD0+bubupkMmmDA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQEL
BQADggIBAHKerU5G9fcZv+pK7ZU/J0BDUwRyQCVl+YD8OMkSEnxUM3aOEovxinGL
3O7kPbaad8thxW6pb0YlVsve3B4/w19aBp2rvfrZ3+OCpEuE/WbVng46mZno0rFt
WTj/JkxwWOQwWMOYk4ts5jjXALpFOxnw8rTj3U9AKa3wc4dh0sB2Q1m2FiAGuhbg
b9GzMWR5bUfLvt+pESHHZEoZGKnYw6N/FdpLmz8sJ9p4yWQTV6n2z56fowjq0Mtk
QH3YvqamAkMUziKXZMH41ygOG6xzluBN8OPxn+MC8Gq7pV/RqY4Dv9cOuxIhWhlS
3B1wBjHRaSpyOnOjyGjlcddgr0ND3uSCWy/KWOfhq2WK6VvBR7S8AS9tvvCPMkFm
g7rxDVkY6fwVQCtlFZDXRN6tVyI0uNHcIX3eR4zXb1rWQdLVxmh9Ysm+CluHmBCh
QdgrdXDoY6ICJ1OKOIxYh7Q67dm7dBEj/mMfYgACZX5Bzg0OqR17F8PI9QBBzlrE
qPXsQU+PBKhVaM34Zp8Dp+VeXxacParm8edjkFQtM1SRYKAx5ahwHlyd1j2gjjDt
SeYKEyqUkQz3DrJXnG0+LHuWtcM7pTSCvebKSxUJDWUkwrcA2+65dl7iPT15OyON
B+NOeA4+ckRCSjfhviSBhlb5e86dYOyvaVfxHNi1CJ74MINosCNM
-----END CERTIFICATE-----
)EOF";

end of security.h declarations 

*/

//----------CONFIGURATION ----------

struct Config {
  String switch_id;
  String ssid;
  String password;
  String mqtt_server;
  unsigned int mqtt_port;
  bool mqtt_use_ssl;
  String mqtt_user;
  String mqtt_password; 
} config;

// -------- DEVICE --------

String switch_id =  "switch-" + String(random(0xffff), HEX);
bool registered = false;


// ----------TOPICS ----------

unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE  (50)
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
#define FACTORY_RESET D8 // gpio 12

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

String switch_topic_updateA = switch_id + "/switch_updateA";
String switch_topic_updateB = switch_id + "/switch_updateB";
String switch_topic_updateC = switch_id + "/switch_updateC";
String switch_topic_updateD = switch_id + "/switch_updateD";

String register_topic = "register";
String who_am_i_topic = "who_am_i";

/* =====================================================
   
   ===================================================== */

void initiateTopics() {

  status_topicA = switch_id + "/switch_statusA";
  status_topicB = switch_id + "/switch_statusB";
  status_topicC = switch_id + "/switch_statusC";
  status_topicD = switch_id + "/switch_statusD";
  
  switch_topicA = switch_id + "/switchA";
  switch_topicB = switch_id + "/switchB";
  switch_topicC = switch_id + "/switchC";
  switch_topicD = switch_id + "/switchD";
  
  switch_topic_updateA = switch_id + "/switch_updateA";
  switch_topic_updateB = switch_id + "/switch_updateB";
  switch_topic_updateC = switch_id + "/switch_updateC";
  switch_topic_updateD = switch_id + "/switch_updateD";
  
}

/* =====================================================
   OBJETOS GLOBAIS
   ===================================================== */
WiFiClient espClient;
WiFiClientSecure espClientSecure;
BearSSL::X509List caCert(mqtt_ca_cert);

PubSubClient client;

ESP8266WebServer server(80);

/* =====================================================
    SETUP CONFIGURATION SAVE AND RESTORE 
   ===================================================== */

void saveConfig() {
  StaticJsonDocument<256> doc;
  doc["switch_id"] = config.switch_id;
  doc["SSID"] = config.ssid;
  doc["password"] = config.password;
  doc["MQTT_server"] = config.mqtt_server;
  doc["MQTT_port"] = String(config.mqtt_port);

  if (config.mqtt_use_ssl)
    doc["MQTT_use_ssl"] = "on";
  else  
    doc["MQTT_use_ssl"] = "off";

  doc["MQTT_user"] = config.mqtt_user; 
  doc["MQTT_password"] = config.mqtt_password;  

  File f = LittleFS.open("/config.json", "w");
  serializeJson(doc, f);
  f.close();
}

bool readConfig() {
  if (!LittleFS.begin()) {
    Serial.println("Error mounting LittleFS");
    return false;
  }

  if (!LittleFS.exists("/config.json")) {
    Serial.println("configuration does not exists");
    return false;
  }

  File file = LittleFS.open("/config.json", "r");
  if (!file) {
    Serial.println("Cannot read configuration");
    return false;
  }

  StaticJsonDocument<256> doc;
  DeserializationError error = deserializeJson(doc, file);
  file.close();

  if (error) {
    Serial.print("❌JSON error: ");
    Serial.println(error.c_str());
    return false;
  }

  config.switch_id = doc["switch_id"] | "";
  config.ssid = doc["SSID"] | "";
  config.password = doc["password"] | "";
  config.mqtt_server = doc["MQTT_server"] | "";
  config.mqtt_port = doc["MQTT_port"]  | 8883;
  config.mqtt_user = doc["MQTT_user"] | "";
  config.mqtt_password = doc["MQTT_password"] | "";
  config.mqtt_use_ssl = (doc["MQTT_use_ssl"] == "on");
  
  Serial.println("Config loaded");
  return true;
}

/* =====================================================
   HTTP Handlers
   ===================================================== */

void handleRoot() {

  Serial.println("Home page");
  
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
  content += "<select name='ssid' id='ssid''>";
  for (int i = 0; i < n; ++i)
  {  
    if (WiFi.SSID(i) == ssid)
      content += "<option selected value='" + WiFi.SSID(i) + "'>" + WiFi.SSID(i) + "</option>";
    else   
      content += "<option value='" + WiFi.SSID(i) + "'>" + WiFi.SSID(i) + "</option>";
  }
  content += "</select>";
  content +="</td></tr>";
  content += "<tr><td><b>Password</b></td><td><input type='text' name='password' value='" + password + "'></td></tr>";
  content += "<tr><td>&nbsp;</td><td>&nbsp;</td></tr>";
  content += "<tr><td><b>MQTT Broker</b></td><td><input type='text' name='mqtt_broker' value='" + mqtt_server + "'></td></tr>";
  content += "<tr><td><b>MQTT Port</b></td><td><input type='text' name='mqtt_port' value='" + String(mqtt_port) + "'></td></tr>";
  content += "<tr><td><b>MQTT User</b></td><td><input type='text' name='mqtt_user' value='" + mqtt_user + "'></td></tr>";
  content += "<tr><td><b>MQTT Password</b></td><td><input type='text' name='mqtt_password' value='" + mqtt_pass + "'></td></tr>";
  if (mqtt_ssl_tls == "on")
    content += "<tr><td><b>MQTT SSL/TLS</b></td><td><input type='checkbox' name='mqtt_ssl_tls' checked></td></tr>";
  else
    content += "<tr><td><b>MQTT SSL/TLS</b></td><td><input type='checkbox' name='mqtt_ssl_tls'></td></tr>";
  content += "<tr><td>&nbsp;</td><td>&nbsp;</td></tr>";
  content += "<tr><td><input type='submit' value='Submit'></td><td><a href='/'>Go Back</a></td></tr>";    
  content += "</table>";
  content += "</form><br>";
  content += "</body></html>";
      
  server.send(200, "text/html", content.c_str());
  
}

void handle_form() {
  
  String switch_id = server.arg("switch_id");
  String operational_ssid = server.arg("ssid"); 
  String operational_password = server.arg("password"); 
  String mqtt_broker = server.arg("mqtt_broker"); 
  String mqtt_port = server.arg("mqtt_port");
  String mqtt_user = server.arg("mqtt_user"); 
  String mqtt_ssl_tls = server.arg("mqtt_ssl_tls"); 
  String mqtt_password = server.arg("mqtt_password"); 
  
  // Serial.print("SSID:");
  // Serial.println(operational_ssid);

  // Serial.print("Password:");
  // Serial.println(operational_password);
  
  String s = "<a href='/'> Go Back </a>";

  config.switch_id = switch_id;
  config.ssid = operational_ssid;
  config.password = operational_password;
  config.mqtt_server = mqtt_broker;
  config.mqtt_user = mqtt_user;
  config.mqtt_use_ssl = (mqtt_ssl_tls == "on");
  config.mqtt_password = mqtt_password;

  if (operational_ssid == "" || mqtt_broker == "" || mqtt_user == "") {
    s = "<a href='/'> Nothing done! ssid, mqtt broker or mqtt user not informed. Go Back </a>";    
  } else {
    saveConfig();
  }  
  
  server.send(200, "text/html", s); //Send web page
}

/* =====================================================
   Sync device time
   ===================================================== */

void syncTime() {

  configTime(0, 0, "pool.ntp.org", "time.nist.gov");

  Serial.print("Sync time");

  time_t now = time(nullptr);
  while (now < 1700000000) {  // ~2023
    delay(500);
    Serial.print(".");
    yield();
    now = time(nullptr);
  }

  Serial.println("\nTime OK");
}

/* =====================================================
   WIFI
   ===================================================== */

void startAP() {
  WiFi.disconnect(true);
  delay(200);

  WiFi.mode(WIFI_AP);
  WiFi.softAP("DOMUS-SWITCH");
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));

  Serial.println("AP MODE ACTIVE");
  Serial.print("AP IP: ");
  Serial.println(WiFi.softAPIP());
}

void setup_wifi() {

  Serial.println("\n=== WIFI CONNECT ===");

  WiFi.disconnect(true);
  delay(200);

  WiFi.mode(WIFI_STA);
  WiFi.persistent(false);
  WiFi.setAutoReconnect(true);

  Serial.print("SSID: ");
  Serial.println(ssid);

  WiFi.begin(ssid.c_str(), password.c_str());

  WiFi.setSleepMode(WIFI_NONE_SLEEP);

  unsigned long start = millis();
  while (WiFi.status() != WL_CONNECTED &&
         millis() - start < 30000) {

    delay(500);
    Serial.print(".");
  }

  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("\nWiFi FAILED → AP fallback");
    startAP();
    return;
  }

  Serial.println("\nWiFi CONNECTED");
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());
}

/* =====================================================
   MQTT + TLS
   ===================================================== */

void setup_mqtt() {

  Serial.println("\n=== MQTT SETUP ===");
  Serial.print("Heap before MQTT: ");
  Serial.println(ESP.getFreeHeap());

  if (mqtt_ssl_tls == "on") {

    Serial.println("TLS ENABLED");

    espClientSecure.setBufferSizes(512, 512);
    espClientSecure.setTimeout(15000);
    espClientSecure.setTrustAnchors(&caCert);

    client.setClient(espClientSecure);
    mqtt_port = 8883;

  } else {

    Serial.println("TLS DISABLED");

    client.setClient(espClient);
    mqtt_port = 1883;
  }

  client.setServer(mqtt_server.c_str(), mqtt_port);

  Serial.print("Heap after MQTT: ");
  Serial.println(ESP.getFreeHeap());
}

/* =====================================================
   MQTT CALLBACK
   ===================================================== */

void mqttCallback(char* topic, byte* payload, unsigned int length) {
  Serial.print("MQTT [");
  Serial.print(topic);
  String PayLoadStr = "";
  
  Serial.print("] ");
  for (unsigned int i = 0; i < length; i++) {
    // Serial.print((char)payload[i]);
    PayLoadStr += (char)payload[i];
  }
  Serial.println();

  // Serial.println(PayLoadStr);

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
    
    if (strcmp(topic, switch_topic_updateA.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        is_onA = true;
      } else {
        is_onA = false;
      }

    } 
    
    if (strcmp(topic, switch_topic_updateB.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        is_onB = true;
      } else {
        is_onB = false;
      }

    } 
    
    if (strcmp(topic, switch_topic_updateC.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        is_onC = true;
      } else {
        is_onC = false;
      }

    } 
    
    if (strcmp(topic, switch_topic_updateD.c_str()) == 0) {
      
      if (PayLoadStr == "on") {
        is_onD = true;
      } else {
        is_onD = false;
      }
    }
    
  }
  
}

/* =====================================================
   MQTT RECONNECT
   ===================================================== */

void reconnect_mqtt() {

  Serial.print("Connecting MQTT... ");

  if (client.connect(
        switch_id.c_str(),
        mqtt_user.c_str(),
        mqtt_pass.c_str())) {

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

    client.subscribe(switch_topic_updateA.c_str());
    client.subscribe(switch_topic_updateB.c_str());
    client.subscribe(switch_topic_updateC.c_str());
    client.subscribe(switch_topic_updateD.c_str());
          
    client.subscribe(who_am_i_topic.c_str());
    
    Serial.println("Subscribed " + switch_topicA);
    Serial.println("Subscribed " + switch_topicB);
    Serial.println("Subscribed " + switch_topicC);
    Serial.println("Subscribed " + switch_topicD);

    Serial.println("Subscribed " + switch_topic_updateA);
    Serial.println("Subscribed " + switch_topic_updateB);
    Serial.println("Subscribed " + switch_topic_updateC);
    Serial.println("Subscribed " + switch_topic_updateD);

  } else {

    Serial.print("FAIL rc=");
    Serial.println(client.state());
    delay(3000);
  }

}

/* =====================================================
   SETUP
   ===================================================== */

void setup() {

  Serial.begin(115200);
  delay(200);

  Serial.println("\nBOOT");
  Serial.print("Initial heap: ");
  Serial.println(ESP.getFreeHeap());

  server.on("/", handleRoot);

  server.on("/action_form", handle_form);
  server.on("/register", register_form);
  server.on("/factory_reset", factory_reset);
  server.on("/reboot", reboot);

  server.begin();
  Serial.println("HTTP Server Started");

  // clean old config if needed 
  //SPIFFS.begin();
  //Dir dir = SPIFFS.openDir("/");
  // forçar reset
  //SPIFFS.remove(F("/config.txt"));

  if (readConfig()) {
    
    device_mode = "operational";

    switch_id = config.switch_id;
    ssid = config.ssid;
    password = config.password;
    mqtt_server = config.mqtt_server;
    mqtt_user = config.mqtt_user;
    mqtt_pass = config.mqtt_password;
    mqtt_port = config.mqtt_port;
    if (config.mqtt_use_ssl)
      mqtt_ssl_tls = "on";
    else
      mqtt_ssl_tls = "off";

    initiateTopics();
      
    /*  
    Serial.print("Config Switch Id :");
    Serial.println(config.switch_id);
    Serial.print("Config SSID :");
    Serial.println(config.ssid);
    Serial.print("Config password :");
    Serial.println(config.password);
    Serial.print("Config Broker :");
    Serial.println(config.mqtt_server);
    Serial.print("Config mqtt user :");
    Serial.println(config.mqtt_user);
    Serial.print("Config mqtt password :");
    Serial.println(config.mqtt_password);
    Serial.print("Config mqtt port :");
    Serial.println(config.mqtt_port);
    Serial.print("Config mqtt use ssl :");
    */
    
    setup_wifi();  

    if (WiFi.status() == WL_CONNECTED) {
      syncTime();  
      setup_mqtt();
      client.setCallback(mqttCallback);
      registered = false; 
    }
  
  } else {

    device_mode = "setup";
    startAP();
  }
  
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

}

/* =====================================================
   LOOP
   ===================================================== */

void loop() {

  String register_msg;

  debouncerA.update();
  debouncerB.update();
  debouncerC.update();
  debouncerD.update();
   
  debouncerReset.update();

  if(device_mode == "operational") {
    
  
    if (!client.connected()) {
      if (WiFi.status() == WL_CONNECTED)
        reconnect_mqtt();
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

  }
  
  server.handleClient();
}
