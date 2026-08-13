#!/bin/bash

# Define color codes for terminal output
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

# Function to display the banner
banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"
}

# Function to remove packages and clean up
package() {
    echo -e "${R} [${W}-${R}]${C} Purging packages..."${W}
    
    # Remove the Ubuntu proot-distro and clear cache
    if proot-distro remove ubuntu && proot-distro clear-cache; then
        echo -e "${G} [${W}+${G}]${C} Ubuntu proot-distro removed successfully."${W}
    else
        echo -e "${R} [${W}-${R}]${C} Failed to remove Ubuntu proot-distro."${W}
        exit 1
    fi

    # Remove the ubuntu binary from the bin directory
    if rm -rf $PREFIX/bin/ubuntu; then
        echo -e "${G} [${W}+${G}]${C} Ubuntu binary removed successfully."${W}
    else
        echo -e "${R} [${W}-${R}]${C} Failed to remove Ubuntu binary."${W}
        exit 1
    fi

    # Remove pulseaudio configurations from ~/.sound
    if sed -i '/pulseaudio --start --exit-idle-time=-1/d' ~/.sound && \
       sed -i '/pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1/d' ~/.sound; then
        echo -e "${G} [${W}+${G}]${C} Pulseaudio configurations removed successfully."${W}
    else
        echo -e "${R} [${W}-${R}]${C} Failed to remove Pulseaudio configurations."${W}
        exit 1
    fi

    echo -e "${R} [${W}-${R}]${C} Purging Completed !"${W}
}

# Main script execution
banner
package
