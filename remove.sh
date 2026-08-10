#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"

}

package() {
    echo -e "${R} [${W}-${R}]${C} Purging packages..."${W}
    proot-distro remove ubuntu && proot-distro clear-cache
    rm -rf $PREFIX/bin/ubuntu
    sed -i '/pulseaudio --start --exit-idle-time=-1/d' ~/.sound
    sed -i '/pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1/d' ~/.sound
    echo -e "${R} [${W}-${R}]${C} Purging Completed !"${W}

}

banner
package
