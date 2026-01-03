#!/bin/bash

##############################################################################
#                                                                            #
#   MODDED UBUNTU PRO v3.0.0 - USER SETUP                                    #
#   Premium High-Performance Ubuntu GUI for Termux                           #
#                                                                            #
#   Original Script: modded-ubuntu                                           #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#                                                                            #
#   PRO Remake By: ZetaGo-Aurum                                              #
#   Brand: ALEOCROPHIC                                                       #
#                                                                            #
##############################################################################

# Colors
R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
M="\033[1;35m"
C="\033[1;36m"
W="\033[1;37m"
D="\033[0m"

VERSION="3.0.0 PRO"

banner() {
    clear
    echo -e "${M}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   ███╗   ███╗ ██████╗ ██████╗ ██████╗ ███████╗██████╗         ║
    ║   ████╗ ████║██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗        ║
    ║   ██╔████╔██║██║   ██║██║  ██║██║  ██║█████╗  ██║  ██║        ║
    ║   ██║╚██╔╝██║██║   ██║██║  ██║██║  ██║██╔══╝  ██║  ██║        ║
    ║   ██║ ╚═╝ ██║╚██████╔╝██████╔╝██████╔╝███████╗██████╔╝        ║
    ║   ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═════╝         ║
    ║                                                               ║
    ║   ██╗   ██╗██████╗ ██╗   ██╗███╗   ██╗████████╗██╗   ██╗      ║
    ║   ██║   ██║██╔══██╗██║   ██║████╗  ██║╚══██╔══╝██║   ██║      ║
    ║   ██║   ██║██████╔╝██║   ██║██╔██╗ ██║   ██║   ██║   ██║      ║
    ║   ██║   ██║██╔══██╗██║   ██║██║╚██╗██║   ██║   ██║   ██║      ║
    ║   ╚██████╔╝██████╔╝╚██████╔╝██║ ╚████║   ██║   ╚██████╔╝      ║
    ║    ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    ╚═════╝       ║
    ║                                                               ║
    ╠═══════════════════════════════════════════════════════════════╣
    ║              👤 U S E R   S E T U P  👤                       ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${D}"
    echo -e "${C}  ┌─────────────────────────────────────────────────────────────┐${D}"
    echo -e "${C}  │${W}  PRO Edition v${VERSION}  ${Y}│${M}  ZetaGo-Aurum ${Y}|${B} ALEOCROPHIC   ${C}│${D}"
    echo -e "${C}  └─────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

status_msg() {
    echo -e "  ${M}▸${C} $1${D}"
}

success_msg() {
    echo -e "  ${G}✓${W} $1${D}"
}

error_msg() {
    echo -e "  ${R}✗${W} $1${D}"
}

# Install sudo and dependencies
install_sudo() {
    status_msg "Installing system dependencies..."
    echo ""
    
    apt update -y > /dev/null 2>&1
    apt install sudo wget apt-utils locales-all dialog tzdata -y > /dev/null 2>&1
    
    success_msg "System dependencies installed"
}

# Create user account
create_user() {
    banner
    echo -e "  ${C}╔═══════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${C}║${W}              CREATE YOUR UBUNTU USER ACCOUNT             ${C}║${D}"
    echo -e "  ${C}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${C}║${Y}  Requirements:${D}                                            ${C}║${D}"
    echo -e "  ${C}║${W}    • Username must be lowercase${D}                           ${C}║${D}"
    echo -e "  ${C}║${W}    • No spaces or special characters${D}                      ${C}║${D}"
    echo -e "  ${C}║${W}    • Password should be memorable${D}                         ${C}║${D}"
    echo -e "  ${C}╚═══════════════════════════════════════════════════════════╝${D}"
    echo ""
    
    # Get username
    while true; do
        read -p "  $(echo -e ${G}Enter username ${Y}[lowercase]${G}: ${W})" user
        
        # Validate username
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
        read -sp "  $(echo -e ${G}Enter password: ${W})" pass
        echo ""
        
        if [[ -z "$pass" ]]; then
            error_msg "Password cannot be empty"
        elif [[ ${#pass} -lt 4 ]]; then
            error_msg "Password must be at least 4 characters"
        else
            read -sp "  $(echo -e ${G}Confirm password: ${W})" pass_confirm
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
    
    # Update Ubuntu login command
    echo "proot-distro login --user $user ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/ubuntu
    chmod +x /data/data/com.termux/files/usr/bin/ubuntu
    
    success_msg "Ubuntu login configured for user: $user"
    
    # Copy GUI script
    status_msg "Preparing GUI installer..."
    
    if [[ -e '/data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh' ]]; then
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh /home/$user/gui.sh
    else
        wget -q --show-progress https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/gui.sh -O /home/$user/gui.sh
    fi
    
    chmod +x /home/$user/gui.sh
    chown $user:$user /home/$user/gui.sh
    
    success_msg "GUI installer ready"
    
    # Final message
    echo ""
    echo -e "  ${G}╔═══════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${G}║${W}            🎉 USER SETUP COMPLETED! 🎉                    ${G}║${D}"
    echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${C}  Your user: ${Y}$user${D}                                          ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${C}  NEXT STEPS:${D}                                              ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${W}  1. Restart Termux completely${D}                            ${G}║${D}"
    echo -e "  ${G}║${W}  2. Type ${Y}ubuntu${W} to login as your user${D}                   ${G}║${D}"
    echo -e "  ${G}║${W}  3. Run ${Y}sudo bash gui.sh${W} for GUI + 124+ apps${D}            ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${G}║${M}  Note your VNC password when prompted during GUI setup!  ${G}║${D}"
    echo -e "  ${G}╚═══════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# Main execution
banner
install_sudo
create_user
