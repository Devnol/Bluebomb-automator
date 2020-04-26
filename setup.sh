
install(){
sudo apt-get install python3-pip
sudo apt-get install python-pip
pip3 install adafruit-blinka
pip3 install adafruit-circuitpython-charlcd
pip3 install gpiozero
pip3 install RPLCD
pip3 install board
}
# Ignore these, they will be added in a future release
#sleep 3
#clear
#printf "Would you like to make the program run on boot? Type the version you want to install or type no to skip this. [i2c/gpio/n]"
#read -r bootset
#case "${confirmation^^}" in
#        "i2c" | "I2C" ) sudo cp Bluebomb-automator-i2c.py /etc/init.d/Bluebomb-automator.py
#        "gpio"| "GPIO") sudo cp Bluebomb-automator-gpio.py /etc/init.d/Bluebomb-automator.py
#        * ) exit
#esac
#BootScript=/etc/init.d/Bluebomb-automator.py
#if test -f "$FILE"; then
#	uninstall
#else
#	install
#fi

printf "This script will satisfy all of the dependencies required to run either versions of the bluebomb automator python script.\n Would you like to perform this action [y/n]?\n Please note that all dependencies will only be installed for the current user\n and that you may be prompted for confirmation."
read -r confirmation
case "${confirmation^^}" in
	"Y" | "YES" ) install ;;
	* ) exit ;;
esac 
printf "Installation complete!\nFor any questions please visit\nthe Wii mini hacking Discord server tagging @Commandblock6417"
exit 
