import random
import RPi.GPIO as GPIO
import sys
import secrets
from paho.mqtt import client as mqtt_client


broker = 'homeassistant.local'
port = 1883

_CHANNEL_1 = 21 
_CHANNEL_2 = 20
_CHANNEL_3 = 16
_CHANNEL_4 = 12
_CHANNEL_5 = 26
_CHANNEL_6 = 19
_CHANNEL_7 = 13
_CHANNEL_8 = 6

_RELAY_BLOCK_ID = "relay_block_03"

_STATUS_RELAY_1 = _RELAY_BLOCK_ID + "/status_relay1"
_STATUS_RELAY_2 = _RELAY_BLOCK_ID + "/status_relay2" 
_STATUS_RELAY_3 = _RELAY_BLOCK_ID + "/status_relay3"
_STATUS_RELAY_4 = _RELAY_BLOCK_ID + "/status_relay4"
_STATUS_RELAY_5 = _RELAY_BLOCK_ID + "/status_relay5"
_STATUS_RELAY_6 = _RELAY_BLOCK_ID + "/status_relay6"
_STATUS_RELAY_7 = _RELAY_BLOCK_ID + "/status_relay7"
_STATUS_RELAY_8 = _RELAY_BLOCK_ID + "/status_relay8"

_SET_RELAY_1 = _RELAY_BLOCK_ID + "/set_relay1"
_SET_RELAY_2 = _RELAY_BLOCK_ID + "/set_relay2" 
_SET_RELAY_3 = _RELAY_BLOCK_ID + "/set_relay3"
_SET_RELAY_4 = _RELAY_BLOCK_ID + "/set_relay4"
_SET_RELAY_5 = _RELAY_BLOCK_ID + "/set_relay5"
_SET_RELAY_6 = _RELAY_BLOCK_ID + "/set_relay6"
_SET_RELAY_7 = _RELAY_BLOCK_ID + "/set_relay7"
_SET_RELAY_8 = _RELAY_BLOCK_ID + "/set_relay8"

# Generate a Client ID with the subscribe prefix.
client_id = f'subscribe-{random.randint(0, 100)}'
username = secrets.MQTT_USER 
password = secrets.MQTT_PASSWORD

def connect_mqtt() -> mqtt_client:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id)
    client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def subscribe(client: mqtt_client):

    def on_message(client, userdata, msg):
        print(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")
        if msg.topic == _SET_RELAY_1:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_1,GPIO.HIGH)
                client.publish(_STATUS_RELAY_1,"on") 
            else:     
                GPIO.output(_CHANNEL_1,GPIO.LOW)
                client.publish(_STATUS_RELAY_1,"off") 

        if msg.topic == _SET_RELAY_2:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_2,GPIO.HIGH)
                client.publish(_STATUS_RELAY_2,"on") 
            else:     
                GPIO.output(_CHANNEL_2,GPIO.LOW)
                client.publish(_STATUS_RELAY_2,"off") 

        if msg.topic == _SET_RELAY_3:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_3,GPIO.HIGH)
                client.publish(_STATUS_RELAY_3,"on") 
            else:     
                GPIO.output(_CHANNEL_3,GPIO.LOW)
                client.publish(_STATUS_RELAY_3,"off") 

        if msg.topic == _SET_RELAY_4:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_4,GPIO.HIGH)
                client.publish(_STATUS_RELAY_4,"on") 
            else:     
                GPIO.output(_CHANNEL_4,GPIO.LOW)
                client.publish(_STATUS_RELAY_4,"off") 

        if msg.topic == _SET_RELAY_5:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_5,GPIO.HIGH)
                client.publish(_STATUS_RELAY_5,"on") 
            else:     
                GPIO.output(_CHANNEL_5,GPIO.LOW)
                client.publish(_STATUS_RELAY_5,"off") 

        if msg.topic == _SET_RELAY_6:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_6,GPIO.HIGH)
                client.publish(_STATUS_RELAY_6,"on") 
            else:     
                GPIO.output(_CHANNEL_6,GPIO.LOW)
                client.publish(_STATUS_RELAY_6,"off") 

        if msg.topic == _SET_RELAY_7:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_7,GPIO.HIGH)
                client.publish(_STATUS_RELAY_7,"on") 
            else:     
                GPIO.output(_CHANNEL_7,GPIO.LOW)
                client.publish(_STATUS_RELAY_7,"off") 

        if msg.topic == _SET_RELAY_8:
            if msg.payload.decode() == "on":
                GPIO.output(_CHANNEL_8,GPIO.HIGH)
                client.publish(_STATUS_RELAY_8,"on") 
            else:     
                GPIO.output(_CHANNEL_8,GPIO.LOW)
                client.publish(_STATUS_RELAY_8,"off") 

    client.subscribe(_SET_RELAY_1)
    client.subscribe(_SET_RELAY_2)
    client.subscribe(_SET_RELAY_3)
    client.subscribe(_SET_RELAY_4)
    client.subscribe(_SET_RELAY_5)
    client.subscribe(_SET_RELAY_6)
    client.subscribe(_SET_RELAY_7)
    client.subscribe(_SET_RELAY_8)

    client.on_message = on_message


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()


if __name__ == '__main__':
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(_CHANNEL_1,GPIO.OUT)
    GPIO.setup(_CHANNEL_2,GPIO.OUT)
    GPIO.setup(_CHANNEL_3,GPIO.OUT)
    GPIO.setup(_CHANNEL_4,GPIO.OUT)
    GPIO.setup(_CHANNEL_5,GPIO.OUT)
    GPIO.setup(_CHANNEL_6,GPIO.OUT)
    GPIO.setup(_CHANNEL_7,GPIO.OUT)
    GPIO.setup(_CHANNEL_8,GPIO.OUT)
    try:
        run()
    except KeyboardInterrupt:
        print("\nUser interruption\nBye")
        GPIO.cleanup()
        sys.exit()


