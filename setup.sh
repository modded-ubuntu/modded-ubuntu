#!/bin/bash

##############################################################################
#                                                                            #
#   MODDED UBUNTU PRO v3.0.0                                                 #
#   Premium High-Performance Ubuntu GUI for Termux                           #
#                                                                            #
#   Original Script: modded-ubuntu                                           #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#   Original Repo: https://github.com/modded-ubuntu/modded-ubuntu            #
#                                                                            #
#   PRO Remake By: ZetaGo-Aurum                                              #
#   Brand: ALEOCROPHIC                                                       #
#   Features: 124+ Pre-installed Software, Automatic Setup, Audio Fix       #
#                                                                            #
##############################################################################

# Colors - Premium Theme
R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
M="\033[1;35m"
C="\033[1;36m"
W="\033[1;37m"
D="\033[0m"
BG_B="\033[44m"
BG_M="\033[45m"
BOLD="\033[1m"

CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
UBUNTU_DIR="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
VERSION="3.0.0 PRO"

# Premium ASCII Banner
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
    ║              🚀 P R O   E D I T I O N   v3.0.0 🚀             ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${D}"
    echo -e "${C}  ┌─────────────────────────────────────────────────────────────┐${D}"
    echo -e "${C}  │${W}  Premium Ubuntu GUI for Termux  ${Y}│${G} 124+ Features${C}             │${D}"
    echo -e "${C}  │${M}  Remake by: ZetaGo-Aurum        ${Y}│${B} Brand: ALEOCROPHIC${C}       │${D}"
    echo -e "${C}  └─────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

# Progress bar function
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r  ${C}[${G}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${W}"
    printf "%${empty}s" | tr ' ' '░'
    printf "${C}]${W} %3d%% ${D}" $percentage
}

# Status message
status_msg() {
    echo -e "\n  ${M}▸${C} $1${D}"
}

# Success message
success_msg() {
    echo -e "  ${G}✓${W} $1${D}"
}

# Error message
error_msg() {
    echo -e "  ${R}✗${W} $1${D}"
}

# Check and install packages
package() {
    banner
    status_msg "Initializing PRO Installation..."
    echo ""
    
    # Setup storage
    if [ ! -d '/data/data/com.termux/files/home/storage' ]; then
        status_msg "Setting up Storage Access..."
        termux-setup-storage
        sleep 2
    fi
    success_msg "Storage configured"
    
    # Required packages
    local required_packages=(pulseaudio proot-distro wget curl)
    local total=${#required_packages[@]}
    local current=0
    
    status_msg "Installing Termux dependencies..."
    echo ""
    
    yes | pkg update -y > /dev/null 2>&1
    yes | pkg upgrade -y > /dev/null 2>&1
    
    for pkg_name in "${required_packages[@]}"; do
        current=$((current + 1))
        progress_bar $current $total
        
        if ! command -v "$pkg_name" &> /dev/null; then
            yes | pkg install "$pkg_name" -y > /dev/null 2>&1
        fi
    done
    
    echo ""
    success_msg "All Termux dependencies installed"
}

# Install distribution
distro() {
    echo ""
    status_msg "Checking for Ubuntu distribution..."
    termux-reload-settings
    
    if [[ -d "$UBUNTU_DIR" ]]; then
        success_msg "Ubuntu distribution already installed"
        echo -e "  ${Y}!${W} Run 'proot-distro reset ubuntu' to reinstall${D}"
        return 0
    fi
    
    status_msg "Installing Ubuntu 22.04 LTS..."
    echo -e "  ${Y}⏳${W} This may take 5-15 minutes depending on your connection${D}"
    echo ""
    
    proot-distro install ubuntu
    termux-reload-settings
    
    if [[ -d "$UBUNTU_DIR" ]]; then
        success_msg "Ubuntu 22.04 LTS installed successfully!"
    else
        error_msg "Failed to install Ubuntu distribution"
        echo -e "  ${Y}!${W} Please check your internet connection and try again${D}"
        exit 1
    fi
}

# Comprehensive audio fix
sound() {
    echo ""
    status_msg "Configuring Audio System (PulseAudio)..."
    
    # Create comprehensive audio configuration
    cat > "$HOME/.sound" << 'AUDIO_EOF'
#!/bin/bash
# Modded Ubuntu PRO - Audio Configuration
# Comprehensive PulseAudio setup for proot environment

# Kill any existing PulseAudio processes
pulseaudio --kill 2>/dev/null

# Start PulseAudio with proper configuration
pulseaudio --start --exit-idle-time=-1 --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1"

# Load AAudio module for Android audio
pacmd load-module module-aaudio-sink 2>/dev/null || true

# Alternative: Load sles-sink if aaudio fails
# pacmd load-module module-sles-sink 2>/dev/null || true

# Set default sink
pacmd set-default-sink 0 2>/dev/null || true

echo "Audio system initialized"
AUDIO_EOF
    
    chmod +x "$HOME/.sound"
    success_msg "Audio configuration created"
}

# Download helper
downloader() {
    local path="$1"
    local url="$2"
    
    [[ -e "$path" ]] && rm -rf "$path"
    
    curl --progress-bar --insecure --fail \
         --retry-connrefused --retry 3 --retry-delay 2 \
         --location --output "$path" "$url"
}

# Setup VNC scripts
setup_vnc() {
    status_msg "Installing VNC scripts..."
    
    # vncstart
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstart" ]]; then
        cp -f "$CURR_DIR/distro/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
    else
        downloader "$CURR_DIR/vncstart" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstart"
        mv -f "$CURR_DIR/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
    fi
    
    # vncstop
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstop" ]]; then
        cp -f "$CURR_DIR/distro/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
    else
        downloader "$CURR_DIR/vncstop" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstop"
        mv -f "$CURR_DIR/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
    fi
    
    chmod +x "$UBUNTU_DIR/usr/local/bin/vncstart"
    chmod +x "$UBUNTU_DIR/usr/local/bin/vncstop"
    
    success_msg "VNC scripts installed"
}

# Setup environment and permissions
permission() {
    banner
    status_msg "Configuring Ubuntu Environment..."
    echo ""
    
    # Copy user setup script
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/user.sh" ]]; then
        cp -f "$CURR_DIR/distro/user.sh" "$UBUNTU_DIR/root/user.sh"
    else
        downloader "$CURR_DIR/user.sh" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/user.sh"
        mv -f "$CURR_DIR/user.sh" "$UBUNTU_DIR/root/user.sh"
    fi
    chmod +x "$UBUNTU_DIR/root/user.sh"
    success_msg "User setup script configured"
    
    # Setup VNC
    setup_vnc
    
    # Timezone configuration
    echo "$(getprop persist.sys.timezone)" > "$UBUNTU_DIR/etc/timezone"
    success_msg "Timezone configured"
    
    # Create Ubuntu launcher command
    echo "proot-distro login ubuntu" > "$PREFIX/bin/ubuntu"
    chmod +x "$PREFIX/bin/ubuntu"
    success_msg "Ubuntu command created"
    
    termux-reload-settings
    
    # Final success message
    if [[ -e "$PREFIX/bin/ubuntu" ]]; then
        banner
        echo ""
        echo -e "  ${G}╔═══════════════════════════════════════════════════════════╗${D}"
        echo -e "  ${G}║${W}         🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉       ${G}║${D}"
        echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
        echo -e "  ${G}║${D}                                                           ${G}║${D}"
        echo -e "  ${G}║${C}  NEXT STEPS:${D}                                             ${G}║${D}"
        echo -e "  ${G}║${D}                                                           ${G}║${D}"
        echo -e "  ${G}║${W}  1. Restart Termux completely${D}                            ${G}║${D}"
        echo -e "  ${G}║${W}  2. Type ${Y}ubuntu${W} to enter Ubuntu CLI${D}                     ${G}║${D}"
        echo -e "  ${G}║${W}  3. Run ${Y}bash user.sh${W} to create your user${D}                ${G}║${D}"
        echo -e "  ${G}║${W}  4. Restart Termux, type ${Y}ubuntu${D}                          ${G}║${D}"
        echo -e "  ${G}║${W}  5. Run ${Y}sudo bash gui.sh${W} for GUI + 124+ apps${D}            ${G}║${D}"
        echo -e "  ${G}║${D}                                                           ${G}║${D}"
        echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
        echo -e "  ${G}║${M}  PRO Edition by ZetaGo-Aurum ${Y}|${B} ALEOCROPHIC Brand${D}         ${G}║${D}"
        echo -e "  ${G}╚═══════════════════════════════════════════════════════════╝${D}"
        echo ""
        sleep 2
    else
        error_msg "Installation failed!"
        echo -e "  ${Y}!${W} Please try running the script again${D}"
        exit 1
    fi
}

# Main execution
banner
echo -e "  ${Y}Starting Modded Ubuntu PRO v${VERSION} Installation...${D}"
echo ""
sleep 1

package
distro
sound
permission
