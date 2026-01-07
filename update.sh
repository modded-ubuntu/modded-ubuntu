#!/bin/bash

##############################################################################
#                                                                            #
#   ACRO PRO Edition v3.5.0 - UPDATE SCRIPT                                  #
#   System & GUI Updater for Existing Installations                          #
#                                                                            #
#   Original Base: modded-ubuntu                                             #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#                                                                            #
#   ACRO Distro By: ZetaGo-Aurum                                             #
#   Brand: ALEOCROPHIC                                                       #
#                                                                            #
##############################################################################

# ═══════════════════════════════════════════════════════════════════════════
# COLOR PALETTE - Using $'...' syntax for proper escape sequence handling
# ═══════════════════════════════════════════════════════════════════════════
R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
B=$'\033[1;34m'
M=$'\033[1;35m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

PURPLE=$'\033[38;5;141m'
LPURPLE=$'\033[38;5;177m'
PINK=$'\033[38;5;213m'
CYAN_L=$'\033[38;5;81m'
GREEN_L=$'\033[38;5;120m'
ORANGE=$'\033[38;5;208m'
GRAY=$'\033[38;5;245m'
DGRAY=$'\033[38;5;238m'

BG_DGRAY=$'\033[48;5;236m'
BOLD=$'\033[1m'

CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
UBUNTU_DIR="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
VERSION="3.5.0"
DISTRO_NAME="ACRO PRO Edition"

# ═══════════════════════════════════════════════════════════════════════════
# ANIMATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

spinner() {
    local pid=$1
    local msg=$2
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local delay=0.1
    
    tput civis 2>/dev/null
    while kill -0 $pid 2>/dev/null; do
        for (( i=0; i<${#spinstr}; i++ )); do
            printf "\r  ${CYAN_L}${spinstr:$i:1}${D} ${msg}"
            sleep $delay
        done
    done
    tput cnorm 2>/dev/null
    printf "\r"
}

progress_bar() {
    local current=$1
    local total=$2
    local pkg_name=$3
    local width=30
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    # Build the bar characters
    local bar_filled=""
    local bar_empty=""
    for ((i=0; i<filled; i++)); do bar_filled+="▓"; done
    for ((i=0; i<empty; i++)); do bar_empty+="░"; done
    
    # Print with proper colors
    printf "\r  ${PURPLE}[${GREEN_L}%s${GRAY}%s${PURPLE}]${D} ${W}%3d%%${D} ${GRAY}%s${D}                    " \
        "$bar_filled" "$bar_empty" "$percentage" "$pkg_name"
}

# ═══════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    clear
    echo ""
    echo "${ORANGE}"
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
    ║              🔄 A C R O   U P D A T E R   v3.5.0 🔄                       ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo "${D}"
    echo "  ${CYAN_L}┌───────────────────────────────────────────────────────────────────┐${D}"
    echo "  ${CYAN_L}│${W}  System & GUI Updater        ${Y}│${GREEN_L} For Existing Installations${CYAN_L}      │${D}"
    echo "  ${CYAN_L}│${PINK}  ZetaGo-Aurum                 ${Y}│${PURPLE} ALEOCROPHIC Brand${CYAN_L}              │${D}"
    echo "  ${CYAN_L}└───────────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

status_msg() {
    echo ""
    echo "  ${PURPLE}▸${CYAN_L} $1${D}"
}

success_msg() {
    echo "  ${GREEN_L}✓${W} $1${D}"
}

error_msg() {
    echo "  ${R}✗${W} $1${D}"
}

warning_msg() {
    echo "  ${ORANGE}⚠${W} $1${D}"
}

info_msg() {
    echo "  ${CYAN_L}ℹ${W} $1${D}"
}

section_header() {
    local title=$1
    echo ""
    echo "  ${BG_DGRAY}${W} $title ${D}"
    echo "  ${DGRAY}────────────────────────────────────────────────────────────${D}"
}

# ═══════════════════════════════════════════════════════════════════════════
# UPDATE FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

check_installation() {
    section_header "🔍 CHECKING EXISTING INSTALLATION"
    
    if [[ ! -d "$UBUNTU_DIR" ]]; then
        error_msg "Modded Ubuntu is not installed!"
        echo ""
        info_msg "Please run 'bash setup.sh' first to install."
        echo ""
        exit 1
    fi
    
    success_msg "Modded Ubuntu installation found"
    
    # Check for existing user
    if [[ -e "$PREFIX/bin/ubuntu" ]]; then
        success_msg "Ubuntu launcher detected"
    else
        warning_msg "Ubuntu launcher missing - will recreate"
        echo "proot-distro login ubuntu" > "$PREFIX/bin/ubuntu"
        chmod +x "$PREFIX/bin/ubuntu"
    fi
}

update_termux_packages() {
    section_header "📦 UPDATING TERMUX PACKAGES"
    
    local packages=(pulseaudio proot-distro wget curl git termux-api)
    local total=${#packages[@]}
    local current=0
    
    {
        yes | pkg update -y > /dev/null 2>&1
        yes | pkg upgrade -y > /dev/null 2>&1
    } &
    spinner $! "Updating package database..."
    success_msg "Package database updated"
    
    echo ""
    for pkg in "${packages[@]}"; do
        current=$((current + 1))
        progress_bar $current $total "$pkg"
        
        if ! dpkg -s "$pkg" &> /dev/null; then
            yes | pkg install "$pkg" -y > /dev/null 2>&1
        fi
        sleep 0.1
    done
    
    echo ""
    echo ""
    success_msg "Termux packages updated"
    
    # Create/update phantom process prevention scripts
    status_msg "Setting up keep-alive scripts..."
    
    cat > "$PREFIX/bin/acro-keepalive" << 'KEEPALIVE_EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ACRO PRO Edition - Keep Termux Alive
termux-wake-lock 2>/dev/null
termux-notification --id acro-alive \
    --title "ACRO PRO Edition" \
    --content "Ubuntu is running in background" \
    --ongoing --priority high \
    --button1 "Stop" \
    --button1-action "termux-notification-remove acro-alive && termux-wake-unlock" \
    2>/dev/null || true
echo "✓ ACRO keep-alive enabled"
KEEPALIVE_EOF
    chmod +x "$PREFIX/bin/acro-keepalive"
    
    cat > "$PREFIX/bin/acro-stop" << 'STOP_EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-notification-remove acro-alive 2>/dev/null
termux-wake-unlock 2>/dev/null
echo "✓ ACRO keep-alive disabled"
STOP_EOF
    chmod +x "$PREFIX/bin/acro-stop"
    
    success_msg "Keep-alive scripts installed"
    info_msg "Run 'acro-keepalive' for 24/7 operation"
}

update_scripts() {
    section_header "📝 UPDATING SYSTEM SCRIPTS"
    
    local items=(
        "distro/vncstart:$UBUNTU_DIR/usr/local/bin/vncstart"
        "distro/vncstop:$UBUNTU_DIR/usr/local/bin/vncstop"
        "distro/user.sh:$UBUNTU_DIR/root/user.sh"
        "distro/gui.sh:$UBUNTU_DIR/root/gui.sh"
        "distro/settings.sh:$UBUNTU_DIR/usr/local/bin/acro-settings"
    )
    
    local total=${#items[@]}
    local current=0
    
    for item in "${items[@]}"; do
        IFS=':' read -r src dest <<< "$item"
        current=$((current + 1))
        
        local basename=$(basename "$src")
        progress_bar $current $total "$basename"
        
        if [[ -e "$CURR_DIR/$src" ]]; then
            cp -f "$CURR_DIR/$src" "$dest" 2>/dev/null || true
            chmod +x "$dest" 2>/dev/null || true
        fi
        sleep 0.1
    done
    
    # Also copy gui.sh to user's home if user exists
    local username=$(grep -oP 'login --user \K[^ ]+' "$PREFIX/bin/ubuntu" 2>/dev/null | head -1)
    if [[ -n "$username" ]] && [[ "$username" != "root" ]] && [[ -d "$UBUNTU_DIR/home/$username" ]]; then
        cp -f "$CURR_DIR/distro/gui.sh" "$UBUNTU_DIR/home/$username/gui.sh" 2>/dev/null || true
        chmod +x "$UBUNTU_DIR/home/$username/gui.sh" 2>/dev/null || true
    fi
    
    echo ""
    echo ""
    success_msg "System scripts updated"
}

update_audio_config() {
    section_header "🔊 UPDATING AUDIO CONFIGURATION"
    
    status_msg "Setting up PulseAudio for permanent audio..."
    
    # Create proper client config
    mkdir -p "$UBUNTU_DIR/etc/pulse"
    cat > "$UBUNTU_DIR/etc/pulse/client.conf" << 'PULSE_EOF'
# ACRO PRO Edition - PulseAudio Client Config
default-server = tcp:127.0.0.1:4713
autospawn = no
daemon-binary = /bin/true
enable-shm = false
enable-memfd = no
PULSE_EOF
    
    # Create profile.d script for environment
    mkdir -p "$UBUNTU_DIR/etc/profile.d"
    cat > "$UBUNTU_DIR/etc/profile.d/acro-audio.sh" << 'AUDIO_ENV_EOF'
#!/bin/bash
# ACRO Audio Environment
export PULSE_SERVER="tcp:127.0.0.1:4713"
export DISPLAY="${DISPLAY:-:1}"
AUDIO_ENV_EOF
    chmod +x "$UBUNTU_DIR/etc/profile.d/acro-audio.sh"
    
    # Create audio helper script
    mkdir -p "$UBUNTU_DIR/usr/local/bin"
    cat > "$UBUNTU_DIR/usr/local/bin/acro-audio" << 'AUDIO_HELPER_EOF'
#!/bin/bash
# ACRO Audio Helper
export PULSE_SERVER="tcp:127.0.0.1:4713"

case "$1" in
    status)
        if pactl info >/dev/null 2>&1; then
            echo "✓ Audio is working!"
            pactl info | grep -E "Server Name|Default Sink"
        else
            echo "✗ Audio not connected"
            echo "Run in Termux: pulseaudio --start"
        fi
        ;;
    test)
        speaker-test -t sine -f 440 -l 1 2>/dev/null || echo "Test failed"
        ;;
    *)
        echo "Usage: acro-audio [status|test]"
        ;;
esac
AUDIO_HELPER_EOF
    chmod +x "$UBUNTU_DIR/usr/local/bin/acro-audio"
    
    # Install acro-settings if not exists
    if [[ -f "$CURR_DIR/distro/settings.sh" ]]; then
        cp -f "$CURR_DIR/distro/settings.sh" "$UBUNTU_DIR/usr/local/bin/acro-settings"
        chmod +x "$UBUNTU_DIR/usr/local/bin/acro-settings"
        success_msg "acro-settings installed"
    fi
    
    # Copy wallpaper if exists
    if [[ -f "$CURR_DIR/distro/acro-wallpaper.jpg" ]]; then
        cp -f "$CURR_DIR/distro/acro-wallpaper.jpg" "$UBUNTU_DIR/usr/share/backgrounds/acro-wallpaper.jpg" 2>/dev/null || true
        cp -f "$CURR_DIR/distro/acro-wallpaper.jpg" "$UBUNTU_DIR/root/acro-wallpaper.jpg" 2>/dev/null || true
        success_msg "ACRO wallpaper copied"
    fi
    
    # Fix GPU configuration (v3.3.2 - OpenGL 4.5 for Blender/modern apps)
    mkdir -p "$UBUNTU_DIR/etc/profile.d"
    cat > "$UBUNTU_DIR/etc/profile.d/acro-gpu.sh" << 'GPU_FIX_EOF'
#!/bin/bash
# ACRO PRO Edition - GPU Configuration
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export LP_NUM_THREADS=$(nproc)
export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
export MESA_EXTENSION_MAX_YEAR=2030
export __GL_SYNC_TO_VBLANK=0
export __GL_SHADER_DISK_CACHE=1
export QT_XCB_FORCE_SOFTWARE_OPENGL=1
export CYCLES_OPENCL_TEST=none
export LIBGL_DRI3_DISABLE=1
GPU_FIX_EOF
    chmod +x "$UBUNTU_DIR/etc/profile.d/acro-gpu.sh"
    success_msg "GPU rendering fixed"
    
    # REMOVE OLD .sound files
    rm -f "$HOME/.sound" 2>/dev/null || true
    rm -f "$UBUNTU_DIR/root/.sound" 2>/dev/null || true
    
    # Get existing user from current launcher if exists
    local existing_user=""
    if [[ -f "$PREFIX/bin/ubuntu" ]]; then
        existing_user=$(grep -oP 'login --user \K[^ ]+' "$PREFIX/bin/ubuntu" 2>/dev/null | head -1)
    fi
    
    # Recreate ubuntu launcher WITH PERMANENT AUDIO (preserve existing user!)
    if [[ -n "$existing_user" ]] && [[ "$existing_user" != "root" ]]; then
        # User exists - preserve it
        cat > "$PREFIX/bin/ubuntu" << UBUNTU_LAUNCHER_EOF
#!/data/data/com.termux/files/usr/bin/bash
# ACRO PRO Edition - Ubuntu Launcher with Permanent Audio

# Start PulseAudio server with TCP module (CRITICAL FOR AUDIO)
if ! pgrep -x pulseaudio > /dev/null 2>&1; then
    pulseaudio --start --exit-idle-time=-1 \\
        --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \\
        2>/dev/null
    sleep 0.5
fi

# Export audio environment
export PULSE_SERVER="tcp:127.0.0.1:4713"

# Login to Ubuntu as user: $existing_user
proot-distro login --user $existing_user ubuntu
UBUNTU_LAUNCHER_EOF
        info_msg "Preserved user: $existing_user"
    else
        # No user - use default root login
        cat > "$PREFIX/bin/ubuntu" << 'UBUNTU_LAUNCHER_EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ACRO PRO Edition - Ubuntu Launcher with Permanent Audio

# Start PulseAudio server with TCP module (CRITICAL FOR AUDIO)
if ! pgrep -x pulseaudio > /dev/null 2>&1; then
    pulseaudio --start --exit-idle-time=-1 \
        --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
        2>/dev/null
    sleep 0.5
fi

# Export audio environment
export PULSE_SERVER="tcp:127.0.0.1:4713"

# Login to Ubuntu
proot-distro login ubuntu
UBUNTU_LAUNCHER_EOF
    fi
    chmod +x "$PREFIX/bin/ubuntu"
    
    success_msg "Audio permanently activated"
    info_msg "PulseAudio will start automatically on 'ubuntu' command"
}

show_update_menu() {
    banner
    
    echo "  ${CYAN_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo "  ${CYAN_L}║${W}                     UPDATE OPTIONS                              ${CYAN_L}║${D}"
    echo "  ${CYAN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo "  ${CYAN_L}║${D}                                                                   ${CYAN_L}║${D}"
    echo "  ${CYAN_L}║${GREEN_L}  [1]${W} Quick Update  - Scripts and configs only                   ${CYAN_L}║${D}"
    echo "  ${CYAN_L}║${GREEN_L}  [2]${W} Full Update   - Scripts + auto run GUI installer           ${CYAN_L}║${D}"
    echo "  ${CYAN_L}║${GREEN_L}  [3]${W} GUI Only      - Update GUI installer only                  ${CYAN_L}║${D}"
    echo "  ${CYAN_L}║${GREEN_L}  [4]${W} Settings Only - Install/update settings utility            ${CYAN_L}║${D}"
    echo "  ${CYAN_L}║${D}                                                                   ${CYAN_L}║${D}"
    echo "  ${CYAN_L}║${R}  [0]${W} Exit                                                        ${CYAN_L}║${D}"
    echo "  ${CYAN_L}║${D}                                                                   ${CYAN_L}║${D}"
    echo "  ${CYAN_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Select an option [0-4]: ${D})" choice
    
    case $choice in
        1)
            quick_update
            ;;
        2)
            full_update
            ;;
        3)
            gui_update
            ;;
        4)
            settings_update
            ;;
        0|*)
            echo ""
            info_msg "Update cancelled"
            echo ""
            exit 0
            ;;
    esac
}

quick_update() {
    banner
    check_installation
    update_termux_packages
    update_scripts
    update_audio_config
    show_complete "Quick Update"
}

full_update() {
    banner
    check_installation
    update_termux_packages
    update_scripts
    update_audio_config
    
    section_header "📦 FULL GUI REINSTALLATION"
    
    info_msg "Preparing Ubuntu for update..."
    
    # Fix apt and update package lists inside Ubuntu first
    proot-distro login ubuntu -- bash -c "
        rm -f /var/lib/dpkg/lock* /var/lib/apt/lists/lock /var/cache/apt/archives/lock 2>/dev/null
        dpkg --configure -a 2>/dev/null || true
        apt-get -f install -y 2>/dev/null || true
        apt-get update -y 2>/dev/null || true
        apt-get install -y htop wget 2>/dev/null || true
        # Install neofetch via wget
        if ! command -v neofetch &>/dev/null; then
            wget -q https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -O /usr/bin/neofetch
            chmod +x /usr/bin/neofetch
        fi
    " >> "$LOG_FILE" 2>&1 || true
    
    success_msg "Ubuntu prepared"
    echo ""
    
    info_msg "Starting automatic GUI installation inside Ubuntu..."
    echo ""
    
    # Get username from ubuntu launcher
    local username=$(grep -oP 'login --user \K[^ ]+' "$PREFIX/bin/ubuntu" 2>/dev/null | head -1)
    
    if [[ -n "$username" ]] && [[ "$username" != "root" ]]; then
        # Run as user
        info_msg "Running as user: $username"
        proot-distro login --user "$username" ubuntu -- bash -c "cd ~ && sudo bash gui.sh"
    else
        # Run as root
        info_msg "Running as root"
        proot-distro login ubuntu -- bash -c "cd /root && bash gui.sh"
    fi
    
    show_complete "Full Update"
}

gui_update() {
    banner
    check_installation
    
    section_header "🎨 GUI INSTALLER UPDATE"
    
    if [[ -e "$CURR_DIR/distro/gui.sh" ]]; then
        local username=$(grep -oP 'login --user \K[^ ]+' "$PREFIX/bin/ubuntu" 2>/dev/null | head -1)
        
        if [[ -n "$username" ]] && [[ "$username" != "root" ]] && [[ -d "$UBUNTU_DIR/home/$username" ]]; then
            cp -f "$CURR_DIR/distro/gui.sh" "$UBUNTU_DIR/home/$username/gui.sh"
            chmod +x "$UBUNTU_DIR/home/$username/gui.sh"
            success_msg "GUI installer copied to /home/$username/gui.sh"
        fi
        
        cp -f "$CURR_DIR/distro/gui.sh" "$UBUNTU_DIR/root/gui.sh"
        chmod +x "$UBUNTU_DIR/root/gui.sh"
        success_msg "GUI installer copied to /root/gui.sh"
    fi
    
    info_msg "Run 'sudo bash gui.sh' inside Ubuntu to install GUI"
    
    show_complete "GUI Update"
}

settings_update() {
    banner
    check_installation
    
    section_header "⚙️  SETTINGS UTILITY UPDATE"
    
    if [[ -e "$CURR_DIR/distro/settings.sh" ]]; then
        cp -f "$CURR_DIR/distro/settings.sh" "$UBUNTU_DIR/usr/local/bin/mu-settings"
        chmod +x "$UBUNTU_DIR/usr/local/bin/mu-settings"
        success_msg "Settings utility installed"
        info_msg "Run 'mu-settings' inside Ubuntu to configure"
    else
        error_msg "Settings script not found in repository"
        info_msg "Try 'git pull' to update the repository first"
    fi
    
    show_complete "Settings Update"
}

show_complete() {
    local update_type=$1
    
    echo ""
    echo "  ${GREEN_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo "  ${GREEN_L}║${W}              ✅ ${update_type} COMPLETE! ✅                         ${GREEN_L}║${D}"
    echo "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${W}  Your Modded Ubuntu PRO has been updated to v${VERSION}!          ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${CYAN_L}  New Features:${D}                                                   ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${W}    • 1000+ software packages support${D}                             ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${W}    • Comprehensive settings utility (mu-settings)${D}                ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${W}    • Enhanced VNC configuration${D}                                  ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${W}    • Microphone input support${D}                                    ${GREEN_L}║${D}"
    echo "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo "  ${GREEN_L}║${PINK}  ZetaGo-Aurum    ${Y}│${PURPLE}    ALEOCROPHIC Brand${D}                         ${GREEN_L}║${D}"
    echo "  ${GREEN_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

# Check for command line arguments
if [[ $# -gt 0 ]]; then
    case $1 in
        --quick|-q)
            quick_update
            ;;
        --full|-f)
            full_update
            ;;
        --gui|-g)
            gui_update
            ;;
        --settings|-s)
            settings_update
            ;;
        --help|-h)
            banner
            echo "  ${CYAN_L}Usage:${D} bash update.sh [OPTION]"
            echo ""
            echo "  ${W}Options:${D}"
            echo "    ${GREEN_L}--quick, -q${D}     Quick update (scripts only)"
            echo "    ${GREEN_L}--full, -f${D}      Full update (scripts + auto GUI install)"
            echo "    ${GREEN_L}--gui, -g${D}       Update GUI installer"
            echo "    ${GREEN_L}--settings, -s${D}  Update settings utility"
            echo "    ${GREEN_L}--help, -h${D}      Show this help"
            echo ""
            echo "  ${GRAY}Run without options for interactive menu.${D}"
            echo ""
            ;;
        *)
            error_msg "Unknown option: $1"
            info_msg "Use --help for available options"
            exit 1
            ;;
    esac
else
    show_update_menu
fi
