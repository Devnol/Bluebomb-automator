import os
dir_comm = os.system("cd ~/Documents/git/Bluebomb-automator/")
exec_comm = os.system("chmod +x ~/Documents/git/Bluebomb-automator/bluebomb-auto-helper.sh")
run_comm = os.system("./bluebomb-auto-helper.sh -c 2 -r 2")
print("directory changed with exit code %d" % dir_comm)
print("program chmodded with exit code %d" % exec_comm)
print("Bluebomb helper ran with exit code %d" % run_comm)
