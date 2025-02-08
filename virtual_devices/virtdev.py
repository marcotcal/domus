import random
import sys

from paho.mqtt import client as mqtt_client
import secrets
import psycopg2 as pg
import psycopg2.extras

broker = 'homeassistant.local'
port = 1883

_DEVICES = None

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

        for device in _DEVICES:
            set_cmd = device["command_topic"]
            status_cmd = device["state_topic"]
            payload_on = device["payload_on"]
            payload_off = device["payload_off"]
            if msg.topic == set_cmd:
                if msg.payload.decode() == payload_on:
                    client.publish(status_cmd ,payload_on) 
                else:     
                    client.publish(status_cmd ,payload_off) 

    for device in _DEVICES:
        set_cmd = device["command_topic"]
        client.subscribe(set_cmd)

    client.on_message = on_message


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()


if __name__ == '__main__':
    try:

        sql = '''
            SELECT 
                code
               ,description
               ,payload_on
               ,payload_off
               ,command_topic
               ,state_topic
               ,code_house_room
            FROM area.light
            UNION 
            SELECT 
                code
               ,description
               ,payload_on
               ,payload_off
               ,command_topic
               ,state_topic
               ,code_house_room
            FROM area.outlet
        '''

        conn = pg.connect(host=secrets.HOST, user=secrets.USER, database=secrets.DATABASE, password=secrets.PASSWORD, port=secrets.PORT)

        # create device dict

        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        cur.execute(sql) 
        _DEVICES = cur.fetchall()

        cur.close()
        conn.close()

        run()
    except KeyboardInterrupt:
        print("\nUser interruption\nBye")
        sys.exit()
