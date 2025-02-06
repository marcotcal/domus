########################################################################### 
# MPL115A2 Driver - Raspberry Pi Pico
# Based on https://github.com/mchobby/esp8266-upy/tree/master/ncd-mpl115a2
# Project Domus
###########################################################################

from micropython import const
import machine
import struct
import time

__MPL115A2_ADDR__ = 0x60
__REG_PRESSURE_MSB__ = const(0X00)
__REG_A0_COEF_MSB__ = const(0X04)
__REG_START_CONVERSION__ = const(0X12)


class MPL115A2:

    def __init__(self, address = __MPL115A2_ADDR__, scl_pin = 17, sda_pin = 16):
        self.i2c = machine.I2C(0,
                               scl=machine.Pin(17),
                               sda=machine.Pin(16),
                               freq=400000)
        self.i2c_address = address;
        self.a0 = None       
        self.b1 = None
        self.b2 = None
        self.c12 = None
        if not self.check_device_exists():
            raise Exception("MPL115A2 not present or malfunctioning")        
        self.get_coeficients()
        
    def check_device_exists(self): 
        devices = self.i2c.scan()
        if devices:
            for d in devices:
                if d == self.i2c_address:
                    return True
        return False        
                        
    def get_coeficients(self):
                
        buffer = bytearray(8)
        self.i2c.writeto(self.i2c_address, bytes([__REG_A0_COEF_MSB__]))
        self.i2c.readfrom_into(self.i2c_address, buffer)
        
        # struct.unpack alternative
        # a0 = (buffer[0] << 8) | buffer[1]
        # b1 = (buffer[2] << 8) | buffer[3]
        # b2 = (buffer[4] << 8) | buffer[5]
        # c1 = ((buffer[6] << 8) | buffer[7]) >> 2
        
        a0, b1, b2, c12 = struct.unpack(">hhhh", buffer)
        c12 >>= 2
        
        self.a0 = a0 / 8
        self.b1 = b1 / 8192
        self.b2 = b2 / 16384
        self.c12 = c12 / 4194304
   
    def get_data(self):
        self.i2c.writeto(self.i2c_address, bytes([__REG_START_CONVERSION__,0x00]))
        time.sleep(0.05)
        data = bytearray(4)
        self.i2c.writeto(self.i2c_address, bytes([__REG_PRESSURE_MSB__]))
        self.i2c.readfrom_into(self.i2c_address, data)
        pressure, temp = struct.unpack(">HH", data)
        pressure >>= 6
        temp >>= 6
        pressure= self.a0 + (self.b1 + self.c12 * temp) * pressure + self.b2 * temp
        pressure = ((115-50)/1023) * pressure + 50
        temp = (temp - 498) / -5.35 + 25
        return pressure * 10, temp
    
   
if __name__ == "__main__":    
    mpl = MPL115A2()    
    print(mpl.a0, mpl.b1, mpl.b2, mpl.c12)
    print(mpl.get_data())
