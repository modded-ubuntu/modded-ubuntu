#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

# Logging function
log() {
    local LOG_FILE="/data/data/com.termux/files/home/modded-ubuntu/logs/script.log"
    local LOG_DIR=$(dirname "$LOG_FILE")
    
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR" || { echo "Failed to create log directory"; exit 1; }
    fi
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE" || { echo "Failed to write to log file"; exit 1; }
}

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded GUI version of Ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"
}

install_sudo() {
    log "Installing Sudo..."
    echo -e "\n${R} [${W}-${R}]${C} Installing Sudo..."${W}
    apt update -y || { log "Failed to update apt"; exit 1; }
    apt install sudo -y || { log "Failed to install sudo"; exit 1; }
    apt install wget apt-utils locales-all dialog tzdata -y || { log "Failed to install additional packages"; exit 1; }
    log "Sudo installation completed."
    echo -e "\n${R} [${W}-${R}]${G} Sudo Successfully Installed!${W}"
}

login() {
    banner
    log "Starting user login setup."
    while true; do
        read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m' user
        if [[ "$user" =~ ^[a-z]+$ ]]; then
            break
        else
            echo -e "${R}Username must be lowercase and contain no special characters.${W}"
        fi
    done
    echo -e "${W}"
    while true; do
        read -sp $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m' pass
        if [ -n "$pass" ]; then
            break
        else
            echo -e "${R}Password cannot be empty.${W}"
        fi
    done
    echo -e "${W}"
    useradd -m -s $(which bash) ${user} || { log "Failed to add user"; exit 1; }
    usermod -aG sudo ${user} || { log "Failed to add user to sudo group"; exit 1; }
    echo "${user}:${pass}" | chpasswd || { log "Failed to set password"; exit 1; }
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers || { log "Failed to update sudoers file"; exit 1; }

    # Create the ubuntu command for proot-distro
    echo "proot-distro login --user $user ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/ubuntu
    chmod +x /data/data/com.termux/files/usr/bin/ubuntu || { log "Failed to set permissions for ubuntu command"; exit 1; }

    # Download and set up the GUI script
    if [[ -e '/data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh' ]]; then
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh "/home/$user/gui.sh"
        chmod +x "/home/$user/gui.sh" || { log "Failed to set permissions for gui.sh"; exit 1; }
    else
        wget -q --show-progress "https://raw.githubusercontent.com/Midohajhouj/modded-ubuntu/master/distro/gui.sh" -O "/home/$user/gui.sh"
        chmod +x "/home/$user/gui.sh" || { log "Failed to set permissions for gui.sh"; exit 1; }
    fi

    log "User login setup completed for user: $user"
    clear
    echo
    echo -e "\n${R} [${W}-${R}]${G} Restart your Termux & Type ${C}ubuntu${W}"
    echo -e "\n${R} [${W}-${R}]${G} Skip to graphical Interface with ${C}sudo bash gui.sh${W}"
    echo
}

# Main script execution
banner
install_sudo
login
