#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
UBUNTU_DIR="$PREFIX/var/lib/proot-distro/containers/ubuntu/rootfs"

# Logging function
log() {
    local LOG_FILE="${PREFIX:-/data/data/com.termux/files/usr}/tmp/script.log"
    local LOG_DIR=$(dirname "$LOG_FILE")
    
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR" || {
            echo "Failed to create log directory: $LOG_DIR" >&2
            exit 1
        }
    fi
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
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

package() {
    banner
    log "Checking required packages..."
    echo -e "${R} [${W}-${R}]${C} Checking required packages...${W}"
    
    if [ ! -d '/data/data/com.termux/files/home/storage' ]; then
        log "Setting up storage..."
        echo -e "${R} [${W}-${R}]${C} Setting up Storage...${W}"
        termux-setup-storage
    fi

    if [[ $(command -v pulseaudio) && $(command -v proot-distro) ]]; then
        log "Packages already installed."
        echo -e "\n${R} [${W}-${R}]${G} Packages already installed.${W}"
    else
        if ! command -v pkg &> /dev/null; then
            echo "Package manager 'pkg' is not installed. Please install Termux properly." >&2
            exit 1
        fi

        yes | pkg upgrade
        packs=(pulseaudio proot-distro)
        for x in "${packs[@]}"; do
            if ! pkg install -y "$x"; then
                log "Failed to install package: $x"
                echo -e "\n${R} [${W}-${R}]${G} Failed to install package: ${Y}$x${C}${W}"
                exit 1
            fi
        done
    fi
}

distro() {
    echo -e "\n${R} [${W}-${R}]${C} Checking for Distro...${W}"
    termux-reload-settings
    
    if [[ -d "$UBUNTU_DIR" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Distro already installed.${W}"
        return 0
    else
        if ! proot-distro install ubuntu; then
            echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !\n${W}"
            exit 1
        fi
        termux-reload-settings
    fi
    
    if [[ -d "$UBUNTU_DIR" ]]; then
        echo -e "\n${R} [${W}-${R}]${G} Installed Successfully !!${W}"
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !\n${W}"
        exit 1
    fi
}

sound() {
    echo -e "\n${R} [${W}-${R}]${C} Fixing Sound Problem...${W}"
    [ ! -e "$HOME/.sound" ] && touch "$HOME/.sound"
    
    if ! grep -q "pacmd load-module module-aaudio-sink" "$HOME/.sound"; then
        echo "pacmd load-module module-aaudio-sink" >> "$HOME/.sound"
    fi

    if ! grep -q "pacmd load-module module-aaudio-source" "$HOME/.sound"; then
        echo "pacmd load-module module-aaudio-source" >> "$HOME/.sound"
    fi

    if ! grep -q "pulseaudio --start --exit-idle-time=-1" "$HOME/.sound"; then
        echo "pulseaudio --start --exit-idle-time=-1" >> "$HOME/.sound"
    fi

    if ! grep -q "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" "$HOME/.sound"; then
        echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> "$HOME/.sound"
    fi
}

downloader() {
    path="$1"
    [ -e "$path" ] && rm -rf "$path"
    echo "Downloading $(basename "$1")..."
    
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Please install curl." >&2
        exit 1
    fi

    if ! curl --progress-bar --insecure --fail --retry-connrefused --retry 3 --retry-delay 2 --location --output "${path}" "$2"; then
        echo -e "\n${R} [${W}-${R}]${G} Failed to download $(basename "$1")!${W}"
        exit 1
    fi
    echo
}

setup_vnc() {
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstart" ]]; then
        cp -f "$CURR_DIR/distro/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
    else
        downloader "$CURR_DIR/vncstart" "https://raw.githubusercontent.com/afonsoft/modded-ubuntu/master/distro/vncstart"
        mv -f "$CURR_DIR/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
    fi

    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstop" ]]; then
        cp -f "$CURR_DIR/distro/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
    else
        downloader "$CURR_DIR/vncstop" "https://raw.githubusercontent.com/afonsoft/modded-ubuntu/master/distro/vncstop"
        mv -f "$CURR_DIR/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
    fi
    chmod +x "$UBUNTU_DIR/usr/local/bin/vncstart"
    chmod +x "$UBUNTU_DIR/usr/local/bin/vncstop"
}

permission() {
    banner
    echo -e "${R} [${W}-${R}]${C} Setting up Environment...${W}"

    # Setup user.sh
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/user.sh" ]]; then
        cp -f "$CURR_DIR/distro/user.sh" "$UBUNTU_DIR/root/user.sh"
    else
        downloader "$CURR_DIR/user.sh" "https://raw.githubusercontent.com/afonsoft/modded-ubuntu/master/distro/user.sh"
        mv -f "$CURR_DIR/user.sh" "$UBUNTU_DIR/root/user.sh"
    fi
    chmod +x "$UBUNTU_DIR/root/user.sh"

    setup_vnc
    echo "$(getprop persist.sys.timezone)" > "$UBUNTU_DIR/etc/timezone"
    echo "proot-distro login ubuntu" > "$PREFIX/bin/ubuntu"
    chmod +x "$PREFIX/bin/ubuntu"
    termux-reload-settings

    if [[ -e "$PREFIX/bin/ubuntu" ]]; then
        banner
        cat <<- EOF
			${R} [${W}-${R}]${G} Ubuntu-26.04 (CLI) is now Installed on your Termux
			${R} [${W}-${R}]${G} Restart your Termux to Prevent Some Issues.
			${R} [${W}-${R}]${G} Type ${C}ubuntu${G} to run Ubuntu CLI.
			${R} [${W}-${R}]${G} If you Want to Use UBUNTU in GUI MODE then ,
			${R} [${W}-${R}]${G} Run ${C}ubuntu${G} first & then type ${C}bash user.sh${W}
		EOF
        { echo; sleep 2; exit 0; }
    else
        echo -e "\n${R} [${W}-${R}]${G} Error Installing Distro !${W}"
        exit 1
    fi
}

package
distro
sound
permission
