#/usr/bin/env python3
import socket
import os
import random
import time
import PCF8591 as ADC
import RPi.GPIO as GPIO
from collections import OrderedDict
import math
 
UDP_IP = "130.245.183.173"
UDP_PORT = 5000
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
GAS = 17
TEMP = 19
FLAME = 16
GPIO.setmode(GPIO.BCM)
ADC.setup(0x48)
GPIO.setup(GAS,GPIO.IN)
GPIO.setup(TEMP,GPIO.IN)
GPIO.setup(FLAME,GPIO.IN)
ds18b20='28-031680039dff'
def setup():
	global ds18b20
	for i in os.listdir('/sys/bus/w1/devices'):
		if i!= 'w1-bus-master':
			ds18b20 = i
def read():
	location = '/sys/bus/w1/devices/'+ ds18b20 + '/w1_slave'
	tfile = open(location)
	text = tfile.read()
	tfile.close()
	secondline = text.split("\n")[1]
	temperaturedata = secondline.split(" ")[9]
	temperature = float(temperaturedata[2:])
	temperature = temperature / 1000
	return temperature
def loop():
    while(True):
        SITE_ROOT = os.path.realpath(os.path.dirname(__file__))
        json_url = os.path.join(SITE_ROOT, "data.json")
        mac =str( open('/sys/class/net/wlan0/address').read())
	mac = mac.replace('\n','')
	flame = 255-ADC.read(2)
	gas = 255- ADC.read(0)
	print('gas'+str(gas))
	print('flame'+str(flame))
        data= dict([("temp",read()),("flame",flame),("gas",gas),("timeStamp",time.time()),('mac',mac),('sound',random.randint(55,65))])
        encodedData= str(data).encode('ascii')
	encodedData= encodedData.replace("'",'"')
        sock.sendto(encodedData, (UDP_IP, 5000))
        print("done")
        time.sleep(5)
try:
    loop()
except KeyboardInterrupt:
    GPIO.cleanup()
