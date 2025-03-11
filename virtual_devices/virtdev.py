import random
import sys

from paho.mqtt import client as mqtt_client
import secrets
import psycopg2 as pg
import psycopg2.extras

broker = 'homeassistant.local'
port = 1883

_DEVICES = None
_RELAYS = None
_LIGHTS = None
_STATUS = {}

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
        for device in _DEVICES:
            set_cmd = device["command_topic"]
            status_cmd = device["state_topic"]
            payload_on = device["payload_on"]
            payload_off = device["payload_off"]        
            device_type = device["device_type"]        
            if msg.topic == set_cmd:
                print(f"Received set command `{msg.payload.decode()}` from `{msg.topic}` topic")
                if msg.payload.decode() == payload_on:
                    client.publish(status_cmd ,payload_on) 
                    _STATUS[device["code"]] = True
                    # send message to relay block                    
                    for relay_device in _RELAYS:
                        if relay_device["device"] == device["code"]:
                            relay_command = relay_device["command_topic"]
                            relay_payload = relay_device["payload_on"]
                            client.publish(relay_command, relay_payload)    
                else:     
                    client.publish(status_cmd ,payload_off) 
                    _STATUS[device["code"]] = False
                    # send message to relay block                    
                    for relay_device in _RELAYS:
                        if relay_device["device"] == device["code"]:
                            relay_command = relay_device["command_topic"]
                            relay_payload = relay_device["payload_off"]
                            client.publish(relay_command, relay_payload) 
            
            if msg.topic == status_cmd:
                if device_type == 'switch':
                    print(f"Received status command `{msg.payload.decode()}` from `{msg.topic}` topic")
                    for switch_light in _LIGHTS:
                        if switch_light["code_switch"] == device["code"]:
                            light_command = switch_light["command_topic"]
                            if msg.payload.decode() == payload_on:
                                light_payload = switch_light["payload_on"]
                            else:
                                light_payload = switch_light["payload_off"]
                            client.publish(light_command,  light_payload)
                            

    for device in _DEVICES:
        set_cmd = device["command_topic"]
        status_cmd = device["state_topic"]
        device_type = device["device_type"]
        if device_type == "switch":
            client.subscribe(status_cmd)
        else:    
            client.subscribe(set_cmd)
        _STATUS[device['code']] = False
        client.publish(status_cmd,  'off')

    client.on_message = on_message


def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_forever()


if __name__ == '__main__':
    try:

        conn = pg.connect(host=secrets.HOST, user=secrets.USER, database=secrets.DATABASE, password=secrets.PASSWORD, port=secrets.PORT)

        sql = '''
            SELECT 
                code
               ,description
               ,payload_on
               ,payload_off
               ,command_topic
               ,state_topic
               ,code_house_room
               ,'light' AS device_type
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
               ,'outlet' AS device_type
            FROM area.outlet
            UNION 
            SELECT 
                code
               ,description
               ,payload_on
               ,payload_off
               ,command_topic
               ,state_topic
               ,code_house_room
               ,'switch' AS device_type
            FROM area.switch
        '''

        # create device dict

        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        cur.execute(sql) 
        _DEVICES = cur.fetchall()

        sql = '''
            SELECT 
                device
               ,code_relay
               ,relay_number
               ,is_outlet
               ,is_normally_closed
               ,description
               ,code_relay_block
               ,payload_on
               ,payload_off
               ,command_topic
               ,state_topic
            FROM 
                relay_blocks.devices_relays_view
        '''

        # create relays dict

        cur.execute(sql) 
        _RELAYS = cur.fetchall()
        
        
        sql = '''
            SELECT 
                code_switch,
                code_light,
                description,
                payload_on,
                payload_off,
                command_topic,
                state_topic,
                code_house_room
            FROM 
                relay_blocks.switch_light_view
        '''

        # create lights dict

        cur.execute(sql) 
        _LIGHTS = cur.fetchall()

        cur.close()
        conn.close()

        run()
    except KeyboardInterrupt:
        print("\nUser interruption\nBye")
        sys.exit()
