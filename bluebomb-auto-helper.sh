#!/bin/bash

version="v0.0.2"
helpmsg="Need further help? Send an e-mail to support@riiconnect24.net, or join the Discord server at https://discord.gg/b4Y7jfD and we'll try to assist."

# clear and greet
printf "Hello $USER, and welcome to the BlueBomb helper script.\n\nThis script will automatically check you have an environment capable of utilizing BlueBomb, download required files, and automate things as much as possible to make it easier for you, the end user, to perform the BlueBomb exploit on your Wii or Wii Mini console.\n\n" | fold -s -w $(tput cols)

# error handling
error() {
    clear
    printf "An error has occurred.\n\n* Task: $task\n* Command: $BASH_COMMAND\n* Line: $1\n* Exit code: $2\n\n" | fold -s -w $(tput cols)

    case "$task" in
        "Checking prerequisites - Internet connection" ) printf "NOTE: Please ensure that your PC has an active internet connection.\n\n" | fold -s -w $(tput cols)
    esac

    printf "$helpmsg\n" | fold -s -w $(tput cols)
    exit
}

trap 'error $LINENO $?' ERR
set -o pipefail
set -o errtrace

# receive parameters given on command line
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
    -v | --version ) printf "BlueBomb helper script\nVersion: $version\n" && exit ;;
    -r | --region ) shift; regionIn=$1 ;;
    -c | --console ) shift; consoleIn=$1 ;;
    -s | --sysmenu ) shift; sysmenuIn=$1 ;;
    -h | --help ) printf "\nUsage: $0 [options...]\n
    * -v --version\t\t\tDisplays the current version of the script.
    * -r --region <REGION>\t\tAllows you to select a region without needing to interact with the script.
    * -c --console <CONSOLE TYPE>\tAllows you to select a console type without needing to interact with the script.
    * -s --sysmenu <SYSMENU VERSION>\tAllows you to select a sysmenu version without needing to interact with the script.
    * -h --help\t\t\t\tDisplays this help message.\n\n$helpmsg\n" | fold -s -w $(tput cols)
        exit
        ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

# check prerequisites

task="Checking prerequisites - Dependencies"
## detect non-linux kernel users
[[ -z "$(uname -s | grep 'Linux')" ]] && printf "\n\nThis script does not work on systems that don't use the Linux kernel.\n\n" && exit

## detect architecture
if [[ -n "$(uname -m | grep 'arm*\|aarch*')" ]]; then
    arch="arm"
elif [[ -n "$(uname -m | grep 'x86_64')" ]]; then
    arch="x64"
elif [[ -n "$(uname -m | grep 'i686')" ]]; then
    arch="x86"
else
    printf "Unable to use your architecture ($(uname -m)).\n$helpmsg\n"
    exit
fi
printf "* Detected architecture: $arch\n\n"

dependencies=("curl" "unzip" "bluetoothctl")

for i in "${dependencies[@]}"; do
    [[ -z "$(command -v ${dependencies[i]})" ]] && printf "${dependencies[i]} is not installed. Please install it using your preferred package manager.\n" && exit
done

## detect init system
if [[ -e "$(command -v systemctl)" ]]; then
    init="systemd"
elif [[ -e "$(command -v openrc)" ]]; then
    init="openrc"
else
    printf "Unable to detect your init system.\n$helpmsg\n"
    exit
fi
printf "* Detected init system: $init\n\n"

download() {
    [ -e bluebomb ] && printf "BlueBomb exists. Not downloading.\n" && cd bluebomb && return
    task="Checking Prerequisites - Internet connection"
    printf "* Checking internet connection... "
    ping -c 3 github.com > /dev/null
    printf "Success!\n\n* Downloading BlueBomb... "
    task="Download and extract BlueBomb"
    ## download zip from github
    mkdir -p bluebomb && cd bluebomb
    curl -sL "https://github.com/Fullmetal5/bluebomb/releases/download/1.5/bluebomb1.5.zip" -o bluebomb.zip
    printf "Success!\n\n* Unpacking BlueBomb... "
    unzip -q bluebomb.zip
    rm bluebomb.zip
    printf "Success!\n\n"
}

ask() {
    task="Get correct removable drive (USB)"
}

findinfos() {
    clear
    task="Get console information from user"
    if [[ -z $consoleIn ]]; then
        printf "What is the console type?\n\nOPTIONS:\n\t[1]: Wii\n\t[2]: Wii Mini\n\nPlease type your selection and then press ENTER: "
        read -r consoleIn
    fi
    case "$consoleIn" in
        "1" | "Wii" ) arg1="WII_SM" ;;
        "2" | "Wii Mini" ) arg1="MINI_SM_" ;;
        * ) printf "Invalid selection.\n"; findinfos ;;
    esac
    if [[ $arg1 == "MINI_SM_" ]]; then
        if [[ -z $regionIn ]]; then
            clear
            printf "Which region is your Wii Mini?\n\nOPTIONS:\n\t[1]: USA\n\t[2]: PAL\n\nPlease type your selection and then press ENTER: "
            read -r regionIn
        fi
        case "$regionIn" in
            "1" | "NTSC" ) arg2="NTSC" ;;
            "2" | "PAL" ) arg2="PAL" ;;
            * ) printf "Invalid selection.\n"; findinfos ;;
        esac
    fi
    if [[ $arg1 == "WII_SM" ]]; then
      if [[ -z $sysmenuIn ]]; then
         clear
         printf "Which System Version is your Wii?\n\nPlease type your selection and press ENTER: "
         read -r sysmenuIn
      fi
      case "$sysmenuIn" in
          "1" | "2.0E" ) arg2="2_0E" ;;
          "2" | "2.0J" ) arg2="2_0J" ;;
          "3" | "2.0U" ) arg2="2_0U" ;;
          "4" | "2.1E" ) arg2="2_1E" ;;
          "5" | "2.2E" ) arg2="2_2E" ;;
          "6" | "2.2J" ) arg2="2_2J" ;;
          "7" | "2.2U" ) arg2="2_2U" ;;
          "8" | "3.0E" ) arg2="3_0E" ;;
          "9" | "3.0J" ) arg2="3_0J" ;;
          "10" | "3.0U" ) arg2="3_0U" ;;
          "11" | "3.1E" ) arg2="3_1E" ;;
          "12" | "3.1J" ) arg2="3_1J" ;;
          "13" | "3.1U" ) arg2="3_1U" ;;
          "14" | "3.2E" ) arg2="3_2E" ;;
          "15" | "3.2J" ) arg2="3_2J" ;;
          "16" | "3.2U" ) arg2="3_2U" ;;
          "17" | "3.3E" ) arg2="3_3E" ;;
          "18" | "3.3J" ) arg2="3_3J" ;;
          "19" | "3.3U" ) arg2="3_3U" ;;
          "20" | "3.4E" ) arg2="3_4E" ;;
          "21" | "3.4J" ) arg2="3_4J" ;;
          "22" | "3.4U" ) arg2="3_4U" ;;
          "23" | "3.5K" ) arg2="3_5K" ;;
          "24" | "4.0E" ) arg2="4_0E" ;;
          "25" | "4.0J" ) arg2="4_0J" ;;
          "26" | "4.0U" ) arg2="4_0U" ;;
          "27" | "4.1E" ) arg2="4_1E" ;;
          "28" | "4.1J" ) arg2="4_1J" ;;
          "29" | "4.1K" ) arg2="4_1K" ;;
          "30" | "4.1U" ) arg2="4_1U" ;;
          "31" | "4.2E" ) arg2="4_2E" ;;
          "32" | "4.2J" ) arg2="4_2J" ;;
          "33" | "4.2K" ) arg2="4_2K" ;;
          "34" | "4.2U" ) arg2="2_0J" ;;
          "35" | "4.3E" ) arg2="4_3E" ;;
          "36" | "4.3J" ) arg2="4_3J" ;;
          "37" | "4.3K" ) arg2="4_3K" ;;
          "38" | "4.3U" ) arg2="4_3U" ;;
          * ) printf "Invalid selection.\n"; findinfos ;;
      esac
    fi
    task="Execute BlueBomb"
    echo "Code ran: sudo ./bluebomb-$arch ./stage0/$arg1$arg2.bin stage1.bin"
    sudo ./bluebomb-$arch ./stage0/$arg1$arg2.bin stage1.bin
}

download
ask
findinfos
