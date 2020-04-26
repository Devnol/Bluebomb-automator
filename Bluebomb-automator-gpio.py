import os
from time import sleep
from gpiozero import Button
import board
import adafruit_character_lcd.character_lcd as charlcd
import digitalio

# lcd setup
lcd_columns = 16
lcd_rows = 2
lcd_rs = digitalio.DigitalInOut(board.D5)
lcd_en = digitalio.DigitalInOut(board.D6)
lcd_d4 = digitalio.DigitalInOut(board.D21)
lcd_d5 = digitalio.DigitalInOut(board.D22)
lcd_d6 = digitalio.DigitalInOut(board.D23)
lcd_d7 = digitalio.DigitalInOut(board.D24)
lcd = charlcd.Character_LCD_Mono(lcd_rs, lcd_en, lcd_d4, lcd_d5, lcd_d6, lcd_d7, lcd_columns, lcd_rows) # init lcd

console = 1 # set config variables
smver = 1 # ~
region = 1 # ~
smverList = " ", "2.0E", "2.0J", "2.0U", "2.1E", "2.2E", "2.2J", "2.2U", "3.0E", "3.0J", "3.0U", "3.1E", "3.1J", "3.1U", "3.2E", "3.2J", "3.2U", "3.3E", "3.3J", 
"3.3U", "3.4E", "3.4J", "3.4U", "3.5K", "4.0E", "4.0J", "4.0U", "4.1E", "4.1J", "4.1K", "4.1U", "4.2E", "4.2J", "4.2K", "4.2U", "4.3E", "4.3J", "4.3K", "4.3U"
Left = Button(2) # set button pins
Select = Button(3) # ~
Right = Button(4) # ~

def selConsole():
    global console
    consoleBuffer = console
    lcd.message = "Console Type:\nWii"
    while not Select.is_pressed:
        if consoleBuffer != console:
            lcd.clear()
        consoleBuffer = console
        if Left.is_pressed or Right.is_pressed:
            if console == 1:
                console = 2
                sleep(0.15)
            elif console == 2:
                console = 1
                sleep(0.15)
        if console == 1:
                lcd.message = "Console Type:\nWii"
        elif console == 2:
                lcd.message = "Console Type:\nWii mini"
    lcd.clear()
    lcd.message = "console set"
    sleep(1)
    
def selMiniRegion():
    global region
    regionBuffer = region
    lcd.message = "Wii mini region:\nNTSC"
    while not Select.is_pressed:
        if regionBuffer != region:
            lcd.clear()
        regionBuffer = region
        if Left.is_pressed or Right.is_pressed:
            if region == 1:
                region = 2
                sleep(0.15)
            elif region == 2:
                region = 1
                sleep(0.15)
        if region == 1:
                lcd.message = "Wii mini region:\nNTSC"
        elif region == 2:
                lcd.message = "Wii mini region:\nPAL"

    lcd.clear()
    lcd.message = "region set"
    sleep(1)
while True:
    lcd.message = 'Bluebomb\nhelper v0.2'
    sleep(2)
    lcd.clear()
    selConsole()
    lcd.clear()
    if console == 1:
        print('Wii chosen')
    elif console == 2:
        print('Wii mini chosen')
        selMiniRegion()
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
 