#!/usr/bin/env python3

import random
import sys
import time
import ssl
import secrets
import RPi.GPIO as GPIO
from paho.mqtt import client as mqtt_client

# =========================================================
# MQTT CONFIG
# =========================================================
BROKER = MQTT_BROKER 
PORT = MQTT_PORT
CA_CERT = "/etc/mqtt/ca.crt"

CLIENT_ID = f"relay-block-8-{random.randint(1000,9999)}"
USERNAME = secrets.MQTT_USER
PASSWORD = secrets.MQTT_PASSWORD

RELAY_BLOCK_ID = "relay_block_01"

# =========================================================
# GPIO CONFIG
# =========================================================
GPIO.setmode(GPIO.BCM)

RELAYS = {
    "relay1": 21,
    "relay2": 20,
    "relay3": 16,
    "relay4": 12,
    "relay5": 26,
    "relay6": 19,
    "relay7": 13,
    "relay8": 6,
}

for pin in RELAYS.values():
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, GPIO.LOW)

# =========================================================
# MQTT CALLBACKS — API v2
# =========================================================
def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code == 0:
        print("✅ Connected to MQTT broker (TLS)")
        subscribe_topics(client)
        publish_all_status(client)
        client.publish(f"{RELAY_BLOCK_ID}/availability", "online", retain=True)
    else:
        print(f"❌ MQTT connection failed, reason_code={reason_code}")

def on_disconnect(client, userdata, reason_code, properties=None, *args, **kwargs):
    print(f"⚠️ MQTT disconnected (reason_code={reason_code})")

def on_message(client, userdata, msg):
    topic = msg.topic
    payload = msg.payload.decode().lower()

    for relay, pin in RELAYS.items():
        set_topic = f"{RELAY_BLOCK_ID}/set_{relay}"
        status_topic = f"{RELAY_BLOCK_ID}/status_{relay}"

        if topic == set_topic:
            if payload == "on":
                GPIO.output(pin, GPIO.HIGH)
                client.publish(status_topic, "on", retain=True)
            else:
                GPIO.output(pin, GPIO.LOW)
                client.publish(status_topic, "off", retain=True)

            print(f"🔌 {relay} -> {payload}")

# =========================================================
# MQTT HELPERS
# =========================================================
def subscribe_topics(client):
    for relay in RELAYS.keys():
        topic = f"{RELAY_BLOCK_ID}/set_{relay}"
        client.subscribe(topic)
        print(f"📡 Subscribed to {topic}")

def publish_all_status(client):
    for relay, pin in RELAYS.items():
        status_topic = f"{RELAY_BLOCK_ID}/status_{relay}"
        state = "on" if GPIO.input(pin) == GPIO.HIGH else "off"
        client.publish(status_topic, state, retain=True)

# =========================================================
# MQTT CLIENT SETUP — API v2 (COMPATÍVEL)
# =========================================================
def connect_mqtt():
    client = mqtt_client.Client(
        client_id=CLIENT_ID,
        protocol=mqtt_client.MQTTv311,
        callback_api_version=mqtt_client.CallbackAPIVersion.VERSION2
    )

    client.username_pw_set(USERNAME, PASSWORD)

    client.tls_set(
        ca_certs=CA_CERT,
        tls_version=ssl.PROTOCOL_TLS_CLIENT
    )
    client.tls_insecure_set(False)

    # Last Will
    client.will_set(
        f"{RELAY_BLOCK_ID}/availability",
        payload="offline",
        qos=1,
        retain=True
    )

    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message

    client.connect(BROKER, PORT, keepalive=60)
    return client

# =========================================================
# MAIN
# =========================================================
def run():
    while True:
        try:
            client = connect_mqtt()
            client.loop_forever()  # permanece ativo
        except Exception as e:
            print(f"⚠️ Conexão MQTT falhou: {e}")
            print("🔄 Tentando reconectar em 5 segundos...")
            time.sleep(5)
    
# =========================================================
# ENTRY POINT
# =========================================================
if __name__ == "__main__":
    try:
        run()
    except KeyboardInterrupt:
        print("\n👋 Interrupted by user, cleaning up GPIO")
        GPIO.cleanup()
        sys.exit(0)

