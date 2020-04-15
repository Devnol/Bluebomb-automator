import os
from time import sleep
smver = 1
region = 1
console = input ("what console are you using?")
sleep(2)
if console == "1" :
    smver = input ("what version is your SM?")
elif console == "2" :
    region = input("what region is your Wii mini?")
command = "./bluebomb-auto-helper.sh -c {} -s {} -r {}".format(console, smver, region)
dir_comm = os.system("cd ~/Documents/git/Bluebomb-automator/")
exec_comm = os.system("chmod +x ~/Documents/git/Bluebomb-automator/bluebomb-auto-helper.sh")
run_comm = os.system(command)
print("directory changed with exit code %d" % dir_comm)
print("program chmodded with exit code %d" % exec_comm)
print("Bluebomb helper ran with exit code %d" % run_comm)
