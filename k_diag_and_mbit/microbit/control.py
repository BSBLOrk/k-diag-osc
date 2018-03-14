
from microbit import *
uart.init(baudrate=115200)

while True:
    x,y,z=accelerometer.get_values()
    if (button_a.is_pressed() or button_b.is_pressed()) :
        uart.write("%s,%s,%s,%s,%s,\n\r" % (x,y,z,"%d" % button_a.is_pressed(),"%d" % button_b.is_pressed()))
    sleep(10)