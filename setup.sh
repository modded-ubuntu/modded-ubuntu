#!/bin/bash

##############################################################################
#                                                                            #
#   ACRO PRO Edition v3.2.0                                                  #
#   Premium Linux Distribution for Termux (Ubuntu-based)                     #
#                                                                            #
#   Original Base: modded-ubuntu                                             #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#                                                                            #
#   ACRO Distro By: ZetaGo-Aurum                                             #
#   Brand: ALEOCROPHIC                                                       #
#   Features: 1000+ Software, GPU Virtualization, Storage Sharing            #
#                                                                            #
##############################################################################

# ═══════════════════════════════════════════════════════════════════════════
# COLOR PALETTE - Using $'...' syntax for proper escape handling on Termux
# ═══════════════════════════════════════════════════════════════════════════
R=$'\033[1;31m'          # Red
G=$'\033[1;32m'          # Green
Y=$'\033[1;33m'          # Yellow
B=$'\033[1;34m'          # Blue
M=$'\033[1;35m'          # Magenta
C=$'\033[1;36m'          # Cyan
W=$'\033[1;37m'          # White
D=$'\033[0m'             # Reset

# Extended 256-color palette for gradients
PURPLE=$'\033[38;5;141m'
LPURPLE=$'\033[38;5;177m'
PINK=$'\033[38;5;213m'
CYAN_L=$'\033[38;5;81m'
GREEN_L=$'\033[38;5;120m'
ORANGE=$'\033[38;5;208m'
GRAY=$'\033[38;5;245m'
DGRAY=$'\033[38;5;238m'

# Background colors
BG_PURPLE=$'\033[48;5;54m'
BG_DGRAY=$'\033[48;5;236m'

# Formatting
BOLD=$'\033[1m'
DIM=$'\033[2m'
ITALIC=$'\033[3m'
UNDERLINE=$'\033[4m'
BLINK=$'\033[5m'

CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
UBUNTU_DIR="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
VERSION="3.2.0"
DISTRO_NAME="ACRO PRO Edition"

# ═══════════════════════════════════════════════════════════════════════════
# ANIMATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# Spinner animation
spinner() {
    local pid=$1
    local msg=$2
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local delay=0.1
    
    tput civis  # Hide cursor
    while kill -0 $pid 2>/dev/null; do
        for (( i=0; i<${#spinstr}; i++ )); do
            printf "\r  ${CYAN_L}${spinstr:$i:1}${D} ${msg}"
            sleep $delay
        done
    done
    tput cnorm  # Show cursor
    printf "\r"
}

# Modern pip-style progress bar
progress_bar() {
    local current=$1
    local total=$2
    local pkg_name=$3
    local width=30
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    # Build the bar with character variables
    local bar_filled=""
    local bar_empty=""
    for ((i=0; i<filled; i++)); do bar_filled+="▓"; done
    for ((i=0; i<empty; i++)); do bar_empty+="░"; done
    
    printf "\r  ${PURPLE}[${GREEN_L}%s${GRAY}%s${PURPLE}]${D} ${W}%3d%%${D} ${GRAY}%s${D}                    " \
        "$bar_filled" "$bar_empty" $percentage "$pkg_name"
}

# Animated text typing effect
type_text() {
    local text=$1
    local delay=${2:-0.02}
    for (( i=0; i<${#text}; i++ )); do
        printf "%s" "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# Fade in effect for banners
fade_line() {
    local text=$1
    local color=$2
    printf "${DIM}${color}%s${D}\n" "$text"
    sleep 0.02
}

# ═══════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════

# ACRO ASCII Banner
banner() {
    clear
    echo ""
    echo "${CYAN_L}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                                                                           ║
    ║     _____                _____  ___________             ____              ║
    ║   /      |_         _____\    \_\          \        ____\_  \__           ║
    ║  /         \       /     /|     |\    /\    \      /     /     \          ║
    ║ |     /\    \     /     / /____/| |   \_\    |    /     /\      |         ║
    ║ |    |  |    \   |     | |____|/  |      ___/    |     |  |     |         ║
    ║ |     \/      \  |     |  _____   |      \  ____ |     |  |     |         ║
    ║ |\      /\     \ |\     \|\    \ /     /\ \/    \|     | /     /|         ║
    ║ | \_____\ \_____\| \_____\|    |/_____/ |\______|\     \_____/ |          ║
    ║ | |     | |     || |     /____/||     | | |     || \_____\   | /          ║
    ║  \|_____|\|_____| \|_____|    |||_____|/ \|_____| \ |    |___|/           ║
    ║                          |____|/                   \|____|               ║
    ║                                                                           ║
    ╠═══════════════════════════════════════════════════════════════════════════╣
    ║              🚀 A C R O   P R O   E D I T I O N   v3.2.0 🚀               ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo "${D}"
    echo "  ${CYAN_L}┌───────────────────────────────────────────────────────────────────┐${D}"
    echo "  ${CYAN_L}│${W}  Premium Linux for Termux         ${Y}│${GREEN_L} 1000+ Features${CYAN_L}              │${D}"
    echo "  ${CYAN_L}│${PINK}  By: ZetaGo-Aurum                  ${Y}│${PURPLE} Brand: ALEOCROPHIC${CYAN_L}         │${D}"
    echo "  ${CYAN_L}└───────────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

# Status messages with icons
status_msg() {
    echo -e "\n  ${PURPLE}▸${CYAN_L} $1${D}"
}

success_msg() {
    echo -e "  ${GREEN_L}✓${W} $1${D}"
}

error_msg() {
    echo -e "  ${R}✗${W} $1${D}"
}

warning_msg() {
    echo -e "  ${ORANGE}⚠${W} $1${D}"
}

info_msg() {
    echo -e "  ${CYAN_L}ℹ${W} $1${D}"
}

# Section header
section_header() {
    local title=$1
    echo ""
    echo -e "  ${BG_DGRAY}${W} $title ${D}"
    echo -e "  ${DGRAY}$(printf '─%.0s' {1..60})${D}"
}

# ═══════════════════════════════════════════════════════════════════════════
# INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

# Check and install packages
package() {
    banner
    section_header "📦 INITIALIZING PRO INSTALLATION"
    
    # Setup storage
    if [ ! -d '/data/data/com.termux/files/home/storage' ]; then
        status_msg "Setting up Storage Access..."
        termux-setup-storage
        sleep 2
    fi
    success_msg "Storage configured"
    
    # Required packages
    local required_packages=(pulseaudio proot-distro wget curl git)
    local total=${#required_packages[@]}
    local current=0
    
    status_msg "Installing Termux dependencies..."
    echo ""
    
    # Update with animation
    {
        yes | pkg update -y > /dev/null 2>&1
        yes | pkg upgrade -y > /dev/null 2>&1
    } &
    spinner $! "Updating package database..."
    success_msg "Package database updated"
    
    echo ""
    for pkg_name in "${required_packages[@]}"; do
        current=$((current + 1))
        progress_bar $current $total
        echo -n "${GRAY}${pkg_name}${D}"
        
        if ! command -v "$pkg_name" &> /dev/null; then
            yes | pkg install "$pkg_name" -y > /dev/null 2>&1
        fi
        echo -e "\r$(printf ' %.0s' {1..70})\r"
    done
    
    progress_bar $total $total
    echo ""
    echo ""
    success_msg "All Termux dependencies installed"
}

# Install distribution
distro() {
    section_header "🐧 UBUNTU DISTRIBUTION SETUP"
    
    status_msg "Checking for Ubuntu distribution..."
    termux-reload-settings
    
    if [[ -d "$UBUNTU_DIR" ]]; then
        success_msg "Ubuntu distribution already installed"
        info_msg "Run 'proot-distro reset ubuntu' to reinstall"
        return 0
    fi
    
    status_msg "Installing Ubuntu 22.04 LTS..."
    warning_msg "This may take 5-15 minutes depending on your connection"
    echo ""
    
    proot-distro install ubuntu
    termux-reload-settings
    
    if [[ -d "$UBUNTU_DIR" ]]; then
        success_msg "Ubuntu 22.04 LTS installed successfully!"
    else
        error_msg "Failed to install Ubuntu distribution"
        warning_msg "Please check your internet connection and try again"
        exit 1
    fi
}

# Comprehensive audio fix
sound() {
    section_header "🔊 AUDIO SYSTEM CONFIGURATION"
    
    status_msg "Configuring PulseAudio..."
    
    # Create comprehensive audio configuration
    cat > "$HOME/.sound" << 'AUDIO_EOF'
#!/bin/bash
# Modded Ubuntu PRO v3.1.0 - Audio Configuration
# Comprehensive PulseAudio setup for proot environment

# Kill any existing PulseAudio processes
pulseaudio --kill 2>/dev/null

# Start PulseAudio with proper configuration
pulseaudio --start --exit-idle-time=-1 --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1"

# Load AAudio module for Android audio
pacmd load-module module-aaudio-sink 2>/dev/null || true

# Configure audio input (microphone support)
pacmd load-module module-aaudio-source 2>/dev/null || true

# Set default sink and source
pacmd set-default-sink 0 2>/dev/null || true
pacmd set-default-source 0 2>/dev/null || true

echo "Audio system initialized with input/output support"
AUDIO_EOF
    
    chmod +x "$HOME/.sound"
    success_msg "Audio output configuration created"
    success_msg "Microphone input support enabled"
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
        downloader "$CURR_DIR/vncstart" "https://raw.githubusercontent.com/ZetaGo-Aurum/modded-ubuntu/master/distro/vncstart"
        mv -f "$CURR_DIR/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
    fi
    
    # vncstop
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstop" ]]; then
        cp -f "$CURR_DIR/distro/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
    else
        downloader "$CURR_DIR/vncstop" "https://raw.githubusercontent.com/ZetaGo-Aurum/modded-ubuntu/master/distro/vncstop"
        mv -f "$CURR_DIR/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
    fi
    
    chmod +x "$UBUNTU_DIR/usr/local/bin/vncstart"
    chmod +x "$UBUNTU_DIR/usr/local/bin/vncstop"
    
    success_msg "VNC scripts installed"
}

# Setup settings script
setup_settings() {
    status_msg "Installing Settings utility..."
    
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/settings.sh" ]]; then
        cp -f "$CURR_DIR/distro/settings.sh" "$UBUNTU_DIR/usr/local/bin/mu-settings"
        chmod +x "$UBUNTU_DIR/usr/local/bin/mu-settings"
        success_msg "Settings utility installed (run 'mu-settings' in Ubuntu)"
    fi
}

# Setup environment and permissions
permission() {
    banner
    section_header "⚙️  ENVIRONMENT CONFIGURATION"
    
    # Copy user setup script
    if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/user.sh" ]]; then
        cp -f "$CURR_DIR/distro/user.sh" "$UBUNTU_DIR/root/user.sh"
    else
        downloader "$CURR_DIR/user.sh" "https://raw.githubusercontent.com/ZetaGo-Aurum/modded-ubuntu/master/distro/user.sh"
        mv -f "$CURR_DIR/user.sh" "$UBUNTU_DIR/root/user.sh"
    fi
    chmod +x "$UBUNTU_DIR/root/user.sh"
    success_msg "User setup script configured"
    
    # Setup VNC
    setup_vnc
    
    # Setup settings
    setup_settings
    
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
        show_complete
    else
        error_msg "Installation failed!"
        warning_msg "Please try running the script again"
        exit 1
    fi
}

# Show completion message
show_complete() {
    banner
    echo ""
    echo -e "  ${GREEN_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${GREEN_L}║${W}            🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉            ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${CYAN_L}  NEXT STEPS:${D}                                                      ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  1. Restart Termux completely${D}                                     ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  2. Type ${Y}ubuntu${W} to enter Ubuntu CLI${D}                              ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  3. Run ${Y}bash user.sh${W} to create your user${D}                         ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  4. Restart Termux, type ${Y}ubuntu${D}                                     ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  5. Run ${Y}sudo bash gui.sh${W} for GUI + 1000+ apps${D}                     ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${PINK}  PRO Edition by ZetaGo-Aurum    ${Y}│${PURPLE}    ALEOCROPHIC Brand${D}           ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    sleep 2
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

banner

echo -e "  ${Y}╔═══════════════════════════════════════════════════════════════════╗${D}"
echo -e "  ${Y}║${W}            🚀 MODDED UBUNTU PRO v${VERSION} 🚀                 ${Y}║${D}"
echo -e "  ${Y}╠═══════════════════════════════════════════════════════════════════╣${D}"
echo -e "  ${Y}║${D}                                                                   ${Y}║${D}"
echo -e "  ${Y}║${CYAN_L}  This will install the base Ubuntu system for Termux.${D}            ${Y}║${D}"
echo -e "  ${Y}║${CYAN_L}  After setup, you'll install 1000+ software packages.${D}            ${Y}║${D}"
echo -e "  ${Y}║${D}                                                                   ${Y}║${D}"
echo -e "  ${Y}║${GREEN_L}  ✓ Full hardware virtualization support${D}                          ${Y}║${D}"
echo -e "  ${Y}║${GREEN_L}  ✓ Comprehensive audio system with mic input${D}                     ${Y}║${D}"
echo -e "  ${Y}║${GREEN_L}  ✓ Modern GUI settings utility${D}                                   ${Y}║${D}"
echo -e "  ${Y}║${D}                                                                   ${Y}║${D}"
echo -e "  ${Y}╚═══════════════════════════════════════════════════════════════════╝${D}"
echo ""

sleep 2

package
distro
sound
permission
