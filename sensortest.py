import PCF8591 as ADC
import RPi.GPIO as GPIO
import time
import math
import json

GAS = 17
TEMP = 19
FLAME = 16
GPIO.setmode(GPIO.BCM)
def setup():
    ADC.setup(0x48)
    GPIO.setup (GAS, GPIO.IN)
    GPIO.setup (TEMP, GPIO.IN)
    GPIO.setup (FLAME, GPIO.IN)

def loop():
    status = 1
    count = 0
    
    while True:
	analogVal = ADC.read(1)
	Vr = 5 * float(analogVal) /255
	Rt = 10000 *Vr / (5 - Vr)
	temp= 1/(((math.log(Rt/10000))/3950)+ (1/ (273.15+25)))
	temp = temp -273.15
        print('gas'+str(ADC.read(0)))
	print (analogVal)
	print('temp'+str(temp))
	print('flame'+str(ADC.read(2)))
        data = dict([('flame',ADC.read(0)),('gas',ADC.read(1)),('temp',ADC.read(2)),('isPolling','true'),('timestamp',time.time())])
        with open('data.json', 'w') as outfile:
            json.dump(data, outfile)
        time.sleep(0.2)
        
        


def destroy():
    GPIO.cleanup()
if __name__ == '__main__':
    try:
        setup()
        loop()
    except KeyboardInterrupt: 
        destroy()
