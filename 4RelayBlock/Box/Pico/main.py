import json
from secrets import wifi_SSID, wifi_password, mqtt_server, mqtt_port, mqtt_user, mqtt_password
from makerlab.mlha import MLHA 
from machine import Pin
# import onewire, ds18x20
import time
import gc

# considering Valemann Relay Block High Activation

RELAY_1 = 6
RELAY_2 = 7
RELAY_3 = 8 
RELAY_4 = 9
# 8 relay block
RELAY_5 = 10
RELAY_6 = 11
RELAY_7 = 12
RELAY_8 = 13

# Pins definition ===================================

relay_1_pin = RELAY_1 # GPIO pin RELAY 1
relay_2_pin = RELAY_2 # GPIO pin RELAY 2
relay_3_pin = RELAY_3 # GPIO pin RELAY 3
relay_4_pin = RELAY_4 # GPIO pin RELAY 4

pir_pin = 18 # GPIO pin for the PIR sensor

relay_1 = None # relay 1
relay_2 = None # relay 2
relay_3 = None # relay 3
relay_4 = None # relay 4

mlha = None # WiFi, MQTT and HomeAssistant library

# Functions =========================================

def msg_received(topic, msg, retained, duplicate):
    if topic == "system/status":
        mlha.publish("system/status", "online")
    elif topic == "switch/toggle/relay_1_status":
        if msg == b"True":
            relay_1.value(1)
        elif msg == b"False":
            relay_1.value(0)
    elif topic == "switch/toggle/relay_2_status":
        if msg == b"True":
            relay_2.value(1)
        elif msg == b"False":
            relay_2.value(0)
    elif topic == "switch/toggle/relay_3_status":
        if msg == b"True":
            relay_3.value(1)
        elif msg == b"False":
            relay_3.value(0)
    elif topic == "switch/toggle/relay_4_status":
        if msg == b"True":
            relay_4.value(1)
        elif msg == b"False":
            relay_4.value(0)        
    else:
        print("Unknown topic")
    mlha.publish_status(parse_message())

def parse_message():
    extracted_data = {"relay_1_status": relay_1.value() == 1,
                      "relay_2_status": relay_2.value() == 1,
                      "relay_3_status": relay_3.value() == 1,
                      "relay_4_status": relay_4.value() == 1,
                      "relay_block_connection": True}

    return extracted_data


def read_and_publish():
    mlha.publish_status(parse_message())

# Publishes the config for the sensors to Homeassistant
def setup_config():
    mlha.publish_config("relay_1_status", "Relay 1 Status", "switch", expire_after = 60)
    mlha.publish_config("relay_2_status", "Relay 2 Status", "switch", expire_after = 60)
    mlha.publish_config("relay_3_status", "Relay 3 Status", "switch", expire_after = 60)
    mlha.publish_config("relay_4_status", "Relay 4 Status", "switch", expire_after = 60)
    mlha.publish_config("relay_block_connection", "4 Relay Block Connection", "binary_sensor", "connectivity", expire_after = 60)

# Main =============================================
# Initialize main component (WiFi, MQTT and HomeAssistant)
mlha = MLHA(wifi_SSID, wifi_password, mqtt_server, mqtt_port, mqtt_user, mqtt_password)
mlha.set_callback(msg_received)
mlha.set_device_name("QV4RelayBlock")

# Initialise Relays
print("Initializing relays")
relay_1 = Pin(relay_1_pin, Pin.OUT)
relay_2 = Pin(relay_2_pin, Pin.OUT)
relay_3 = Pin(relay_3_pin, Pin.OUT)
relay_4 = Pin(relay_4_pin, Pin.OUT)
relay_1.value(0)
relay_2.value(0)
relay_3.value(0)
relay_4.value(0)

# Subscribe to topics
print("New session being set up")
mlha.subscribe("switch/toggle/relay_1_status")
mlha.subscribe("switch/toggle/relay_2_status")
mlha.subscribe("switch/toggle/relay_3_status")
mlha.subscribe("switch/toggle/relay_4_status")
print("Connected to MQTT broker and subscribed to topics")

# Publish config for sensors
print("Publishing config to Homeassistant")
setup_config() # Publishes the config for Homeassistant

print("Starting values read and publish timer")
print("Initialization complete, free memory: " + str(gc.mem_free()))
print("Ready to send/receive data")
mlha.publish("system/status", "online", retain=True)

# Main loop
last_update = 0
while True:
    try:
        mlha.check_mqtt_msg()        
        # Send data to broker every 30 seconds
        if time.ticks_diff(time.ticks_ms(), last_update) > 30000: # 30 seconds
            last_update = time.ticks_ms()
            read_and_publish()
        time.sleep_ms(250)
    except Exception as ex:
        print("error: " + str(ex))
        machine.reset()
