import network
import socket
import time
import machine
import json
from read_thermometer import MPL115A2

from machine import Pin
 
intled = machine.Pin("LED", machine.Pin.OUT)
  
# TODO implement config.py  
ssid = 'xxxxx'
password = 'xxxxx'
 
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect(ssid, password)

mpl = MPL115A2()
print(mpl.get_data())
 
# Wait for connect or fail
max_wait = 10
while max_wait > 0:
    if wlan.status() < 0 or wlan.status() >= 3:
        break
    max_wait -= 1
    print('waiting for connection...')
    time.sleep(1)

# Handle connection error
if wlan.status() != 3:
    raise RuntimeError('network connection failed')
else:
    print('connected')
    status = wlan.ifconfig()
    print( 'ip = ' + status[0] )
 
# Open socket
addr = socket.getaddrinfo('0.0.0.0', 80)[0][-1]
 
s = socket.socket()
s.bind(addr)
s.listen(1)
 
print('listening on', addr)

stateis = ""
 
# Listen for connections
while True:
    try:
        cl, addr = s.accept()
        print('client connected from', addr)

        request = cl.recv(1024)
        
        request = str(request)
        led_on = request.find('/light/on')
        led_off = request.find('/light/off')
        sens_read = request.find('/sensor/read')        
        
        if led_on == 6:
            intled.value(1)
            stateis = {'led':'ON'}

        if led_off == 6:
            intled.value(0)
            stateis = {'led':'OFF'}
     
        if sens_read == 6:
            press, temp = mpl.get_data()
            stateis = {'pressure': press, 'temperature': temp}
             
        response = json.dumps(stateis)
        
        cl.send('HTTP/1.0 200 OK\r\nContent-type: text/json\r\n\r\n')
        cl.send(response)
        cl.close()
 
    except OSError as e:
        cl.close()
        print('connection closed')