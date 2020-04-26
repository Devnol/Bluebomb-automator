import os
from time import sleep
from gpiozero import Button
from RPLCD.i2c import CharLCD
import smbus
#Adjust these options for your device:
lcdexpander = 'PCF8574' #the ic of the expander: PCF8574, MCP23008 or MCP23017 
lcdaddr = 0x3F #the address of the lcd (with 0x before it) Replace with your lcd address
lcdport = 1 #leave as-is for most Raspberry Pis. Change to 0 if you have a Pi Model B Rev 1
lcdcols = 16 #the columns of the lcd (vertical char lines)
lcdrows = 2 #the rows of the lcd (horizontal char lines) 

lcd = CharLCD(i2c_expander=lcdexpander, address=lcdaddr,
              port=lcdport, cols=lcdcols, rows=lcdrows) #initialise lcd

console = 1 # set config variables
smver = 1 # ~
region = 1 # ~
smverList = "2.0E", "2.0J", "2.0U", "2.1E", "2.2E", "2.2J", "2.2U", "3.0E", "3.0J", "3.0U", "3.1E", "3.1J", "3.1U", "3.2E", "3.2J", "3.2U", "3.3E", "3.3J", 
"3.3U", "3.4E", "3.4J", "3.4U", "3.5K", "4.0E", "4.0J", "4.0U", "4.1E", "4.1J", "4.1K", "4.1U", "4.2E", "4.2J", "4.2K", "4.2U", "4.3E", "4.3J", "4.3K", "4.3U"
Left = Button(23) # set button pins
Select = Button(24) # ~
Right = Button(25) # ~

def selConsole():
    global console
    lcd.write_string('Console Type:\n\rWii')
    while not Select.is_pressed:
        if Left.is_pressed or Right.is_pressed:
            if console == 1:
                console = 2
                sleep(0.15)
            elif console == 2:
                console = 1
                sleep(0.15)
            lcd.clear()
            if console == 1:
                    lcd.write_string('Console Type:\n\rWii')
            elif console == 2:
                    lcd.write_string('Console Type:\n\rWii mini')
    lcd.clear()
    lcd.cursor_pos  = (0, 0)
    lcd.write_string('console set')
    sleep(2)
    
def selMiniRegion():
    global region
    lcd.write_string('Wii mini region:\n\rNTSC')
    while not Select.is_pressed:
        if Left.is_pressed or Right.is_pressed:
            if region == 1:
                region = 2
                sleep(0.15)
            elif region == 2:
                region = 1
                sleep(0.15)
            lcd.clear()
            if region == 1:
                lcd.write_string('Wii mini region:\n\rNTSC')
            elif region == 2:
                lcd.write_string('Wii mini region:\n\rPAL')

    lcd.clear()
    lcd.cursor_pos = (0, 0)
    lcd.write_string('region set')
    sleep(2)
while True:
    lcd.clear()
    lcd.cursor_pos = (0, 0)
    lcd.write_string('Bluebomb\n\rhelper v0.3')
    sleep(2)
    lcd.clear()
    lcd.cursor_pos  = (0, 0)
    selConsole()
    lcd.clear()
    lcd.cursor_pos  = (0, 0)
    if console == 1:
        print('Wii chosen')
    elif console == 2:
        print('Wii mini chosen')
    selMiniRegion()
    lcd.clear()
    lcd.cursor_pos  = (0, 0)
    if region == 1:
        print('NTSC chosen')
    elif region == 2:
        print('PAL chosen')
    # command = "./bluebomb-auto-helper.sh -c {} -s {} -r {}".format(console, smver, region)
    # dir_comm = os.system("cd ~/Documents/git/Bluebomb-automator/")
    # exec_comm = os.system("chmod +x ~/Documents/git/Bluebomb-automator/bluebomb-auto-helper.sh")
    # run_comm = os.system(command)
    # print("directory changed with exit code %d" % dir_comm)
    # print("program chmodded with exit code %d" % exec_comm)
    # print("Bluebomb helper ran with exit code %d" % run_comm)
