#!/usr/bin/env python3

import random
import sys
import time
import ssl
import secrets

import psycopg2
import psycopg2.extras
from paho.mqtt import client as mqtt_client

# =========================
# MQTT TLS CONFIG
# =========================
BROKER = secrets.MQTT_BROKER
PORT = secrets.MQTT_PORT
CA_CERT = "/etc/mqtt/ca.crt"   # ajuste se necessário

CLIENT_ID = f"domus-bridge-{random.randint(0, 10000)}"
USERNAME = secrets.MQTT_USER
PASSWORD = secrets.MQTT_PASSWORD

# =========================
# GLOBAL STATE
# =========================
_DEVICES = []
_RELAYS = []
_LIGHTS = []
_STATUS = {}

# =========================
# MQTT CALLBACKS (API v2 safe)
# =========================
def on_connect(client, userdata, flags, reason_code, properties=None):
    if reason_code == 0:
        print("✅ MQTT TLS connected")
    else:
        print(f"❌ MQTT TLS connection failed (reason_code={reason_code})")


def on_disconnect(client, userdata, reason_code, properties=None, *args, **kwargs):
    print(f"⚠️ MQTT disconnected (reason_code={reason_code})")


def on_message(client, userdata, msg):
    payload = msg.payload.decode()
    topic = msg.topic

    for device in _DEVICES:
        set_cmd = device["command_topic"]
        status_cmd = device["state_topic"]
        payload_on = device["payload_on"]
        payload_off = device["payload_off"]
        device_type = device["device_type"]
        device_code = device["code"]

        # =========================
        # SET COMMAND
        # =========================
        if topic == set_cmd:
            print(f"📥 SET {device_code} = {payload}")

            if payload == payload_on:
                _STATUS[device_code] = True
                client.publish(status_cmd, payload_on, retain=True)
            else:
                _STATUS[device_code] = False
                client.publish(status_cmd, payload_off, retain=True)

            # Send command to relay block
            for relay in _RELAYS:
                if relay["device"] == device_code:
                    relay_cmd = relay["command_topic"]
                    relay_payload = (
                        relay["payload_on"]
                        if _STATUS[device_code]
                        else relay["payload_off"]
                    )
                    client.publish(relay_cmd, relay_payload)

        # =========================
        # STATUS COMMAND (switch → light)
        # =========================
        if topic == status_cmd and device_type == "switch":
            print(f"📥 STATUS {device_code} = {payload}")

            for sl in _LIGHTS:
                if sl["code_switch"] == device_code:
                    light_cmd = sl["command_topic"]
                    light_payload = (
                        sl["payload_on"]
                        if payload == payload_on
                        else sl["payload_off"]
                    )
                    client.publish(light_cmd, light_payload)


# =========================
# MQTT SETUP (TLS)
# =========================
def connect_mqtt():
    client = mqtt_client.Client(
        client_id=CLIENT_ID,
        protocol=mqtt_client.MQTTv311,
    )

    client.username_pw_set(USERNAME, PASSWORD)

    client.tls_set(
        ca_certs=CA_CERT,
        certfile=None,
        keyfile=None,
        cert_reqs=ssl.CERT_REQUIRED,
        tls_version=ssl.PROTOCOL_TLS_CLIENT,
    )
    client.tls_insecure_set(False)

    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message

    client.connect(BROKER, PORT, keepalive=60)
    return client


def subscribe_topics(client):
    for device in _DEVICES:
        set_cmd = device["command_topic"]
        status_cmd = device["state_topic"]

        if device["device_type"] == "switch":
            client.subscribe(status_cmd)
        else:
            client.subscribe(set_cmd)

        _STATUS[device["code"]] = False
        client.publish(status_cmd, "off", retain=True)

    print("📡 MQTT topics subscribed")


# =========================
# DATABASE LOAD
# =========================
def load_data():
    global _DEVICES, _RELAYS, _LIGHTS

    conn = psycopg2.connect(
        host=secrets.HOST,
        user=secrets.USER,
        password=secrets.PASSWORD,
        database=secrets.DATABASE,
        port=secrets.PORT,
    )

    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    # DEVICES
    cur.execute(
        """
        SELECT code, description, payload_on, payload_off,
               command_topic, state_topic, code_house_room,
               'light' AS device_type
        FROM area.light
        UNION
        SELECT code, description, payload_on, payload_off,
               command_topic, state_topic, code_house_room,
               'outlet' AS device_type
        FROM area.outlet
        UNION
        SELECT code, description, payload_on, payload_off,
               command_topic, state_topic, code_house_room,
               'switch' AS device_type
        FROM area.switch
        """
    )
    _DEVICES = cur.fetchall()

    # RELAYS
    cur.execute(
        """
        SELECT device, code_relay, relay_number, is_outlet,
               is_normally_closed, description, code_relay_block,
               payload_on, payload_off, command_topic, state_topic
        FROM relay_blocks.devices_relays_view
        """
    )
    _RELAYS = cur.fetchall()

    # SWITCH → LIGHT
    cur.execute(
        """
        SELECT code_switch, code_light, description,
               payload_on, payload_off, command_topic,
               state_topic, code_house_room
        FROM relay_blocks.switch_light_view
        """
    )
    _LIGHTS = cur.fetchall()

    cur.close()
    conn.close()

    print(
        f"📊 Loaded {len(_DEVICES)} devices, "
        f"{len(_RELAYS)} relays, {len(_LIGHTS)} switch-light rules"
    )


# =========================
# MAIN LOOP (systemd-safe)
# =========================
def run_forever():
    while True:
        try:
            load_data()
            client = connect_mqtt()
            subscribe_topics(client)
            client.loop_forever()
        except Exception as e:
            print(f"⚠️ Runtime error: {e}")
            print("🔄 Reconnecting in 5 seconds...")
            time.sleep(5)


# =========================
# ENTRYPOINT
# =========================
if __name__ == "__main__":
    try:
        run_forever()
    except KeyboardInterrupt:
        print("👋 Interrupted by user")
        sys.exit(0)
