#!/bin/bash

##############################################################################
#                                                                            #
#   MODDED UBUNTU PRO v3.1.0 - USER SETUP                                    #
#   Premium High-Performance Ubuntu GUI for Termux                           #
#                                                                            #
#   Original Script: modded-ubuntu                                           #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#                                                                            #
#   PRO Remake By: ZetaGo-Aurum                                              #
#   Brand: ALEOCROPHIC                                                       #
#                                                                            #
##############################################################################

# ═══════════════════════════════════════════════════════════════════════════
# COLOR PALETTE
# ═══════════════════════════════════════════════════════════════════════════
R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
M="\033[1;35m"
C="\033[1;36m"
W="\033[1;37m"
D="\033[0m"

PURPLE="\033[38;5;141m"
PINK="\033[38;5;213m"
CYAN_L="\033[38;5;81m"
GREEN_L="\033[38;5;120m"
ORANGE="\033[38;5;208m"
GRAY="\033[38;5;245m"
DGRAY="\033[38;5;238m"

BG_DGRAY="\033[48;5;236m"

VERSION="3.1.0 PRO"

# ═══════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    clear
    echo ""
    echo -e "${PURPLE}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║   ███╗   ███╗ ██████╗ ██████╗ ██████╗ ███████╗██████╗             ║
    ║   ████╗ ████║██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗            ║
    ║   ██╔████╔██║██║   ██║██║  ██║██║  ██║█████╗  ██║  ██║            ║
    ║   ██║╚██╔╝██║██║   ██║██║  ██║██║  ██║██╔══╝  ██║  ██║            ║
    ║   ██║ ╚═╝ ██║╚██████╔╝██████╔╝██████╔╝███████╗██████╔╝            ║
    ║   ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═════╝             ║
    ║                                                                   ║
    ║   ██╗   ██╗██████╗ ██╗   ██╗███╗   ██╗████████╗██╗   ██╗          ║
    ║   ██║   ██║██╔══██╗██║   ██║████╗  ██║╚══██╔══╝██║   ██║          ║
    ║   ██║   ██║██████╔╝██║   ██║██╔██╗ ██║   ██║   ██║   ██║          ║
    ║   ██║   ██║██╔══██╗██║   ██║██║╚██╗██║   ██║   ██║   ██║          ║
    ║   ╚██████╔╝██████╔╝╚██████╔╝██║ ╚████║   ██║   ╚██████╔╝          ║
    ║    ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    ╚═════╝           ║
    ║                                                                   ║
    ╠═══════════════════════════════════════════════════════════════════╣
    ║              👤 U S E R   S E T U P   v3.1.0 👤                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${D}"
    echo -e "${CYAN_L}  ┌───────────────────────────────────────────────────────────────────┐${D}"
    echo -e "${CYAN_L}  │${W}  PRO Edition v${VERSION}   ${Y}│${PINK}  ZetaGo-Aurum ${Y}│${PURPLE} ALEOCROPHIC${CYAN_L}      │${D}"
    echo -e "${CYAN_L}  └───────────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

status_msg() { echo -e "\n  ${PURPLE}▸${CYAN_L} $1${D}"; }
success_msg() { echo -e "  ${GREEN_L}✓${W} $1${D}"; }
error_msg() { echo -e "  ${R}✗${W} $1${D}"; }
warning_msg() { echo -e "  ${ORANGE}⚠${W} $1${D}"; }
info_msg() { echo -e "  ${CYAN_L}ℹ${W} $1${D}"; }

section_header() {
    echo ""
    echo -e "  ${BG_DGRAY}${W} $1 ${D}"
    echo -e "  ${DGRAY}$(printf '─%.0s' {1..60})${D}"
}

# ═══════════════════════════════════════════════════════════════════════════
# INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

install_sudo() {
    section_header "📦 INSTALLING SYSTEM DEPENDENCIES"
    
    status_msg "Installing required packages..."
    
    apt update -y > /dev/null 2>&1
    apt install sudo wget apt-utils locales-all dialog tzdata -y > /dev/null 2>&1
    
    success_msg "System dependencies installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# USER CREATION
# ═══════════════════════════════════════════════════════════════════════════

create_user() {
    banner
    section_header "👤 CREATE YOUR UBUNTU USER ACCOUNT"
    
    echo ""
    echo -e "  ${CYAN_L}╔═══════════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${CYAN_L}║${Y}  Requirements:${D}                                                ${CYAN_L}║${D}"
    echo -e "  ${CYAN_L}║${W}    • Username must be lowercase${D}                               ${CYAN_L}║${D}"
    echo -e "  ${CYAN_L}║${W}    • No spaces or special characters${D}                          ${CYAN_L}║${D}"
    echo -e "  ${CYAN_L}║${W}    • Password should be memorable${D}                             ${CYAN_L}║${D}"
    echo -e "  ${CYAN_L}╚═══════════════════════════════════════════════════════════════╝${D}"
    echo ""
    
    # Get username
    while true; do
        read -p "  $(echo -e ${GREEN_L}Enter username ${Y}[lowercase]${GREEN_L}: ${W})" user
        
        if [[ -z "$user" ]]; then
            error_msg "Username cannot be empty"
        elif [[ ! "$user" =~ ^[a-z][a-z0-9_-]*$ ]]; then
            error_msg "Username must start with lowercase letter and contain only a-z, 0-9, _, -"
        elif [[ ${#user} -lt 2 ]]; then
            error_msg "Username must be at least 2 characters"
        else
            break
        fi
    done
    echo ""
    
    # Get password
    while true; do
        read -sp "  $(echo -e ${GREEN_L}Enter password: ${W})" pass
        echo ""
        
        if [[ -z "$pass" ]]; then
            error_msg "Password cannot be empty"
        elif [[ ${#pass} -lt 4 ]]; then
            error_msg "Password must be at least 4 characters"
        else
            read -sp "  $(echo -e ${GREEN_L}Confirm password: ${W})" pass_confirm
            echo ""
            
            if [[ "$pass" != "$pass_confirm" ]]; then
                error_msg "Passwords do not match"
            else
                break
            fi
        fi
    done
    
    echo ""
    status_msg "Creating user account: ${Y}$user${D}"
    
    # Create user
    useradd -m -s $(which bash) "$user" 2>/dev/null
    usermod -aG sudo "$user"
    echo "${user}:${pass}" | chpasswd
    
    # Configure sudoers
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    
    success_msg "User account created"
    
    # Update Ubuntu login command with proper proot options
    echo "proot-distro login --user $user ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/ubuntu
    chmod +x /data/data/com.termux/files/usr/bin/ubuntu
    
    success_msg "Ubuntu login configured for user: $user"
    
    # Copy GUI script
    status_msg "Preparing GUI installer..."
    
    if [[ -e '/data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh' ]]; then
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh /home/$user/gui.sh
    else
        wget -q --show-progress https://raw.githubusercontent.com/ZetaGo-Aurum/modded-ubuntu/master/distro/gui.sh -O /home/$user/gui.sh
    fi
    
    chmod +x /home/$user/gui.sh
    chown $user:$user /home/$user/gui.sh
    
    success_msg "GUI installer ready"
    
    # Copy settings script if available
    if [[ -e '/data/data/com.termux/files/home/modded-ubuntu/distro/settings.sh' ]]; then
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/settings.sh /usr/local/bin/mu-settings
        chmod +x /usr/local/bin/mu-settings
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/settings.sh /usr/local/bin/acro-settings
        chmod +x /usr/local/bin/acro-settings
        success_msg "Settings utility installed"
    fi
    
    # Copy DIY script if available
    if [[ -e '/data/data/com.termux/files/home/modded-ubuntu/distro/acro-diy.sh' ]]; then
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/acro-diy.sh /usr/local/bin/mu-diy
        chmod +x /usr/local/bin/mu-diy
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/acro-diy.sh /usr/local/bin/acro-diy
        chmod +x /usr/local/bin/acro-diy
        success_msg "DIY utility installed"
    fi
    
    # Final message
    echo ""
    echo -e "  ${GREEN_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${GREEN_L}║${W}              🎉 USER SETUP COMPLETED! 🎉                        ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${CYAN_L}  Your user: ${Y}$user${D}                                                  ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${CYAN_L}  NEXT STEPS:${D}                                                      ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  1. Restart Termux completely${D}                                     ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  2. Type ${Y}ubuntu${W} to login as your user${D}                            ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  3. Run ${Y}sudo bash gui.sh${W} for GUI + 1000+ apps${D}                     ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${ORANGE}  📝 Note: VNC password will be set during GUI installation${D}       ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${GRAY}  After GUI, use 'mu-settings' to configure language/VNC${D}         ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

banner
install_sudo
create_user
