#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"

}

sudo() {
    echo -e "\n${R} [${W}-${R}]${C} Installing Sudo..."${W}
    apt update -y
    apt install sudo -y
    apt install wget apt-utils locales-all dialog -y
    echo -e "\n${R} [${W}-${R}]${G} Sudo Successfully Installed !"${W}
}

login() {
    banner
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m\en' user
    echo -e "${W}"
    echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers
    adduser $user
    echo "proot-distro login --user $user ubuntu" > /data/data/com.termux/files/usr/bin/ubuntu
    #chmod +x /data/data/com.termux/files/usr/bin/ubuntu 
    wget https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/gui.sh
    mv -vf gui.sh /home/$user/gui.sh
    chmod +x /home/$user/gui.sh
    clear
    echo
    echo -e "\n${R} [${W}-${R}]${G} Restart your Termux & Type ${C}ubuntu"${W}
    echo -e "\n${R} [${W}-${R}]${G} Then Type ${C}bash gui.sh "${W}
    echo

}

banner
sudo
login
