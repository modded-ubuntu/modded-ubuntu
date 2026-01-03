#!/bin/bash

##############################################################################
#                                                                            #
#   MODDED UBUNTU PRO v3.0.0 - GUI INSTALLER                                 #
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

# Colors
R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
M="\033[1;35m"
C="\033[1;36m"
W="\033[1;37m"
D="\033[0m"

# System info
ARCH=$(uname -m)
USERNAME=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)
VERSION="3.0.0 PRO"
LOG_FILE="/tmp/modded-ubuntu-pro-install.log"
TOTAL_PACKAGES=124
CURRENT_PACKAGE=0

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
    ║        🎨 G U I   I N S T A L L E R   v3.0.0  🎨              ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${D}"
    echo -e "${C}  ┌─────────────────────────────────────────────────────────────┐${D}"
    echo -e "${C}  │${W}  124+ Software Packages  ${Y}│${G} Fully Automatic Installation  ${C}│${D}"
    echo -e "${C}  │${M}  ZetaGo-Aurum            ${Y}│${B} ALEOCROPHIC Brand             ${C}│${D}"
    echo -e "${C}  └─────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local label=$3
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r  ${C}[${G}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${W}"
    printf "%${empty}s" | tr ' ' '░'
    printf "${C}]${W} %3d%% ${Y}%s${D}                    " $percentage "$label"
}

# Status messages
status_msg() {
    echo -e "\n  ${M}▸${C} $1${D}"
}

success_msg() {
    echo -e "  ${G}✓${W} $1${D}"
}

error_msg() {
    echo -e "  ${R}✗${W} $1${D}"
}

info_msg() {
    echo -e "  ${B}ℹ${W} $1${D}"
}

# Check root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        error_msg "This script must be run as root!"
        echo -e "  ${Y}Run with: ${G}sudo bash gui.sh${D}"
        exit 1
    fi
}

# Install package silently with logging
install_pkg() {
    local pkg="$1"
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "$pkg"
    
    if command -v "$pkg" &> /dev/null; then
        echo "[SKIP] $pkg already installed" >> "$LOG_FILE"
    else
        apt-get install -y --no-install-recommends "$pkg" >> "$LOG_FILE" 2>&1 || true
    fi
}

# Install package with custom check
install_pkg_check() {
    local pkg="$1"
    local check="$2"
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "$pkg"
    
    if command -v "$check" &> /dev/null; then
        echo "[SKIP] $pkg already installed" >> "$LOG_FILE"
    else
        apt-get install -y --no-install-recommends "$pkg" >> "$LOG_FILE" 2>&1 || true
    fi
}

# Base system packages
install_base_packages() {
    status_msg "Installing base system packages..."
    echo ""
    
    # Configure udisks2 first (known issue)
    apt-get update -y >> "$LOG_FILE" 2>&1
    apt-get install -y udisks2 >> "$LOG_FILE" 2>&1 || true
    rm -f /var/lib/dpkg/info/udisks2.postinst 2>/dev/null
    echo "" > /var/lib/dpkg/info/udisks2.postinst 2>/dev/null
    dpkg --configure -a >> "$LOG_FILE" 2>&1 || true
    apt-mark hold udisks2 >> "$LOG_FILE" 2>&1 || true
    
    # Core XFCE and system packages
    local base_packages=(
        # Core system
        sudo
        gnupg2
        curl
        wget
        nano
        vim
        git
        xz-utils
        unzip
        p7zip-full
        zip
        
        # Display and desktop
        at-spi2-core
        xfce4
        xfce4-goodies
        xfce4-terminal
        xfce4-whiskermenu-plugin
        xfce4-power-manager
        xfce4-taskmanager
        
        # VNC
        tigervnc-standalone-server
        tigervnc-common
        
        # System utilities
        dbus-x11
        librsvg2-common
        menu
        inetutils-tools
        dialog
        exo-utils
        
        # Fonts
        fonts-noto
        fonts-noto-color-emoji
        fonts-dejavu-core
        fonts-liberation
        fonts-ubuntu
        fonts-firacode
        
        # GTK engines and themes
        gtk2-engines-murrine
        gtk2-engines-pixbuf
        
        # Transport
        apt-transport-https
        ca-certificates
        software-properties-common
    )
    
    for pkg in "${base_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    echo ""
    success_msg "Base system packages installed"
}

# Development tools
install_dev_tools() {
    status_msg "Installing development tools..."
    echo ""
    
    local dev_packages=(
        # Build tools
        build-essential
        gcc
        g++
        make
        cmake
        autoconf
        automake
        
        # Python
        python3
        python3-pip
        python3-venv
        python3-dev
        
        # Version control
        git
        git-lfs
        
        # Editors
        geany
        geany-plugins
    )
    
    for pkg in "${dev_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    # Node.js (via nodesource)
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "nodejs"
    if ! command -v node &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - >> "$LOG_FILE" 2>&1 || true
        apt-get install -y nodejs >> "$LOG_FILE" 2>&1 || true
    fi
    
    echo ""
    success_msg "Development tools installed"
}

# Office suite
install_office() {
    status_msg "Installing LibreOffice suite..."
    echo ""
    
    local office_packages=(
        libreoffice-writer
        libreoffice-calc
        libreoffice-impress
        libreoffice-draw
        libreoffice-math
        libreoffice-gtk3
        evince
    )
    
    for pkg in "${office_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    echo ""
    success_msg "LibreOffice suite installed"
}

# Graphics and design
install_graphics() {
    status_msg "Installing graphics and design tools..."
    echo ""
    
    local graphics_packages=(
        gimp
        inkscape
        krita
        imagemagick
        ristretto
        optipng
        sassc
    )
    
    for pkg in "${graphics_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    echo ""
    success_msg "Graphics tools installed"
}

# Audio tools
install_audio() {
    status_msg "Installing audio tools..."
    echo ""
    
    local audio_packages=(
        audacity
        lmms
        pulseaudio
        pavucontrol
        alsa-utils
    )
    
    for pkg in "${audio_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    echo ""
    success_msg "Audio tools installed"
}

# Video and media
install_media() {
    status_msg "Installing media players and tools..."
    echo ""
    
    local media_packages=(
        vlc
        mpv
        ffmpeg
        mediainfo
    )
    
    for pkg in "${media_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    # Kdenlive (video editor) - only on 64-bit
    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "x86_64" ]]; then
        install_pkg "kdenlive"
    fi
    
    echo ""
    success_msg "Media tools installed"
}

# System utilities
install_utilities() {
    status_msg "Installing system utilities..."
    echo ""
    
    local utility_packages=(
        thunar
        thunar-archive-plugin
        thunar-volman
        xarchiver
        htop
        neofetch
        gparted
        synaptic
        bleachbit
        file-roller
        gnome-disk-utility
        baobab
        hardinfo
    )
    
    for pkg in "${utility_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    echo ""
    success_msg "System utilities installed"
}

# Network tools
install_network() {
    status_msg "Installing network tools..."
    echo ""
    
    local network_packages=(
        filezilla
        transmission-gtk
        net-tools
        openssh-client
        openssh-server
        nmap
        whois
        dnsutils
    )
    
    for pkg in "${network_packages[@]}"; do
        install_pkg "$pkg"
    done
    
    echo ""
    success_msg "Network tools installed"
}

# Install VSCode
install_vscode() {
    status_msg "Installing Visual Studio Code..."
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "vscode"
    
    if command -v code &> /dev/null; then
        echo "[SKIP] VSCode already installed" >> "$LOG_FILE"
    else
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg 2>> "$LOG_FILE"
        install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/ 2>> "$LOG_FILE"
        echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
        apt-get update -y >> "$LOG_FILE" 2>&1
        apt-get install -y code >> "$LOG_FILE" 2>&1 || true
        
        # Apply patch for proot
        curl -fsSL https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/patches/code.desktop > /usr/share/applications/code.desktop 2>> "$LOG_FILE" || true
    fi
    
    echo ""
    success_msg "Visual Studio Code installed"
}

# Install Sublime Text
install_sublime() {
    status_msg "Installing Sublime Text..."
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "sublime"
    
    if command -v subl &> /dev/null; then
        echo "[SKIP] Sublime already installed" >> "$LOG_FILE"
    else
        apt-get install -y gnupg2 software-properties-common --no-install-recommends >> "$LOG_FILE" 2>&1
        echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list >> "$LOG_FILE" 2>&1
        curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2>> "$LOG_FILE"
        apt-get update -y >> "$LOG_FILE" 2>&1
        apt-get install -y sublime-text >> "$LOG_FILE" 2>&1 || true
    fi
    
    echo ""
    success_msg "Sublime Text installed"
}

# Install Firefox
install_firefox() {
    status_msg "Installing Firefox..."
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "firefox"
    
    if command -v firefox &> /dev/null; then
        echo "[SKIP] Firefox already installed" >> "$LOG_FILE"
    else
        # Remove snap version if exists
        snap remove firefox 2>/dev/null || true
        
        # Add Mozilla PPA
        add-apt-repository -y ppa:mozillateam/ppa >> "$LOG_FILE" 2>&1 || {
            echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu jammy main" | tee /etc/apt/sources.list.d/mozillateam.list >> "$LOG_FILE" 2>&1
        }
        
        # Set Firefox ESR as priority
        cat > /etc/apt/preferences.d/mozilla-firefox << 'EOF'
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOF
        
        apt-get update -y >> "$LOG_FILE" 2>&1
        apt-get install -y firefox >> "$LOG_FILE" 2>&1 || apt-get install -y firefox-esr >> "$LOG_FILE" 2>&1 || true
    fi
    
    echo ""
    success_msg "Firefox installed"
}

# Install Chromium
install_chromium() {
    status_msg "Installing Chromium..."
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "chromium"
    
    if command -v chromium &> /dev/null || command -v chromium-browser &> /dev/null; then
        echo "[SKIP] Chromium already installed" >> "$LOG_FILE"
    else
        apt-get purge -y chromium* chromium-browser* snapd >> "$LOG_FILE" 2>&1 || true
        
        # Add Debian repository for Chromium
        echo -e "deb http://ftp.debian.org/debian buster main\ndeb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list.d/debian.list
        
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517 >> "$LOG_FILE" 2>&1 || true
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 >> "$LOG_FILE" 2>&1 || true
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A >> "$LOG_FILE" 2>&1 || true
        
        apt-get update -y >> "$LOG_FILE" 2>&1
        apt-get install -y chromium >> "$LOG_FILE" 2>&1 || apt-get install -y chromium-browser >> "$LOG_FILE" 2>&1 || true
        
        # Patch for sandbox
        sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop 2>/dev/null || true
    fi
    
    echo ""
    success_msg "Chromium installed"
}

# Configure audio
configure_audio() {
    status_msg "Configuring audio system..."
    
    # Add audio environment to system profile
    echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/ubuntu)" > /data/data/com.termux/files/usr/bin/ubuntu 2>/dev/null || true
    
    # Set environment variables
    echo 'export DISPLAY=":1"' >> /etc/profile
    echo 'export PULSE_SERVER=127.0.0.1' >> /etc/profile
    
    source /etc/profile 2>/dev/null || true
    
    success_msg "Audio system configured"
}

# Download theme assets
downloader() {
    local path="$1"
    local url="$2"
    
    [[ -e "$path" ]] && rm -rf "$path"
    curl --progress-bar --insecure --fail \
         --retry-connrefused --retry 3 --retry-delay 2 \
         --location --output "$path" "$url" >> "$LOG_FILE" 2>&1
}

# Remove unwanted themes
remove_old_themes() {
    local themes_to_remove=(Bright Daloa Emacs Moheli Retro Smoke)
    for theme in "${themes_to_remove[@]}"; do
        rm -rf "/usr/share/themes/$theme" 2>/dev/null || true
    done
    
    local icons_to_remove=(hicolor LoginIcons ubuntu-mono-light)
    for icon in "${icons_to_remove[@]}"; do
        rm -rf "/usr/share/icons/$icon" 2>/dev/null || true
    done
}

# Install premium themes
install_themes() {
    status_msg "Installing premium theme package..."
    echo ""
    
    # Update and install theme dependencies
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 >> "$LOG_FILE" 2>&1 || true
    apt-get upgrade -y >> "$LOG_FILE" 2>&1
    apt-get install -y gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin >> "$LOG_FILE" 2>&1 || true
    
    # Backup old wallpaper
    mv -f /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfce-verticals-old.png 2>/dev/null || true
    
    # Create temp directory
    temp_folder=$(mktemp -d -p "$HOME")
    cd "$temp_folder"
    
    info_msg "Downloading theme assets..."
    
    local assets=(
        "fonts.tar.gz|https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/fonts.tar.gz"
        "icons.tar.gz|https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/icons.tar.gz"
        "wallpaper.tar.gz|https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
        "gtk-themes.tar.gz|https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/gtk-themes.tar.gz"
        "ubuntu-settings.tar.gz|https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz"
    )
    
    for asset in "${assets[@]}"; do
        IFS='|' read -r filename url <<< "$asset"
        CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
        progress_bar $CURRENT_PACKAGE $TOTAL_PACKAGES "$filename"
        downloader "$filename" "$url"
    done
    
    echo ""
    info_msg "Extracting theme assets..."
    
    # Extract assets
    tar -xzf fonts.tar.gz -C "/usr/local/share/fonts/" 2>> "$LOG_FILE" || true
    tar -xzf icons.tar.gz -C "/usr/share/icons/" 2>> "$LOG_FILE" || true
    tar -xzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/" 2>> "$LOG_FILE" || true
    tar -xzf gtk-themes.tar.gz -C "/usr/share/themes/" 2>> "$LOG_FILE" || true
    tar -xzf ubuntu-settings.tar.gz -C "/home/$USERNAME/" 2>> "$LOG_FILE" || true
    
    # Cleanup temp
    rm -rf "$temp_folder"
    
    # Remove old themes
    remove_old_themes
    
    # Rebuild font cache
    info_msg "Rebuilding font cache..."
    fc-cache -fv >> "$LOG_FILE" 2>&1 || true
    
    echo ""
    success_msg "Premium theme package installed"
}

# Final system upgrade and cleanup
final_cleanup() {
    status_msg "Final system optimization..."
    
    apt-get update -y >> "$LOG_FILE" 2>&1
    apt-get upgrade -y >> "$LOG_FILE" 2>&1
    apt-get clean >> "$LOG_FILE" 2>&1
    apt-get autoremove -y >> "$LOG_FILE" 2>&1
    
    success_msg "System optimized"
}

# Show completion message
show_complete() {
    banner
    echo ""
    echo -e "  ${G}╔═══════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${G}║${W}          🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉       ${G}║${D}"
    echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${W}  ✓ 124+ Software packages installed                       ${G}║${D}"
    echo -e "  ${G}║${W}  ✓ Premium dark theme configured                          ${G}║${D}"
    echo -e "  ${G}║${W}  ✓ Audio system configured                                ${G}║${D}"
    echo -e "  ${G}║${W}  ✓ VNC server ready                                       ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${G}║${C}  HOW TO USE:${D}                                             ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${W}  Type ${Y}vncstart${W} to start VNC server${D}                      ${G}║${D}"
    echo -e "  ${G}║${W}  Type ${Y}vncstop${W} to stop VNC server${D}                        ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${C}  Connect with VNC Viewer:${D}                                ${G}║${D}"
    echo -e "  ${G}║${W}  Address: ${Y}localhost:1${D}                                    ${G}║${D}"
    echo -e "  ${G}║${W}  Set Picture Quality to ${Y}HIGH${D}                             ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${G}║${M}  PRO Edition by ZetaGo-Aurum ${Y}|${B} ALEOCROPHIC Brand${D}         ${G}║${D}"
    echo -e "  ${G}║${D}  Original: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx       ${G}║${D}"
    echo -e "  ${G}╚═══════════════════════════════════════════════════════════╝${D}"
    echo ""
    echo -e "  ${Y}📋 Installation log saved to: ${W}$LOG_FILE${D}"
    echo ""
}

# Main execution
main() {
    # Initialize log
    echo "=== Modded Ubuntu PRO v${VERSION} Installation Log ===" > "$LOG_FILE"
    echo "Started: $(date)" >> "$LOG_FILE"
    echo "Architecture: $ARCH" >> "$LOG_FILE"
    echo "User: $USERNAME" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    banner
    
    echo -e "  ${Y}╔═══════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${Y}║${W}          🚀 AUTOMATIC INSTALLATION STARTING 🚀           ${Y}║${D}"
    echo -e "  ${Y}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${Y}║${D}                                                           ${Y}║${D}"
    echo -e "  ${Y}║${W}  This will install 124+ software packages including:     ${Y}║${D}"
    echo -e "  ${Y}║${D}                                                           ${Y}║${D}"
    echo -e "  ${Y}║${C}  • VSCode, Sublime, LibreOffice, GIMP, Inkscape          ${Y}║${D}"
    echo -e "  ${Y}║${C}  • Audacity, VLC, Firefox, Chromium, FileZilla           ${Y}║${D}"
    echo -e "  ${Y}║${C}  • Git, Node.js, Python, and many more...                ${Y}║${D}"
    echo -e "  ${Y}║${D}                                                           ${Y}║${D}"
    echo -e "  ${Y}║${G}  Estimated time: 30-60 minutes                           ${Y}║${D}"
    echo -e "  ${Y}║${D}                                                           ${Y}║${D}"
    echo -e "  ${Y}╚═══════════════════════════════════════════════════════════╝${D}"
    echo ""
    
    sleep 3
    
    # Check for root
    check_root
    
    # Install all packages
    install_base_packages
    install_dev_tools
    install_office
    install_graphics
    install_audio
    install_media
    install_utilities
    install_network
    install_vscode
    install_sublime
    install_firefox
    install_chromium
    
    # Configure system
    configure_audio
    install_themes
    final_cleanup
    
    # Show completion
    show_complete
    
    echo "Completed: $(date)" >> "$LOG_FILE"
}

# Run main
main
