#!/bin/bash

##############################################################################
#                                                                            #
#   ACRO PRO Edition v3.5.1 - GUI INSTALLER                                  #
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
BG_PURPLE=$'\033[48;5;54m'

# System info
ARCH=$(uname -m)
# Try multiple methods to detect the non-root username
USERNAME=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)
if [ -z "$USERNAME" ]; then
    # Try finding first non-root user with a home directory
    USERNAME=$(ls /home/ 2>/dev/null | head -1)
fi
if [ -z "$USERNAME" ]; then
    # Try from /etc/passwd
    USERNAME=$(awk -F: '($3 >= 1000 && $3 < 65534) {print $1; exit}' /etc/passwd 2>/dev/null)
fi
VERSION="3.5.1"
DISTRO_NAME="ACRO PRO Edition"
LOG_FILE="/tmp/acro-install.log"
TOTAL_PACKAGES=0
CURRENT_PACKAGE=0
START_TIME=$(date +%s)

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

# (removed pip-style bar in favor of dialog gauge)

# ═══════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════

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
    ║            🎨 A C R O   G U I   I N S T A L L E R   v3.5.1 🎨            ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo "${D}"
    echo "  ${CYAN_L}┌───────────────────────────────────────────────────────────────────┐${D}"
    echo "  ${CYAN_L}│${W}  1000+ Software Packages     ${Y}│${GREEN_L} Fully Automatic Installation${CYAN_L}   │${D}"
    echo "  ${CYAN_L}│${PINK}  ZetaGo-Aurum                 ${Y}│${PURPLE} ALEOCROPHIC Brand${CYAN_L}              │${D}"
    echo "  ${CYAN_L}└───────────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

status_msg() { echo -e "\n  ${PURPLE}▸${CYAN_L} $1${D}"; }
success_msg() { echo -e "  ${GREEN_L}✓${W} $1${D}"; }
error_msg() { echo -e "  ${R}✗${W} $1${D}"; }
info_msg() { echo -e "  ${CYAN_L}ℹ${W} $1${D}"; }
warning_msg() { echo -e "  ${ORANGE}⚠${W} $1${D}"; }

section_header() {
    echo ""
    echo -e "  ${BG_DGRAY}${W} $1 ${D}"
    echo -e "  ${DGRAY}$(printf '─%.0s' {1..60})${D}"
}

# ═══════════════════════════════════════════════════════════════════════════
# CHECK ROOT
# ═══════════════════════════════════════════════════════════════════════════

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        error_msg "This script must be run as root!"
        echo -e "  ${Y}Run with: ${G}sudo bash gui.sh${D}"
        exit 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# DPKG AUTO-FIX - Recover from corruption and conflicts
# ═══════════════════════════════════════════════════════════════════════════

fix_dpkg() {
    section_header "🔧 CHECKING PACKAGE MANAGER"
    
    # Remove dpkg lock files if they exist
    rm -f /var/lib/dpkg/lock-frontend 2>/dev/null || true
    rm -f /var/lib/dpkg/lock 2>/dev/null || true
    rm -f /var/lib/apt/lists/lock 2>/dev/null || true
    rm -f /var/cache/apt/archives/lock 2>/dev/null || true
    
    # Kill any stuck apt processes
    pkill -9 apt 2>/dev/null || true
    pkill -9 dpkg 2>/dev/null || true
    
    # Configure unconfigured packages
    info_msg "Configuring packages..."
    dpkg --configure -a >> "$LOG_FILE" 2>&1 || true
    
    # Fix broken dependencies
    info_msg "Fixing broken dependencies..."
    apt-get -f install -y >> "$LOG_FILE" 2>&1 || true
    
    # Clean package cache
    apt-get clean >> "$LOG_FILE" 2>&1 || true
    
    # Update package lists with retry
    info_msg "Updating package lists..."
    apt-get update -y >> "$LOG_FILE" 2>&1 || {
        # If failed, try again with different options
        rm -rf /var/lib/apt/lists/*
        apt-get update -y >> "$LOG_FILE" 2>&1 || true
    }
    
    # Make sure universe and multiverse are enabled
    add-apt-repository -y universe >> "$LOG_FILE" 2>&1 || true
    add-apt-repository -y multiverse >> "$LOG_FILE" 2>&1 || true
    apt-get update -y >> "$LOG_FILE" 2>&1 || true
    
    # Fix udisks2 known issue (prevents dpkg from hanging)
    apt-get install -y udisks2 >> "$LOG_FILE" 2>&1 || true
    rm -f /var/lib/dpkg/info/udisks2.postinst 2>/dev/null
    echo "" > /var/lib/dpkg/info/udisks2.postinst 2>/dev/null
    
    # Hold problematic packages that can cause conflicts
    apt-mark hold udisks2 >> "$LOG_FILE" 2>&1 || true
    
    success_msg "Package manager ready"
}

# ═══════════════════════════════════════════════════════════════════════════
# PACKAGE INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════


# Install package silently with fallback alternatives
install_pkg() {
    local pkg="$1"
    local alternatives="${2:-}"
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    
    # Update gauge if running
    if [ -n "$GAUGE_PID" ] && kill -0 "$GAUGE_PID" 2>/dev/null; then
        local pct=$((CURRENT_PACKAGE * 100 / TOTAL_PACKAGES))
        gauge_set "$pct" "$pkg ($CURRENT_PACKAGE/$TOTAL_PACKAGES)"
    fi
    
    # Check if already installed
    if dpkg -s "$pkg" &> /dev/null 2>&1; then
        echo "[SKIP] $pkg already installed" >> "$LOG_FILE"
        return 0
    fi
    
    # Try to install
    if apt-get install -y --no-install-recommends "$pkg" >> "$LOG_FILE" 2>&1; then
        echo "[OK] $pkg installed" >> "$LOG_FILE"
        return 0
    fi
    
    # Try alternatives if main package fails
    if [[ -n "$alternatives" ]]; then
        for alt in $alternatives; do
            if apt-get install -y --no-install-recommends "$alt" >> "$LOG_FILE" 2>&1; then
                echo "[ALT] $alt installed instead of $pkg" >> "$LOG_FILE"
                return 0
            fi
        done
    fi
    
    echo "[FAIL] $pkg - no alternatives worked" >> "$LOG_FILE"
    return 1
}

# Install package with command check
install_pkg_check() {
    local pkg="$1"
    local cmd="${2:-$pkg}"
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    
    if command -v "$cmd" &> /dev/null; then
        echo "[SKIP] $pkg already installed (command: $cmd)" >> "$LOG_FILE"
        return 0
    fi
    
    apt-get install -y --no-install-recommends "$pkg" >> "$LOG_FILE" 2>&1 || true
}

# ═══════════════════════════════════════════════════════════════════════════
# PACKAGE DEFINITIONS - 1000+ PACKAGES
# ═══════════════════════════════════════════════════════════════════════════

# Base system packages
BASE_PACKAGES=(
    # Core system
    sudo gnupg2 curl wget nano vim git xz-utils unzip p7zip-full zip tar gzip bzip2
    apt-utils software-properties-common apt-transport-https ca-certificates
    lsb-release gnupg dirmngr
    
    # Essential utilities - MUST BE INSTALLED
    htop btop screen tmux tree ncdu
    
    # proot/system fixes
    at-spi2-core dbus-x11 libcanberra-gtk3-module packagekit-gtk3-module
    
    # Accessibility
    libatk-adaptor libgail-common
    
    # System daemons
    policykit-1 udisks2 upower acpid pm-utils
    
    # Utilities
    dialog whiptail menu inetutils-tools exo-utils util-linux coreutils
)

# XFCE Desktop Environment
XFCE_PACKAGES=(
    xfce4 xfce4-goodies xfce4-terminal xfce4-whiskermenu-plugin
    xfce4-power-manager xfce4-taskmanager xfce4-notifyd xfce4-screenshooter
    xfce4-clipman-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin
    xfce4-diskperf-plugin xfce4-fsguard-plugin xfce4-genmon-plugin
    xfce4-indicator-plugin xfce4-mailwatch-plugin xfce4-mount-plugin
    xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin
    xfce4-pulseaudio-plugin xfce4-sensors-plugin xfce4-smartbookmark-plugin
    xfce4-systemload-plugin xfce4-timer-plugin xfce4-verve-plugin
    xfce4-wavelan-plugin xfce4-weather-plugin xfce4-xkb-plugin
    thunar thunar-archive-plugin thunar-volman thunar-media-tags-plugin
    ristretto tumbler tumbler-plugins-extra
)

# GNOME Desktop Environment Option
GNOME_PACKAGES=(
    gnome-session gnome-terminal gnome-control-center gnome-backgrounds
    gnome-themes-extra adwaita-icon-theme-full
)

# VNC
VNC_PACKAGES=(
    tigervnc-standalone-server tigervnc-common tigervnc-tools
    x11vnc xvfb xauth x11-utils x11-xserver-utils xinit
)

# Fonts - Comprehensive collection for all languages
FONT_PACKAGES=(
    # Core fonts
    fonts-noto fonts-noto-core fonts-noto-ui-core
    fonts-noto-color-emoji fonts-noto-mono
    fonts-dejavu-core fonts-dejavu-extra fonts-liberation fonts-liberation2
    fonts-ubuntu fonts-roboto fonts-open-sans
    
    # CJK (Chinese, Japanese, Korean)
    fonts-noto-cjk fonts-noto-cjk-extra fonts-wqy-microhei fonts-wqy-zenhei
    fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-gothic fonts-ipafont-mincho
    fonts-unfonts-core fonts-unfonts-extra fonts-baekmuk
    
    # Arabic & Hebrew
    fonts-noto-ui-extra fonts-arabeyes fonts-kacst fonts-kacst-one
    fonts-hosny-amiri fonts-farsiweb fonts-sil-scheherazade
    
    # Indic languages
    fonts-indic fonts-lohit-deva fonts-lohit-beng-assamese fonts-lohit-taml
    fonts-lohit-guru fonts-lohit-gujr fonts-lohit-knda fonts-lohit-mlym
    fonts-lohit-orya fonts-lohit-telu fonts-samyak-deva fonts-samyak-gujr
    fonts-samyak-taml fonts-gargi fonts-nakula fonts-sahadeva
    
    # Southeast Asian
    fonts-thai-tlwg fonts-tlwg-kinnari fonts-tlwg-laksaman fonts-tlwg-mono
    fonts-tlwg-norasi fonts-tlwg-purisa fonts-tlwg-sawasdee fonts-tlwg-typewriter
    fonts-tlwg-typist fonts-tlwg-typo fonts-tlwg-umpush fonts-tlwg-waree
    fonts-lao fonts-tibetan-machine fonts-sil-padauk fonts-khmer
    
    # Coding fonts
    fonts-firacode fonts-hack fonts-jetbrains-mono fonts-cascadia-code
    fonts-inconsolata fonts-source-code-pro fonts-monoid
    
    # Emoji
    fonts-noto-color-emoji fonts-symbola fonts-emojione
    
    # Extra
    fonts-freefont-ttf fonts-linuxlibertine fonts-cantarell
    fonts-crosextra-caladea fonts-crosextra-carlito
)

# GTK and theming
THEME_PACKAGES=(
    gtk2-engines-murrine gtk2-engines-pixbuf gnome-themes-extra
    adwaita-icon-theme adwaita-icon-theme-full
    papirus-icon-theme breeze-cursor-theme breeze-icon-theme
    qt5-style-plugins qt5ct lxappearance
    sassc optipng inkscape libglib2.0-dev-bin
)

# Development tools
DEV_PACKAGES=(
    # Build tools
    build-essential gcc g++ make cmake autoconf automake libtool pkg-config
    
    # Compilers & languages
    clang llvm nasm gdb valgrind strace ltrace
    
    # Python
    python3 python3-pip python3-venv python3-dev python3-setuptools python3-wheel
    python3-numpy python3-scipy python3-matplotlib python3-pandas
    python3-requests python3-flask python3-django python3-pillow
    python3-opencv python3-tk python3-pil python3-pil.imagetk
    ipython3 jupyter-notebook python3-jupyter-core
    
    # Ruby
    ruby ruby-dev ruby-bundler
    
    # Perl
    perl libperl-dev
    
    # Lua
    lua5.4 liblua5.4-dev luarocks
    
    # Go
    golang-go
    
    # Rust (via package manager)
    rustc cargo
    
    # PHP
    php php-cli php-common php-json php-mysql php-xml php-curl php-gd php-mbstring
    
    # Java
    default-jdk default-jre
    
    # Version control
    git git-lfs git-flow subversion mercurial
    
    # Editors
    geany geany-plugins
)

# Databases
DATABASE_PACKAGES=(
    sqlite3 libsqlite3-dev
    mariadb-client mariadb-common
    postgresql-client libpq-dev
    redis-tools
)

# GPU & 3D Optimization (VirGL/Mesa for proot)
GPU_PACKAGES=(
    # Mesa drivers and libraries
    mesa-utils mesa-utils-extra
    libgl1-mesa-glx libgl1-mesa-dri libegl1-mesa
    libglu1-mesa libglx-mesa0 libglapi-mesa
    
    # OpenGL tools
    glmark2 glmark2-es2 glmark2-wayland
    
    # GPU monitoring
    radeontop intel-gpu-tools
    
    # 3D rendering optimization
    libosmesa6 libglew2.2 libglew-dev
    libglfw3 libglfw3-dev
    
    # Vulkan (for compatible devices)
    libvulkan1 vulkan-tools mesa-vulkan-drivers
)

# Software Center (XFCE compatible)
SOFTWARE_PACKAGES=(
    # Package management GUI
    gnome-software gnome-software-plugin-flatpak
    gnome-packagekit packagekit
    
    # Flatpak support
    flatpak
    
    # Alternative software managers
    mintinstall snap-store snapd
)


# Office suite
OFFICE_PACKAGES=(
    libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw
    libreoffice-math libreoffice-base libreoffice-gtk3
    libreoffice-l10n-id libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw
    libreoffice-l10n-ja libreoffice-l10n-ko libreoffice-l10n-ar
    libreoffice-l10n-ru libreoffice-l10n-de libreoffice-l10n-fr
    libreoffice-l10n-es libreoffice-l10n-pt libreoffice-l10n-it
    evince okular atril qpdfview zathura zathura-pdf-poppler
    calibre scribus
)

# Graphics and design
GRAPHICS_PACKAGES=(
    gimp gimp-plugin-registry gimp-data-extras
    inkscape inkscape-tutorials
    krita
    imagemagick imagemagick-6.q16
    optipng pngquant jpegoptim
    darktable rawtherapee digikam
    fontforge birdfont
    synfig synfig-studio pencil2d
    dia graphviz
    shotwell gthumb eog feh gpicview
)

# Audio production and tools
AUDIO_PACKAGES=(
    # Core audio
    pulseaudio pulseaudio-utils pavucontrol pulsemixer
    alsa-utils alsa-base alsa-tools alsa-oss
    
    # Audio codecs
    lame flac vorbis-tools opus-tools
    libmp3lame0 libvorbis0a libflac8 libopus0
    sox libsox-fmt-all
    
    # Recording & editing
    audacity lmms ardour qtractor hydrogen
    
    # MIDI
    timidity timidity-interfaces-extra fluid-soundfont-gm
    
    # Equalizer & effects
    pulseeffects easyeffects
)

# Video and media
VIDEO_PACKAGES=(
    vlc vlc-plugin-base vlc-plugin-video-output
    mpv mpv-mpris
    ffmpeg ffmpegthumbnailer mediainfo mediainfo-gui
    handbrake-cli
    
    # Codecs
    libavcodec-extra ubuntu-restricted-extras gstreamer1.0-plugins-good
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
    gstreamer1.0-libav gstreamer1.0-vaapi
    x264 x265 libvpx-dev
    
    # Screen recording
    obs-studio simplescreenrecorder peek vokoscreen
    
    # Webcam
    guvcview cheese
)

# Video editing (64-bit only)
VIDEO_EDITING_64=(
    kdenlive openshot-qt shotcut pitivi
    blender openscad freecad
)

# System utilities
UTILITY_PACKAGES=(
    # File managers
    thunar pcmanfm nemo dolphin ranger mc
    xarchiver file-roller ark
    
    # System monitoring
    htop btop glances ncdu duf baobab
    gnome-disk-utility gparted
    synaptic apt-xapian-index
    neofetch screenfetch cpufetch
    
    # Terminal tools
    tmux screen byobu
    tree exa bat ripgrep fd-find fzf
    jq yq bc
    
    # Clipboard
    xclip xsel
    
    # Screenshot
    scrot flameshot gnome-screenshot
    
    # System
    bleachbit stacer
    hardinfo lshw inxi hwinfo
    
    # Archives
    p7zip-full p7zip-rar unrar-free cabextract lzip lzop
)

# Network tools
NETWORK_PACKAGES=(
    # Browsers (Firefox and Chromium installed separately)
    
    # File transfer
    filezilla aria2 curl wget
    
    # Torrent
    transmission-gtk qbittorrent deluge
    
    # Network utilities
    net-tools iproute2 iputils-ping traceroute mtr-tiny
    openssh-client openssh-server sshfs
    nmap netcat-openbsd socat
    whois dnsutils bind9-host
    
    # VPN
    openvpn wireguard-tools
    
    # Remote desktop
    remmina remmina-plugin-rdp remmina-plugin-vnc
    
    # Chat
    pidgin hexchat
)

# Security tools
SECURITY_PACKAGES=(
    gnupg2 openssl
    pass keepassxc
    wireshark tshark
    aircrack-ng
    john hashcat
    nikto sqlmap
    ncrack hydra
    clamav clamav-daemon
)

# Virtualization (limited in proot)
VIRTUALIZATION_PACKAGES=(
    qemu-user-static qemu-utils
    libvirt-clients
)

# Locales
LOCALE_PACKAGES=(
    locales locales-all
    language-pack-en language-pack-gnome-en
    language-pack-id language-pack-gnome-id
    language-pack-zh-hans language-pack-gnome-zh-hans
    language-pack-zh-hant language-pack-gnome-zh-hant
    language-pack-ja language-pack-gnome-ja
    language-pack-ko language-pack-gnome-ko
    language-pack-ar language-pack-gnome-ar
    language-pack-ru language-pack-gnome-ru
)

# ═══════════════════════════════════════════════════════════════════════════
# FREE TIER - 50 ESSENTIAL PACKAGES ONLY (Fast Installation)
# ═══════════════════════════════════════════════════════════════════════════

FREE_TIER_PACKAGES=(
    # Core System (10)
    sudo curl wget nano vim git unzip tar htop
    apt-utils ca-certificates
    
    # Desktop - Minimal XFCE (10)
    xfce4 xfce4-terminal thunar xfce4-notifyd
    xfce4-whiskermenu-plugin xfce4-power-manager
    xfce4-taskmanager xfce4-screenshooter
    ristretto tumbler
    
    # VNC (5)
    tigervnc-standalone-server x11-utils xinit
    xvfb dbus-x11
    
    # Basic Utils (10)
    neofetch screen tmux tree ncdu
    pulseaudio pavucontrol alsa-utils
    at-spi2-core libcanberra-gtk3-module
    
    # Browser (2)
    firefox
    
    # Fonts - English only (8)
    fonts-dejavu fonts-liberation fonts-noto
    fonts-noto-color-emoji fonts-roboto
    fonts-firacode fontconfig fonts-ubuntu
    
    # Locale - English only (5)
    locales language-pack-en language-pack-gnome-en
)

# Global tier variable
SELECTED_TIER="free"

# ─── Progress Gauge via FIFO ────────────────────────────────────────────

GAUGE_FIFO=$(mktemp -u /tmp/acro-gauge-XXXXXX 2>/dev/null || echo "/tmp/acro-gauge-$$")
GAUGE_PID=""

gauge_start() {
    local title="$1"
    mkfifo "$GAUGE_FIFO" 2>/dev/null || true
    dialog --colors --gauge "\Zb\Z6$title\Zn" 8 55 0 < "$GAUGE_FIFO" &
    GAUGE_PID=$!
}

gauge_set() {
    local pct="$1"
    local msg="$2"
    echo "XXX" > "$GAUGE_FIFO" 2>/dev/null || true
    echo "$pct" > "$GAUGE_FIFO" 2>/dev/null || true
    echo "$msg" > "$GAUGE_FIFO" 2>/dev/null || true
    echo "XXX" > "$GAUGE_FIFO" 2>/dev/null || true
}

gauge_stop() {
    gauge_set "100" "Complete!" 2>/dev/null || true
    sleep 1
    rm -f "$GAUGE_FIFO" 2>/dev/null || true
}

# ═══════════════════════════════════════════════════════════════════════════
# TIER SELECTION MENU
# ═══════════════════════════════════════════════════════════════════════════

show_tier_selection() {
    local choice
    choice=$(dialog --colors --stdout --menu "\Zb\Z6Select Installation Profile\Zn\n\
Choose how many packages to install:" 16 60 3 \
        "1" "Minimal - 50 essential packages (fast)" \
        "2" "Complete - ALL 1000+ packages" \
        "3" "Custom - Choose package groups manually")
    
    case "$choice" in
        1)
            SELECTED_TIER="free"
            dialog --infobox "Installing Minimal Profile (50 packages)..." 5 50
            sleep 1
            ;;
        2)
            SELECTED_TIER="ultimate"
            dialog --infobox "Installing Complete Profile (1000+ packages)..." 5 50
            sleep 1
            ;;
        3)
            SELECTED_TIER="custom"
            local checklist
            checklist=$(dialog --colors --stdout --checklist "\Zb\Z6Select Package Categories\Zn\n\
Use SPACE to toggle, ENTER to confirm:" 22 68 15 \
                "BASE" "Essential System Utilities" ON \
                "DESKTOP_XFCE" "XFCE Desktop Environment" ON \
                "DESKTOP_GNOME" "GNOME Desktop Environment" OFF \
                "BROWSERS" "Firefox & Chromium" ON \
                "DEV" "Development Tools (Python, Node, etc.)" ON \
                "OFFICE" "Office Suite & PDF Readers" ON \
                "GRAPHICS" "Graphics & Design (GIMP, Krita)" ON \
                "AUDIO" "Audio Production (Audacity, LMMS)" ON \
                "VIDEO" "Video (VLC, Kdenlive, OBS)" ON \
                "DB" "Database Clients (SQLite, MariaDB)" ON \
                "NET" "Network & Remote Tools" ON \
                "SEC" "Security & Pentesting" OFF \
                "WINE" "Wine & Box86 (Windows apps)" ON \
                "GPU" "GPU & 3D Optimization (VirGL)" ON \
                "FLATPAK" "Flatpak & Gnome Software" OFF \
                "LOCALES" "All Languages & Fonts" OFF)
            
            if [ -z "$checklist" ]; then
                SELECTED_TIER="free"
                dialog --infobox "No selection. Using Minimal Profile." 5 50
                sleep 1
            else
                CHOICES="$checklist"
            fi
            ;;
        *)
            SELECTED_TIER="free"
            dialog --infobox "Defaulting to Minimal Profile..." 5 50
            sleep 1
            ;;
    esac
    sleep 1
}

# ═══════════════════════════════════════════════════════════════════════════
# WINE/BOX86/BOX64 CONFIGURATION (Mobox-style for proot)
# Works for PRO+ and ULTIMATE tiers
# ═══════════════════════════════════════════════════════════════════════════

configure_wine_box86() {
    section_header "🍷 WINE/BOX86 CONFIGURATION (Mobox-style)"
    
    # Box86/Box64 for ARM devices to run x86/x64 Windows apps
    info_msg "Setting up Box86/Box64 for Windows compatibility..."
    
    # Add Box86/Box64 repository
    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "armv7l" ]]; then
        # Add i386 architecture for Wine
        dpkg --add-architecture armhf >> "$LOG_FILE" 2>&1 || true
        
        # Install Box86 dependencies
        apt-get install -y libc6:armhf libstdc++6:armhf >> "$LOG_FILE" 2>&1 || true
        
        # Try to install box86 from repository
        apt-get install -y box86 >> "$LOG_FILE" 2>&1 || {
            # Manual install from GitHub
            info_msg "Installing Box86 from GitHub..."
            wget -q https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list 2>/dev/null || true
            wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg 2>/dev/null || true
            apt-get update >> "$LOG_FILE" 2>&1 || true
            apt-get install -y box86-android >> "$LOG_FILE" 2>&1 || apt-get install -y box86 >> "$LOG_FILE" 2>&1 || true
        }
        
        # Try to install box64
        apt-get install -y box64 >> "$LOG_FILE" 2>&1 || {
            info_msg "Installing Box64 from GitHub..."
            wget -q https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list 2>/dev/null || true
            wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg 2>/dev/null || true
            apt-get update >> "$LOG_FILE" 2>&1 || true
            apt-get install -y box64-android >> "$LOG_FILE" 2>&1 || apt-get install -y box64 >> "$LOG_FILE" 2>&1 || true
        }
    fi
    
    # Install Wine
    info_msg "Installing Wine..."
    apt-get install -y wine wine64 wine32 winetricks >> "$LOG_FILE" 2>&1 || {
        # Fallback Wine installation
        add-apt-repository -y ppa:ubuntu-wine/ppa >> "$LOG_FILE" 2>&1 || true
        apt-get update >> "$LOG_FILE" 2>&1 || true
        apt-get install -y wine >> "$LOG_FILE" 2>&1 || true
    }
    
    # Install PlayOnLinux as alternative
    info_msg "Installing PlayOnLinux..."
    apt-get install -y playonlinux >> "$LOG_FILE" 2>&1 || true
    
    # Configure Wine environment for proot
    mkdir -p /etc/profile.d
    cat > /etc/profile.d/wine-proot.sh << 'WINE_ENV'
#!/bin/bash
# Wine/Box86 environment for proot (Mobox-style)
export WINEDLLOVERRIDES="mscoree,mshtml="
export WINEARCH=win32
export WINEPREFIX="$HOME/.wine32"

# Box86 & Box64 Dynarec optimizations (Low-level execution tuning)
export BOX86_DYNAREC=1
export BOX64_DYNAREC=1
export BOX86_DYNAREC_FASTROUND=1
export BOX64_DYNAREC_FASTROUND=1
export BOX86_DYNAREC_SAFEFLAGS=1
export BOX64_DYNAREC_SAFEFLAGS=1
export BOX86_DYNAREC_BIGBLOCK=1
export BOX64_DYNAREC_BIGBLOCK=1
export BOX86_STRONG_MEM=1
export BOX64_STRONG_MEM=1
export BOX86_LOG=0
export BOX86_NOBANNER=1
export BOX64_LOG=0
export BOX64_NOBANNER=1

# Audio & Display
export DISPLAY="${DISPLAY:-:1}"
export PULSE_SERVER="tcp:127.0.0.1:4713"

# Performance optimizations
export WINEDEBUG=-all
export MESA_GL_VERSION_OVERRIDE=4.0
export MESA_GLSL_VERSION_OVERRIDE=400
WINE_ENV
    chmod +x /etc/profile.d/wine-proot.sh
    
    # Create Wine Registry Optimizer Script
    cat > /usr/local/bin/acro-wine-optimize << 'WINE_OPT_EOF'
#!/bin/bash
# ACRO PRO Edition - Wine Performance Optimizer
# Tunes registry settings for Windows emulation on ARM devices

export WINEPREFIX="${WINEPREFIX:-$HOME/.wine32}"
export WINEARCH=win32

echo "Applying registry optimizations to Wine prefix: $WINEPREFIX"

# Create a temporary .reg file
cat > /tmp/acro_wine_opt.reg << 'REG_EOF'
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\Direct3D]
"CSMT"=dword:00000001
"MaxShaderModelVS"=dword:0000000f
"MaxShaderModelPS"=dword:0000000f
"StrictShaderTemplates"="enabled"
"VideoMemorySize"="4096"
"OffscreenRenderingMode"="fbo"
"AlwaysOffscreen"="enabled"
"Multisampling"="enabled"

[HKEY_CURRENT_USER\Software\Wine\Drivers]
"Audio"="pulse"

[HKEY_CURRENT_USER\Software\Wine\MSHTML]
"GeckoUrl"=""

[HKEY_CURRENT_USER\Software\Wine\Gecko]
"Disable"=dword:00000001

[HKEY_CURRENT_USER\Software\Wine\Mono]
"Disable"=dword:00000001
REG_EOF

# Import into Wine
wine regedit /tmp/acro_wine_opt.reg >/dev/null 2>&1
rm -f /tmp/acro_wine_opt.reg

echo "✓ Wine Registry Optimizations applied (CSMT, VRAM=4096MB, Disable Gecko/Mono Popups)"
WINE_OPT_EOF
    chmod +x /usr/local/bin/acro-wine-optimize

    # Create Wine launcher script
    cat > /usr/local/bin/acro-wine << 'WINELAUNCHER'
#!/bin/bash
# ACRO Wine Launcher - Run Windows apps in proot
# Based on Mobox configuration

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
D=$'\033[0m'

export WINEDLLOVERRIDES="mscoree,mshtml="
export WINEARCH=win32
export WINEPREFIX="$HOME/.wine32"

# Box86 & Box64 Dynarec optimizations (Low-level execution tuning)
export BOX86_DYNAREC=1
export BOX64_DYNAREC=1
export BOX86_DYNAREC_FASTROUND=1
export BOX64_DYNAREC_FASTROUND=1
export BOX86_DYNAREC_SAFEFLAGS=1
export BOX64_DYNAREC_SAFEFLAGS=1
export BOX86_DYNAREC_BIGBLOCK=1
export BOX64_DYNAREC_BIGBLOCK=1
export BOX86_STRONG_MEM=1
export BOX64_STRONG_MEM=1
export BOX86_LOG=0
export BOX86_NOBANNER=1

export DISPLAY="${DISPLAY:-:1}"
export WINEDEBUG=-all

echo ""
echo "${C}╔═══════════════════════════════════════════════════════════╗${D}"
echo "${C}║${Y}         🍷 ACRO WINE LAUNCHER (Mobox-style)             ${C}║${D}"
echo "${C}╚═══════════════════════════════════════════════════════════╝${D}"
echo ""

if [ -z "$1" ]; then
    echo "${Y}Usage:${D}"
    echo "  ${G}acro-wine setup${D}      - Initialize and optimize Wine prefix"
    echo "  ${G}acro-wine winetricks${D} - Run Winetricks"
    echo "  ${G}acro-wine winecfg${D}    - Configure Wine"
    echo "  ${G}acro-wine file.exe${D}   - Run Windows executable"
    echo "  ${G}acro-wine explorer${D}   - Open Wine Explorer"
    echo ""
    exit 0
fi

case "$1" in
    setup)
        echo "${Y}Initializing Wine prefix...${D}"
        wineboot --init
        /usr/local/bin/acro-wine-optimize
        echo "${G}✓ Wine prefix created at $WINEPREFIX${D}"
        ;;
    winetricks)
        shift
        winetricks "$@"
        ;;
    winecfg)
        winecfg
        ;;
    explorer)
        wine explorer
        ;;
    *)
        # Optimize registry on execution if not done
        if [ ! -d "$WINEPREFIX" ]; then
             echo "${Y}Creating and optimizing default wineprefix...${D}"
             wineboot --init
             /usr/local/bin/acro-wine-optimize
        fi
        
        if [ -f "$1" ]; then
            echo "${Y}Running: $1${D}"
            wine "$1"
        else
            wine "$@"
        fi
        ;;
esac
WINELAUNCHER
    chmod +x /usr/local/bin/acro-wine
    
    # Create desktop entry
    cat > /usr/share/applications/acro-wine.desktop << 'WINEDESKTOP'
[Desktop Entry]
Name=ACRO Wine
Comment=Run Windows applications (Mobox-style)
Exec=/usr/local/bin/acro-wine explorer
Icon=wine
Terminal=false
Type=Application
Categories=System;Emulator;
Keywords=wine;windows;exe;box86;
WINEDESKTOP

    success_msg "Wine/Box86 configured (Mobox-style)"
    echo "${G}✓ Run Windows apps with: acro-wine file.exe${D}"
}

# ═══════════════════════════════════════════════════════════════════════════
# INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

install_category() {
    local category_name=$1
    shift
    local packages=("$@")
    
    section_header "📦 $category_name"
    echo ""
    
    for pkg in "${packages[@]}"; do
        install_pkg "$pkg"
    done
    
    echo ""
    success_msg "$category_name completed"
}

# ═══════════════════════════════════════════════════════════════════════════
# BROWSER INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════

install_firefox() {
    section_header "🦊 FIREFOX BROWSER"
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    gauge_set $((CURRENT_PACKAGE * 100 / TOTAL_PACKAGES)) "firefox"
    
    if command -v firefox &> /dev/null; then
        echo "[SKIP] Firefox already installed" >> "$LOG_FILE"
        echo ""
        success_msg "Firefox already installed"
        return
    fi
    
    # Remove snap version
    snap remove firefox 2>/dev/null || true
    
    # Detect Ubuntu codename
    UBUNTU_CODENAME=$(lsb_release -cs 2>/dev/null || echo "jammy")
    
    # Add Mozilla PPA
    add-apt-repository -y ppa:mozillateam/ppa >> "$LOG_FILE" 2>&1 || {
        echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $UBUNTU_CODENAME main" | tee /etc/apt/sources.list.d/mozillateam.list >> "$LOG_FILE" 2>&1
    }
    
    # Priority settings
    cat > /etc/apt/preferences.d/mozilla-firefox << 'EOF'
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOF
    
    apt-get update -y >> "$LOG_FILE" 2>&1
    apt-get install -y firefox >> "$LOG_FILE" 2>&1 || apt-get install -y firefox-esr >> "$LOG_FILE" 2>&1 || true
    
    echo ""
    success_msg "Firefox installed"
}

install_chromium() {
    section_header "🌐 CHROMIUM BROWSER"
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    gauge_set $((CURRENT_PACKAGE * 100 / TOTAL_PACKAGES)) "chromium"
    
    if command -v chromium &> /dev/null || command -v chromium-browser &> /dev/null; then
        echo "[SKIP] Chromium already installed" >> "$LOG_FILE"
        echo ""
        success_msg "Chromium already installed"
        return
    fi
    
    apt-get purge -y chromium* snapd >> "$LOG_FILE" 2>&1 || true
    
    # Try multiple methods to install Chromium
    # Method 1: Direct apt install (works on Ubuntu 24.04+)
    apt-get install -y chromium-browser >> "$LOG_FILE" 2>&1 || \
    apt-get install -y chromium >> "$LOG_FILE" 2>&1 || {
        # Method 2: Debian bookworm repository (more stable than buster)
        UBUNTU_CODENAME=$(lsb_release -cs 2>/dev/null || echo "jammy")
        echo "deb http://ftp.debian.org/debian bookworm main" > /etc/apt/sources.list.d/debian.list
        echo "deb http://ftp.debian.org/debian bookworm-updates main" >> /etc/apt/sources.list.d/debian.list
        
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517 >> "$LOG_FILE" 2>&1 || true
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 >> "$LOG_FILE" 2>&1 || true
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A >> "$LOG_FILE" 2>&1 || true
        
        apt-get update -y >> "$LOG_FILE" 2>&1
        apt-get install -y chromium >> "$LOG_FILE" 2>&1 || true
    }
    
    # Patch for sandbox
    sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop 2>/dev/null || true
    
    echo ""
    success_msg "Chromium installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# IDE INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════

install_vscode() {
    section_header "💻 VISUAL STUDIO CODE"
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    gauge_set $((CURRENT_PACKAGE * 100 / TOTAL_PACKAGES)) "vscode"
    
    if command -v code &> /dev/null; then
        echo "[SKIP] VSCode already installed" >> "$LOG_FILE"
        echo ""
        success_msg "VS Code already installed"
        return
    fi
    
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg 2>> "$LOG_FILE"
    install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/ 2>> "$LOG_FILE"
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
    apt-get update -y >> "$LOG_FILE" 2>&1
    apt-get install -y code >> "$LOG_FILE" 2>&1 || true
    
    # Apply proot patch
    cat > /usr/share/applications/code.desktop << 'EOF'
[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined. - PRO Edition
GenericName=Text Editor
Exec=/usr/share/code/code --no-sandbox --disable-gpu-sandbox --unity-launch --enable-features=UseOzonePlatform --ozone-platform=x11 %F
Icon=com.visualstudio.code
Type=Application
StartupNotify=true
StartupWMClass=Code
Categories=TextEditor;Development;IDE;Utility;
MimeType=text/plain;inode/directory;
EOF
    
    echo ""
    success_msg "VS Code installed"
}

install_sublime() {
    section_header "📝 SUBLIME TEXT"
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    gauge_set $((CURRENT_PACKAGE * 100 / TOTAL_PACKAGES)) "sublime-text"
    
    if command -v subl &> /dev/null; then
        echo "[SKIP] Sublime already installed" >> "$LOG_FILE"
        echo ""
        success_msg "Sublime Text already installed"
        return
    fi
    
    echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list >> "$LOG_FILE" 2>&1
    curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2>> "$LOG_FILE"
    apt-get update -y >> "$LOG_FILE" 2>&1
    apt-get install -y sublime-text >> "$LOG_FILE" 2>&1 || true
    
    echo ""
    success_msg "Sublime Text installed"
}

install_nodejs() {
    section_header "⬡ NODE.JS"
    
    CURRENT_PACKAGE=$((CURRENT_PACKAGE + 1))
    gauge_set $((CURRENT_PACKAGE * 100 / TOTAL_PACKAGES)) "nodejs"
    
    if command -v node &> /dev/null; then
        echo "[SKIP] Node.js already installed" >> "$LOG_FILE"
        echo ""
        success_msg "Node.js already installed"
        return
    fi
    
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - >> "$LOG_FILE" 2>&1 || true
    apt-get install -y nodejs >> "$LOG_FILE" 2>&1 || true
    
    echo ""
    success_msg "Node.js installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# AUDIO CONFIGURATION - Complete PulseAudio Setup with Real-Time Management
# ═══════════════════════════════════════════════════════════════════════════

configure_audio() {
    section_header "🔊 AUDIO SYSTEM CONFIGURATION"
    
    # Install all necessary audio packages
    info_msg "Installing audio packages..."
    apt-get install -y --no-install-recommends \
        pulseaudio \
        pulseaudio-utils \
        pavucontrol \
        alsa-utils \
        alsa-base \
        libpulse0 \
        libpulse-mainloop-glib0 >> "$LOG_FILE" 2>&1 || true
    
    success_msg "Audio packages installed"
    
    # Create PulseAudio client configuration
    info_msg "Configuring PulseAudio client..."
    mkdir -p /etc/pulse
    cat > /etc/pulse/client.conf << 'PULSE_CLIENT_EOF'
# ACRO PRO Edition - PulseAudio Client Configuration
# Designed for proot environment connecting to Termux PulseAudio

# Connect to Termux PulseAudio server
default-server = tcp:127.0.0.1:4713

# Disable local daemon spawning
autospawn = no
daemon-binary = /bin/true

# Disable features not supported in proot
enable-shm = false
enable-memfd = no
PULSE_CLIENT_EOF
    
    # Create audio environment script
    cat > /etc/profile.d/acro-audio.sh << 'AUDIO_PROFILE_EOF'
#!/bin/bash
# ACRO PRO Edition - Audio Environment
# Loaded automatically on every login

export PULSE_SERVER="tcp:127.0.0.1:4713"
export DISPLAY="${DISPLAY:-:1}"

# Function to check audio status
acro-audio-status() {
    if pactl info >/dev/null 2>&1; then
        echo "✓ Audio: Connected to PulseAudio"
        pactl info | grep -E "Server Name|Default Sink"
    else
        echo "✗ Audio: Not connected"
        echo "  Run in Termux: pulseaudio --start"
    fi
}
AUDIO_PROFILE_EOF
    chmod +x /etc/profile.d/acro-audio.sh
    
    # Create audio startup helper script
    cat > /usr/local/bin/acro-audio << 'AUDIO_HELPER_EOF'
#!/bin/bash
# ACRO PRO Edition - Audio Helper
# Use this to check/fix audio connection

export PULSE_SERVER="tcp:127.0.0.1:4713"

case "$1" in
    status)
        echo "Checking audio connection..."
        if pactl info >/dev/null 2>&1; then
            echo "✓ Audio is working!"
            pactl info | grep -E "Server Name|Default Sink|Default Source"
            echo ""
            echo "Available sinks:"
            pactl list short sinks 2>/dev/null || echo "No sinks found"
        else
            echo "✗ Audio not connected"
            echo ""
            echo "To fix, run in Termux (not Ubuntu):"
            echo "  pulseaudio --start --load='module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1'"
        fi
        ;;
    test)
        echo "Playing test sound..."
        speaker-test -t sine -f 440 -l 1 2>/dev/null || paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || echo "No test sound available"
        ;;
    *)
        echo "ACRO Audio Helper"
        echo "Usage: acro-audio [status|test]"
        echo ""
        echo "  status  - Check audio connection"
        echo "  test    - Play test sound"
        ;;
esac
AUDIO_HELPER_EOF
    chmod +x /usr/local/bin/acro-audio
    
    # Add to user bashrc
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        if ! grep -q "PULSE_SERVER" "/home/$USERNAME/.bashrc" 2>/dev/null; then
            cat >> "/home/$USERNAME/.bashrc" << 'USER_AUDIO_EOF'

# ACRO Audio Configuration
export PULSE_SERVER="tcp:127.0.0.1:4713"
USER_AUDIO_EOF
        fi
    fi
    
    # Add to root bashrc
    if ! grep -q "PULSE_SERVER" /root/.bashrc 2>/dev/null; then
        cat >> /root/.bashrc << 'ROOT_AUDIO_EOF'

# ACRO Audio Configuration
export PULSE_SERVER="tcp:127.0.0.1:4713"
ROOT_AUDIO_EOF
    fi
    
    # Fix pavucontrol desktop file
    if [[ -f /usr/share/applications/pavucontrol.desktop ]]; then
        sed -i 's|Exec=pavucontrol|Exec=env PULSE_SERVER=tcp:127.0.0.1:4713 pavucontrol|g' \
            /usr/share/applications/pavucontrol.desktop 2>/dev/null || true
    fi
    
    # Clean up old audio scripts that cause problems
    rm -f /root/.sound 2>/dev/null || true
    [[ -n "$USERNAME" ]] && rm -f "/home/$USERNAME/.sound" 2>/dev/null || true
    
    # Remove old .sound from ubuntu launcher if exists
    if [[ -f /data/data/com.termux/files/usr/bin/ubuntu ]]; then
        sed -i '/\.sound/d' /data/data/com.termux/files/usr/bin/ubuntu 2>/dev/null || true
    fi
    
    success_msg "Audio system configured"
    success_msg "pavucontrol installed and fixed"
    info_msg "Run 'acro-audio status' to check audio"
}

# ═══════════════════════════════════════════════════════════════════════════
# THEME INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════

install_themes() {
    section_header "🎨 PREMIUM THEME PACKAGE"
    
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
        gauge_set $((CURRENT_PACKAGE * 100 / TOTAL_PACKAGES)) "$filename"
        curl --progress-bar --insecure --fail --retry-connrefused --retry 3 \
             --retry-delay 2 --location --output "$filename" "$url" >> "$LOG_FILE" 2>&1 || true
    done
    
    echo ""
    info_msg "Extracting theme assets..."
    
    tar -xzf fonts.tar.gz -C "/usr/local/share/fonts/" 2>> "$LOG_FILE" || true
    tar -xzf icons.tar.gz -C "/usr/share/icons/" 2>> "$LOG_FILE" || true
    tar -xzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/" 2>> "$LOG_FILE" || true
    tar -xzf gtk-themes.tar.gz -C "/usr/share/themes/" 2>> "$LOG_FILE" || true
    
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        tar -xzf ubuntu-settings.tar.gz -C "/home/$USERNAME/" 2>> "$LOG_FILE" || true
        chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.config" 2>/dev/null || true
    fi
    
    # Cleanup
    rm -rf "$temp_folder"
    
    # Remove old themes
    local themes_to_remove=(Bright Daloa Emacs Moheli Retro Smoke)
    for theme in "${themes_to_remove[@]}"; do
        rm -rf "/usr/share/themes/$theme" 2>/dev/null || true
    done
    
    # Rebuild font cache
    info_msg "Rebuilding font cache..."
    fc-cache -fv >> "$LOG_FILE" 2>&1 || true
    
    # Install ACRO custom wallpaper
    info_msg "Setting ACRO wallpaper..."
    
    # Find wallpaper using multiple methods (fix for proot environment)
    local wallpaper_src=""
    if [[ -f "/root/acro-wallpaper.jpg" ]]; then
        wallpaper_src="/root/acro-wallpaper.jpg"
    elif [[ -f "$(dirname "$0")/acro-wallpaper.jpg" ]]; then
        wallpaper_src="$(dirname "$0")/acro-wallpaper.jpg"
    elif [[ -f "./acro-wallpaper.jpg" ]]; then
        wallpaper_src="./acro-wallpaper.jpg"
    elif [[ -f "/tmp/acro-wallpaper.jpg" ]]; then
        wallpaper_src="/tmp/acro-wallpaper.jpg"
    fi
    
    if [[ -n "$wallpaper_src" ]] && [[ -f "$wallpaper_src" ]]; then
        cp "$wallpaper_src" /usr/share/backgrounds/acro-wallpaper.jpg 2>/dev/null || true
        
        # Set as default XFCE wallpaper for user
        if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
            mkdir -p "/home/$USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml"
            
            # Create XML config file with broader monitor support
            cat > "/home/$USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" << 'XFCE_WALLPAPER_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="single-workspace-mode" type="bool" value="true"/>
    <property name="single-workspace-number" type="int" value="0"/>
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/acro-wallpaper.jpg"/>
          <property name="image-style" type="int" value="5"/>
          <property name="color-style" type="int" value="0"/>
        </property>
      </property>
      <property name="monitorVNC-0" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/acro-wallpaper.jpg"/>
          <property name="image-style" type="int" value="5"/>
          <property name="color-style" type="int" value="0"/>
        </property>
      </property>
      <property name="monitorscreen" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/acro-wallpaper.jpg"/>
          <property name="image-style" type="int" value="5"/>
          <property name="color-style" type="int" value="0"/>
        </property>
      </property>
    </property>
  </property>
</channel>
XFCE_WALLPAPER_EOF
            chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.config/xfce4" 2>/dev/null || true
            
            # Create an autostart script to set wallpaper on first XFCE login
            mkdir -p "/home/$USERNAME/.config/autostart"
            cat > "/home/$USERNAME/.config/autostart/acro-wallpaper.desktop" << 'AUTOSTART_EOF'
[Desktop Entry]
Type=Application
Name=ACRO Wallpaper Setup
Exec=sh -c 'sleep 3 && xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /usr/share/backgrounds/acro-wallpaper.jpg 2>/dev/null; xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image -s /usr/share/backgrounds/acro-wallpaper.jpg 2>/dev/null; xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorscreen/workspace0/last-image -s /usr/share/backgrounds/acro-wallpaper.jpg 2>/dev/null'
Hidden=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
AUTOSTART_EOF
            chown "$USERNAME:$USERNAME" "/home/$USERNAME/.config/autostart/acro-wallpaper.desktop"
        fi
        success_msg "ACRO wallpaper installed"
    fi
    
    echo ""
    success_msg "Premium theme package installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# NEOFETCH FIX - ACRO Custom ASCII and configuration
# ═══════════════════════════════════════════════════════════════════════════

fix_neofetch() {
    section_header "🖥️  NEOFETCH CONFIGURATION"
    
    # Install neofetch via wget (more reliable than apt)
    if ! command -v neofetch &> /dev/null; then
        info_msg "Installing neofetch via wget..."
        wget -q https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -O /tmp/neofetch
        chmod +x /tmp/neofetch
        mv /tmp/neofetch /usr/bin/neofetch
        success_msg "Neofetch installed"
    else
        info_msg "Neofetch already installed"
    fi
    
    # Create config directories
    mkdir -p /etc/neofetch
    mkdir -p "$HOME/.config/neofetch"
    
    # Also create for user if exists
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        mkdir -p "/home/$USERNAME/.config/neofetch"
    fi
    
    # Create ACRO custom ASCII art file - FLEXIBLE for small screens
    cat > /etc/neofetch/acro_ascii << 'ACRO_ASCII_EOF'
${c1}   █████╗  ██████╗██████╗  ██████╗ 
${c1}  ██╔══██╗██╔════╝██╔══██╗██╔═══██╗
${c2}  ███████║██║     ██████╔╝██║   ██║
${c2}  ██╔══██║██║     ██╔══██╗██║   ██║
${c3}  ██║  ██║╚██████╗██║  ██║╚██████╔╝
${c3}  ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ 
${c4}     ━━━ PRO EDITION v3.5 ━━━
ACRO_ASCII_EOF
    
    # Create custom neofetch config with ACRO branding
    cat > /etc/neofetch/config.conf << 'NEOFETCH_EOF'
# ACRO PRO Edition neofetch config
# Flexible for small screens

print_info() {
    prin "$(color 6)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    prin "$(color 15) ACRO PRO Edition $(color 4)v3.5"
    prin "$(color 6)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    info underline
    info "OS" distro
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "Terminal" term
    info "CPU" cpu
    info "Memory" memory
    info "Disk" disk
    info cols
    prin ""
    prin "$(color 5)ALEOCROPHIC$(color 7) | $(color 6)ZetaGo-Aurum"
}

# ACRO Distribution settings
distro="ACRO PRO Edition v3.5"
ascii_distro="auto"
image_source="/etc/neofetch/acro_ascii"
image_backend="ascii"

# Colors
colors=(6 4 5 3 2 1)
bold="on"
underline_enabled="on"
underline_char="─"
separator=" ➜ "

# OS Arch
os_arch="on"

# Smaller output for terminals
gap=2
NEOFETCH_EOF
    
    # Copy to user config if exists
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        cp /etc/neofetch/config.conf "/home/$USERNAME/.config/neofetch/config.conf"
        cp /etc/neofetch/acro_ascii "/home/$USERNAME/.config/neofetch/acro_ascii"
        chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.config/neofetch"
    fi
    
    # Also copy to root
    cp /etc/neofetch/config.conf "$HOME/.config/neofetch/config.conf" 2>/dev/null || true
    cp /etc/neofetch/acro_ascii "$HOME/.config/neofetch/acro_ascii" 2>/dev/null || true
    
    success_msg "Neofetch configured with ACRO branding"
}

# ═══════════════════════════════════════════════════════════════════════════
# FIX APPS - BleachBit, codecs, and other app issues
# ═══════════════════════════════════════════════════════════════════════════

fix_apps() {
    section_header "🔧 FIXING APP CONFIGURATIONS"
    
    # Fix BleachBit - create wrapper script that runs without root issues
    if [[ -f /usr/bin/bleachbit ]]; then
        cat > /usr/local/bin/bleachbit-fix << 'BLEACHBIT_EOF'
#!/bin/bash
# BleachBit wrapper for proot environment
export DISPLAY="${DISPLAY:-:1}"
/usr/bin/bleachbit --no-delete --preset "$@" 2>/dev/null || /usr/bin/bleachbit "$@"
BLEACHBIT_EOF
        chmod +x /usr/local/bin/bleachbit-fix
        
        # Fix desktop file
        if [[ -f /usr/share/applications/org.bleachbit.BleachBit.desktop ]]; then
            sed -i 's|Exec=bleachbit|Exec=bleachbit-fix|g' /usr/share/applications/org.bleachbit.BleachBit.desktop 2>/dev/null || true
        fi
        success_msg "BleachBit fixed"
    fi
    
    # Install additional codecs
    apt-get install -y --no-install-recommends \
        libavcodec-extra \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-tools \
        ffmpeg \
        libdvdread8 \
        libdvdnav4 >> "$LOG_FILE" 2>&1 || true
    
    success_msg "Codecs installed"
    
    # Create hard reset script
    cat > /usr/local/bin/vncreset << 'VNCRESET_EOF'
#!/bin/bash
# ACRO PRO Edition v3.5.1 - Hard Reset Script
# Performs a complete session reset like restarting a computer

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

echo ""
echo "${C}╔═══════════════════════════════════════════════════════╗${D}"
echo "${C}║${W}        🔄 ACRO PRO - HARD RESET 🔄                   ${C}║${D}"
echo "${C}╚═══════════════════════════════════════════════════════╝${D}"
echo ""

echo "${Y}▸${W} Stopping VNC server...${D}"
vncserver -kill :* 2>/dev/null || true

echo "${Y}▸${W} Killing all X11 applications...${D}"
pkill -9 -f "xfce" 2>/dev/null || true
pkill -9 -f "thunar" 2>/dev/null || true
pkill -9 -f "firefox" 2>/dev/null || true
pkill -9 -f "chromium" 2>/dev/null || true
pkill -9 -f "code" 2>/dev/null || true
pkill -9 -f "geany" 2>/dev/null || true
pkill -9 -f "vlc" 2>/dev/null || true
pkill -9 -f "audacity" 2>/dev/null || true
pkill -9 xfwm4 2>/dev/null || true
pkill -9 xfdesktop 2>/dev/null || true
pkill -9 xfce4-panel 2>/dev/null || true

echo "${Y}▸${W} Clearing cache and temp files...${D}"
rm -rf ~/.cache/thumbnails/* 2>/dev/null || true
rm -rf ~/.cache/mozilla/firefox/*/cache2/* 2>/dev/null || true
rm -rf ~/.cache/chromium/*/Cache/* 2>/dev/null || true
rm -rf ~/.cache/sessions/* 2>/dev/null || true
rm -rf ~/.local/share/recently-used.xbel 2>/dev/null || true
rm -rf /tmp/.X*-lock 2>/dev/null || true
rm -rf /tmp/.X11-unix/X* 2>/dev/null || true
rm -rf ~/.vnc/*.pid 2>/dev/null || true
rm -rf ~/.vnc/*.log 2>/dev/null || true

echo "${Y}▸${W} Clearing XFCE session cache...${D}"
rm -rf ~/.cache/sessions/* 2>/dev/null || true
rm -rf ~/.local/share/xfce4/sessions/* 2>/dev/null || true

echo "${Y}▸${W} Clearing browser tabs (Firefox)...${D}"
rm -rf ~/.mozilla/firefox/*/sessionstore* 2>/dev/null || true
rm -rf ~/.mozilla/firefox/*/recovery* 2>/dev/null || true

echo "${Y}▸${W} Clearing browser tabs (Chromium)...${D}"
rm -rf ~/.config/chromium/*/Current* 2>/dev/null || true
rm -rf ~/.config/chromium/*/Last* 2>/dev/null || true

echo "${Y}▸${W} Resetting dconf (optional)...${D}"
# dconf reset -f / 2>/dev/null || true  # Uncomment to fully reset settings

echo ""
echo "${G}✓${W} Hard reset complete!${D}"
echo ""
echo "${C}To start fresh session, run: ${Y}vncstart${D}"
echo ""
VNCRESET_EOF
    chmod +x /usr/local/bin/vncreset
    success_msg "Hard reset script (vncreset) installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# GPU OPTIMIZATION - VirGL, Mesa, and 3D rendering optimization
# ═══════════════════════════════════════════════════════════════════════════

configure_gpu() {
    section_header "🎮 GPU, CPU & KERNEL OPTIMIZATION"
    
    info_msg "Configuring GPU environment for proot (VirGL + llvmpipe auto-detect)..."
    
    # Create GPU environment configuration
    cat > /etc/profile.d/acro-gpu.sh << 'GPU_ENV_EOF'
#!/bin/bash
# ACRO PRO Edition - GPU Configuration
# Optimized for 3D rendering and graphics performance in proot

# Auto-detect if VirGL (GPU emulation) is active
if ss -tuln | grep -q "2345" || [ -S "/tmp/.virgl_test" ] || [ -S "/data/data/com.termux/files/usr/tmp/.virgl_test" ]; then
    export GALLIUM_DRIVER=virpipe
    export VIRGL_NO_SURFACE=1
    export LIBGL_ALWAYS_SOFTWARE=0
    export MESA_GL_VERSION_OVERRIDE=4.0
    export MESA_GLSL_VERSION_OVERRIDE=400
else
    # Fallback to software rendering (fully optimized)
    export LIBGL_ALWAYS_SOFTWARE=1
    export GALLIUM_DRIVER=llvmpipe
    export LP_NUM_THREADS=$(nproc)
    export MESA_GL_VERSION_OVERRIDE=4.5
    export MESA_GLSL_VERSION_OVERRIDE=450
fi

# Performance tweaks
export __GL_SYNC_TO_VBLANK=0
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_PATH="$HOME/.cache/mesa_shader_cache"
export MESA_EXTENSION_MAX_YEAR=2030

# Blender and Qt specific rendering overrides
export CYCLES_OPENCL_TEST=none
export QT_XCB_FORCE_SOFTWARE_OPENGL=1
export LIBGL_DRI3_DISABLE=1
GPU_ENV_EOF
    chmod +x /etc/profile.d/acro-gpu.sh
    success_msg "GPU environment configured"

    info_msg "Configuring CPU & Kernel optimizations..."
    
    # Create CPU optimization script
    cat > /etc/profile.d/acro-cpu.sh << 'CPU_ENV_EOF'
#!/bin/bash
# ACRO PRO Edition - CPU & Performance Configuration

# Low-level system overrides
export PROOT_NO_SECCOMP=1

# Multi-threading optimization
export OMP_NUM_THREADS=$(nproc)
export MAKEFLAGS="-j$(nproc)"
export FORCE_MULTITHREADING=1

# Low-level memory speedups
export PYTHONMALLOC=malloc
export MALLOC_CHECK_=0
export MALLOC_PERTURB_=0

# Virtual Machine memory allocations (Java/Node)
export NODE_OPTIONS="--max-old-space-size=4096"
export _JAVA_OPTIONS="-XX:+UseG1GC -XX:+UseStringDeduplication"
CPU_ENV_EOF
    chmod +x /etc/profile.d/acro-cpu.sh
    success_msg "CPU and kernel emulator tweaks configured"
    
    # Create GPU info script
    info_msg "Creating GPU tools..."
    cat > /usr/local/bin/acro-gpu << 'GPU_TOOL_EOF'
#!/bin/bash
# ACRO PRO Edition - GPU Information Tool

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

show_gpu_info() {
    echo ""
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} ACRO GPU Information                           ${D}"
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    echo "${Y}▸ OpenGL Renderer:${D}"
    glxinfo 2>/dev/null | grep -E "OpenGL renderer|OpenGL version" | head -2 || echo "  glxinfo not available"
    echo ""
    
    echo "${Y}▸ Mesa Driver:${D}"
    glxinfo 2>/dev/null | grep -i "mesa" | head -1 || echo "  Mesa info not available"
    echo ""
    
    echo "${Y}▸ GPU Environment:${D}"
    echo "  GALLIUM_DRIVER: ${GALLIUM_DRIVER:-not set}"
    echo "  MESA_GL_VERSION: ${MESA_GL_VERSION_OVERRIDE:-not set}"
    echo "  LP_NUM_THREADS: ${LP_NUM_THREADS:-not set}"
    echo ""
    
    echo "${Y}▸ GLX Extensions:${D}"
    glxinfo 2>/dev/null | grep "GLX version" | head -1 || echo "  Not available"
    echo ""
}

run_benchmark() {
    echo ""
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} GPU Benchmark (glmark2)                        ${D}"
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    if command -v glmark2 &>/dev/null; then
        glmark2 --run-forever --size 640x480
    else
        echo "${R}glmark2 not installed${D}"
    fi
}

case "$1" in
    info|status)
        show_gpu_info
        ;;
    bench|benchmark)
        run_benchmark
        ;;
    *)
        echo "ACRO GPU Tool"
        echo "Usage: acro-gpu [info|bench]"
        echo ""
        echo "  info   - Show GPU information"
        echo "  bench  - Run GPU benchmark"
        ;;
esac
GPU_TOOL_EOF
    chmod +x /usr/local/bin/acro-gpu
    
    success_msg "GPU tools installed (run 'acro-gpu info')"
    
    # Create shader cache directory
    mkdir -p "$HOME/.cache/mesa_shader_cache"
    [[ -n "$USERNAME" ]] && mkdir -p "/home/$USERNAME/.cache/mesa_shader_cache" && chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.cache"
    
    success_msg "GPU optimization complete"
}

# ═══════════════════════════════════════════════════════════════════════════
# FLATPAK CONFIGURATION - Enable Flatpak support
# ═══════════════════════════════════════════════════════════════════════════

configure_flatpak() {
    section_header "📦 FLATPAK CONFIGURATION"
    
    info_msg "Configuring Flatpak..."
    
    # Add Flathub repository
    if command -v flatpak &>/dev/null; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >> "$LOG_FILE" 2>&1 || true
        success_msg "Flathub repository added"
    else
        warning_msg "Flatpak not installed - skipping configuration"
    fi
    
    # Configure Flatpak for user if exists
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        su - "$USERNAME" -c "flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo" >> "$LOG_FILE" 2>&1 || true
    fi
    
    success_msg "Flatpak configured"
}

# ═══════════════════════════════════════════════════════════════════════════
# FIX WINDOW GLITCHES - Synaptic, pavucontrol, and app responsiveness
# ═══════════════════════════════════════════════════════════════════════════

fix_window_glitches() {
    section_header "🪟 FIXING WINDOW & APP ISSUES"
    
    info_msg "Fixing Synaptic Package Manager..."
    
    # Fix Synaptic - create wrapper
    cat > /usr/local/bin/synaptic-fix << 'SYNAPTIC_EOF'
#!/bin/bash
# Synaptic wrapper for proot
export DISPLAY="${DISPLAY:-:1}"
export GDK_SYNCHRONIZE=1
export GDK_RENDERING=image
pkexec env DISPLAY="$DISPLAY" /usr/sbin/synaptic "$@" 2>/dev/null || \
    /usr/sbin/synaptic "$@" 2>/dev/null || \
    gksudo synaptic "$@" 2>/dev/null || \
    sudo /usr/sbin/synaptic "$@"
SYNAPTIC_EOF
    chmod +x /usr/local/bin/synaptic-fix
    
    # Fix Synaptic desktop file
    if [[ -f /usr/share/applications/synaptic.desktop ]]; then
        sed -i 's|Exec=.*|Exec=synaptic-fix|g' /usr/share/applications/synaptic.desktop 2>/dev/null || true
        sed -i '/^Exec=/a StartupNotify=false' /usr/share/applications/synaptic.desktop 2>/dev/null || true
    fi
    
    success_msg "Synaptic fixed"
    
    info_msg "Fixing pavucontrol mixer..."
    
    # Fix pavucontrol - create wrapper to fix glitches
    cat > /usr/local/bin/pavucontrol-fix << 'PAVU_EOF'
#!/bin/bash
# PavuControl wrapper for proot - fixes window glitches
export DISPLAY="${DISPLAY:-:1}"
export PULSE_SERVER="${PULSE_SERVER:-tcp:127.0.0.1:4713}"
export GDK_SYNCHRONIZE=1
export GDK_RENDERING=image
export GTK_OVERLAY_SCROLLING=0
/usr/bin/pavucontrol "$@" 2>/dev/null
PAVU_EOF
    chmod +x /usr/local/bin/pavucontrol-fix
    
    # Fix pavucontrol desktop file
    if [[ -f /usr/share/applications/pavucontrol.desktop ]]; then
        sed -i 's|Exec=.*|Exec=pavucontrol-fix|g' /usr/share/applications/pavucontrol.desktop 2>/dev/null || true
    fi
    
    success_msg "pavucontrol fixed"
    
    info_msg "Fixing general window issues..."
    
    # Create GTK settings for better compatibility
    mkdir -p /etc/gtk-3.0
    cat > /etc/gtk-3.0/settings.ini << 'GTK_SETTINGS_EOF'
[Settings]
gtk-overlay-scrolling = false
gtk-enable-animations = false
gtk-primary-button-warps-slider = false
GTK_SETTINGS_EOF
    
    # Fix XFCE compositor settings
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        mkdir -p "/home/$USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml"
        cat > "/home/$USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" << 'XFWM4_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="use_compositing" type="bool" value="false"/>
    <property name="sync_to_vblank" type="bool" value="false"/>
    <property name="unredirect_overlays" type="bool" value="true"/>
    <property name="show_frame_shadow" type="bool" value="false"/>
    <property name="box_move" type="bool" value="true"/>
    <property name="box_resize" type="bool" value="true"/>
  </property>
</channel>
XFWM4_EOF
        chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.config/xfce4"
    fi
    
    success_msg "Window glitches fixed"
}

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURE LANGUAGE - Set in .bashrc for proper locale detection
# ═══════════════════════════════════════════════════════════════════════════

configure_language() {
    section_header "🌐 CONFIGURING LANGUAGE SETTINGS"
    
    # Ensure locale packages are installed
    apt-get install -y locales locales-all >> "$LOG_FILE" 2>&1 || true
    
    # Generate common locales
    locale-gen en_US.UTF-8 >> "$LOG_FILE" 2>&1 || true
    locale-gen id_ID.UTF-8 >> "$LOG_FILE" 2>&1 || true
    
    # Set default locale
    update-locale LANG=en_US.UTF-8 >> "$LOG_FILE" 2>&1 || true
    
    # Add to /etc/profile for all users
    cat >> /etc/profile << 'LOCALE_PROFILE_EOF'

# ACRO PRO Edition - Locale settings
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en_US:en}"
LOCALE_PROFILE_EOF
    
    # Add to user's .bashrc if exists
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        cat >> "/home/$USERNAME/.bashrc" << 'LOCALE_BASHRC_EOF'

# Modded Ubuntu PRO - Locale settings (set by installer)
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en_US:en}"

# Display settings
export DISPLAY="${DISPLAY:-:1}"

# PulseAudio settings
export PULSE_SERVER="${PULSE_SERVER:-127.0.0.1}"
LOCALE_BASHRC_EOF
        chown "$USERNAME:$USERNAME" "/home/$USERNAME/.bashrc"
    fi
    
    # Also add to root .bashrc
    cat >> /root/.bashrc << 'LOCALE_ROOT_EOF'

# ACRO PRO Edition - Locale settings
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en_US:en}"
export DISPLAY="${DISPLAY:-:1}"
export PULSE_SERVER="${PULSE_SERVER:-127.0.0.1}"
LOCALE_ROOT_EOF
    
    success_msg "Language settings configured in .bashrc"
    info_msg "Use 'acro-settings' to change language after installation"
}

# ═══════════════════════════════════════════════════════════════════════════
# STORAGE SHARING - Mount Termux storage inside ACRO
# ═══════════════════════════════════════════════════════════════════════════

configure_storage_sharing() {
    section_header "📁 CONFIGURING STORAGE SHARING"
    
    # Create storage symlinks for easy access
    local termux_storage="/data/data/com.termux/files/home/storage"
    
    if [[ -d "$termux_storage" ]]; then
        # Create storage directory in root home
        mkdir -p /root/storage
        
        # Create symlinks in root
        ln -sf "$termux_storage/shared" /root/storage/shared 2>/dev/null || true
        ln -sf "$termux_storage/downloads" /root/storage/downloads 2>/dev/null || true
        ln -sf "$termux_storage/dcim" /root/storage/dcim 2>/dev/null || true
        ln -sf "$termux_storage/music" /root/storage/music 2>/dev/null || true
        ln -sf "$termux_storage/movies" /root/storage/movies 2>/dev/null || true
        ln -sf "$termux_storage/pictures" /root/storage/pictures 2>/dev/null || true
        ln -sf "/sdcard" /root/storage/sdcard 2>/dev/null || true
        
        success_msg "Root storage links created"
        
        # Create for user if exists
        if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
            mkdir -p "/home/$USERNAME/storage"
            
            ln -sf "$termux_storage/shared" "/home/$USERNAME/storage/shared" 2>/dev/null || true
            ln -sf "$termux_storage/downloads" "/home/$USERNAME/storage/downloads" 2>/dev/null || true
            ln -sf "$termux_storage/dcim" "/home/$USERNAME/storage/dcim" 2>/dev/null || true
            ln -sf "$termux_storage/music" "/home/$USERNAME/storage/music" 2>/dev/null || true
            ln -sf "$termux_storage/movies" "/home/$USERNAME/storage/movies" 2>/dev/null || true
            ln -sf "$termux_storage/pictures" "/home/$USERNAME/storage/pictures" 2>/dev/null || true
            ln -sf "/sdcard" "/home/$USERNAME/storage/sdcard" 2>/dev/null || true
            
            chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/storage" 2>/dev/null || true
            success_msg "User storage links created"
        fi
        
        info_msg "Access phone storage via ~/storage/"
    else
        warning_msg "Termux storage not found"
        info_msg "Run 'termux-setup-storage' in Termux first"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# FINAL CLEANUP
# ═══════════════════════════════════════════════════════════════════════════

final_cleanup() {
    section_header "🧹 FINAL CLEANUP & OPTIMIZATION"
    
    {
        apt-get update -y
        apt-get upgrade -y
        apt-get clean
        apt-get autoremove -y
    } >> "$LOG_FILE" 2>&1 &
    spinner $! "Optimizing system..."
    
    success_msg "System optimized"
    
    # Calculate elapsed time
    local end_time=$(date +%s)
    local elapsed=$((end_time - START_TIME))
    local minutes=$((elapsed / 60))
    local seconds=$((elapsed % 60))
    
    info_msg "Total installation time: ${minutes}m ${seconds}s"
}

# ═══════════════════════════════════════════════════════════════════════════
# COMPLETION MESSAGE
# ═══════════════════════════════════════════════════════════════════════════

show_complete() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    
    local profile_name="MINIMAL (50 pkgs)"
    [[ "$SELECTED_TIER" == "ultimate" ]] && profile_name="COMPLETE (1000+ pkgs)"
    [[ "$SELECTED_TIER" == "custom" ]] && profile_name="CUSTOM"
    
    local wine_line=""
    if [[ "$SELECTED_TIER" == "ultimate" ]] || [[ "$CHOICES" =~ "WINE" ]]; then
        wine_line="\n  acro-wine       →  Run Windows apps"
    fi
    
    dialog --colors --msgbox "\n\Zb\Z2INSTALLATION COMPLETED!\Zn\n\n\
Profile: \Z6$profile_name\Zn\n\
Time: \Z6${minutes}m ${seconds}s\Zn\n\n\
\Z4QUICK START:\Zn\n\
  \Zbvncstart\Zn         →  Start VNC server\n\
  \Zbx11start\Zn         →  Start Termux-X11 session\n\
  \Zbsettings\Zn          →  System Settings Utility$wine_line\n\n\
\Z5VNC: localhost:1  |  Quality: HIGH\Zn\n\
\Z3Log: $LOG_FILE\Zn\n\n\
\Z5PRO Edition by ZetaGo-Aurum  |  ALEOCROPHIC\Zn" 20 60
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

install_free_tier() {
    section_header "🆓 FREE TIER - FAST INSTALLATION"
    
    TOTAL_PACKAGES=${#FREE_TIER_PACKAGES[@]}
    CURRENT_PACKAGE=0
    
    gauge_start "FREE TIER - $TOTAL_PACKAGES packages"
    
    for pkg in "${FREE_TIER_PACKAGES[@]}"; do
        install_pkg "$pkg"
    done
    
    gauge_stop
    echo ""
    success_msg "FREE tier packages installed"
}

main() {
    # Initialize log
    echo "=== ACRO v${VERSION} Installation Log ===" > "$LOG_FILE"
    echo "Started: $(date)" >> "$LOG_FILE"
    echo "Architecture: $ARCH" >> "$LOG_FILE"
    echo "User: $USERNAME" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    # Check root first
    check_root
    
    # Install dialog if missing
    if ! command -v dialog &>/dev/null; then
        apt-get install -y dialog >> "$LOG_FILE" 2>&1
    fi
    
    # Show tier selection at the beginning
    show_tier_selection
    
    echo "Selected Tier: $SELECTED_TIER" >> "$LOG_FILE"
    
    banner
    
    if [[ "$SELECTED_TIER" == "free" ]]; then
        # ═══════════════════════════════════════════════════════════════
        # MINIMAL PROFILE - 50 PACKAGES, FAST, ENGLISH ONLY
        # ═══════════════════════════════════════════════════════════════
        
        echo -e "  ${C}╔═══════════════════════════════════════════════════════════════════╗${D}"
        echo -e "  ${C}║${W}            🆓 MINIMAL PROFILE - FAST INSTALLATION 🆓              ${C}║${D}"
        echo -e "  ${C}╠═══════════════════════════════════════════════════════════════════╣${D}"
        echo -e "  ${C}║${D}                                                                   ${C}║${D}"
        echo -e "  ${C}║${W}  Installing 50 essential packages only:                          ${C}║${D}"
        echo -e "  ${C}║${GRAY}  • Basic XFCE Desktop                                           ${C}║${D}"
        echo -e "  ${C}║${GRAY}  • VNC Server + PulseAudio                                      ${C}║${D}"
        echo -e "  ${C}║${GRAY}  • Firefox Browser                                              ${C}║${D}"
        echo -e "  ${C}║${GRAY}  • English fonts only                                           ${C}║${D}"
        echo -e "  ${C}║${D}                                                                   ${C}║${D}"
        echo -e "  ${C}║${GREEN_L}  Estimated time: ~15 minutes                                    ${C}║${D}"
        echo -e "  ${C}║${D}                                                                   ${C}║${D}"
        echo -e "  ${C}╚═══════════════════════════════════════════════════════════════════╝${D}"
        echo ""
        
        sleep 2
        
        # Fix package manager
        fix_dpkg
        
        # Install FREE tier packages only
        install_free_tier
        
        # Basic configurations
        configure_audio
        fix_neofetch
        fix_apps
        configure_storage_sharing
        final_cleanup
        
    else
        # ═══════════════════════════════════════════════════════════════
        # COMPLETE OR CUSTOM PROFILE - FREE SELECTION
        # ═══════════════════════════════════════════════════════════════
        
        # If complete profile is chosen, select all categories
        if [[ "$SELECTED_TIER" == "ultimate" ]]; then
            CHOICES="BASE DESKTOP_XFCE BROWSERS DEV OFFICE GRAPHICS AUDIO VIDEO DB NET SEC WINE GPU FLATPAK LOCALES"
        fi
        
        # Calculate total packages based on selections
        TOTAL_PACKAGES=0
        if [[ "$CHOICES" =~ "BASE" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#BASE_PACKAGES[@]} + ${#UTILITY_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "DESKTOP_XFCE" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#XFCE_PACKAGES[@]} + ${#THEME_PACKAGES[@]} + ${#VNC_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "DESKTOP_GNOME" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#GNOME_PACKAGES[@]} + ${#VNC_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "LOCALES" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#LOCALE_PACKAGES[@]} + ${#FONT_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "DEV" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#DEV_PACKAGES[@]} + 3)); fi
        if [[ "$CHOICES" =~ "DB" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#DATABASE_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "GPU" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#GPU_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "FLATPAK" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#SOFTWARE_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "OFFICE" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#OFFICE_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "GRAPHICS" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#GRAPHICS_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "AUDIO" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#AUDIO_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "VIDEO" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#VIDEO_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "NET" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#NETWORK_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "SEC" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#SECURITY_PACKAGES[@]})); fi
        if [[ "$CHOICES" =~ "BROWSERS" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + 2)); fi
        if [[ "$CHOICES" =~ "WINE" ]]; then TOTAL_PACKAGES=$((TOTAL_PACKAGES + 3)); fi
        
        # 64-bit only check
        if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "x86_64" ]]; then
            if [[ "$CHOICES" =~ "VIDEO" ]] || [[ "$CHOICES" =~ "GRAPHICS" ]]; then
                TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#VIDEO_EDITING_64[@]}))
            fi
        fi
        
        echo -e "  ${PURPLE}╔═══════════════════════════════════════════════════════════════════╗${D}"
        echo -e "  ${PURPLE}║${W}            🚀 PROFILES INSTALLATION - DEPLOYING PACKAGES          ${PURPLE}║${D}"
        echo -e "  ${PURPLE}╠═══════════════════════════════════════════════════════════════════╣${D}"
        echo -e "  ${PURPLE}║${D}                                                                   ${PURPLE}║${D}"
        echo -e "  ${PURPLE}║${W}  Installing selected package groups dynamically...              ${PURPLE}║${D}"
        echo -e "  ${PURPLE}║${W}  Total Packages to process: ~${TOTAL_PACKAGES}                              ${PURPLE}║${D}"
        echo -e "  ${PURPLE}║${D}                                                                   ${PURPLE}║${D}"
        echo -e "  ${PURPLE}╚═══════════════════════════════════════════════════════════════════╝${D}"
        echo ""
        
        sleep 2
        
        # Fix package manager
        fix_dpkg
        
        # Start progress gauge
        gauge_start "ACRO PRO - Installing $TOTAL_PACKAGES packages"
        
        # Install selected package categories
        if [[ "$CHOICES" =~ "BASE" ]]; then
            install_category "BASE SYSTEM" "${BASE_PACKAGES[@]}"
            install_category "SYSTEM UTILITIES" "${UTILITY_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "DESKTOP_XFCE" ]]; then
            install_category "XFCE DESKTOP" "${XFCE_PACKAGES[@]}"
            install_category "VNC SERVER" "${VNC_PACKAGES[@]}"
            install_category "THEMES & APPEARANCE" "${THEME_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "DESKTOP_GNOME" ]]; then
            section_header "🐧 GNOME DESKTOP OPTION"
            apt-get install -y gnome-session gnome-terminal gnome-control-center gnome-backgrounds gnome-themes-extra adwaita-icon-theme-full >> "$LOG_FILE" 2>&1 || true
            install_category "VNC SERVER" "${VNC_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "LOCALES" ]]; then
            install_category "LOCALES (All Languages)" "${LOCALE_PACKAGES[@]}"
            install_category "FONTS (All Languages)" "${FONT_PACKAGES[@]}"
        else
            # Ensure basic fonts are loaded if VNC is selected
            if [[ "$CHOICES" =~ "DESKTOP_XFCE" ]] || [[ "$CHOICES" =~ "DESKTOP_GNOME" ]]; then
                install_category "ESSENTIAL FONTS" fonts-dejavu-core fonts-liberation fonts-noto
            fi
        fi
        if [[ "$CHOICES" =~ "DEV" ]]; then
            install_category "DEVELOPMENT TOOLS" "${DEV_PACKAGES[@]}"
            install_vscode
            install_sublime
            install_nodejs
        fi
        if [[ "$CHOICES" =~ "DB" ]]; then
            install_category "DATABASES" "${DATABASE_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "GPU" ]]; then
            install_category "GPU & 3D GRAPHICS" "${GPU_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "FLATPAK" ]]; then
            install_category "SOFTWARE CENTER" "${SOFTWARE_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "OFFICE" ]]; then
            install_category "OFFICE SUITE" "${OFFICE_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "GRAPHICS" ]]; then
            install_category "GRAPHICS & DESIGN" "${GRAPHICS_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "AUDIO" ]]; then
            install_category "AUDIO PRODUCTION" "${AUDIO_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "VIDEO" ]]; then
            install_category "VIDEO & MEDIA" "${VIDEO_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "NET" ]]; then
            install_category "NETWORK TOOLS" "${NETWORK_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "SEC" ]]; then
            install_category "SECURITY TOOLS" "${SECURITY_PACKAGES[@]}"
        fi
        if [[ "$CHOICES" =~ "BROWSERS" ]]; then
            install_firefox
            install_chromium
        fi
        
        # 64-bit only categories
        if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "x86_64" ]]; then
            if [[ "$CHOICES" =~ "VIDEO" ]] || [[ "$CHOICES" =~ "GRAPHICS" ]]; then
                install_category "VIDEO EDITING (64-bit)" "${VIDEO_EDITING_64[@]}"
            fi
        fi
        
        # Configure systems
        if [[ "$CHOICES" =~ "DESKTOP_XFCE" ]] || [[ "$CHOICES" =~ "DESKTOP_GNOME" ]] || [[ "$CHOICES" =~ "AUDIO" ]]; then
            configure_audio
        fi
        if [[ "$CHOICES" =~ "GPU" ]]; then
            configure_gpu
        fi
        if [[ "$CHOICES" =~ "FLATPAK" ]]; then
            configure_flatpak
        fi
        if [[ "$CHOICES" =~ "DESKTOP_XFCE" ]]; then
            install_themes
        fi
        
        fix_neofetch
        fix_apps
        fix_window_glitches
        configure_language
        configure_storage_sharing
        
        if [[ "$CHOICES" =~ "WINE" ]]; then
            configure_wine_box86
        fi
        
        gauge_stop
        final_cleanup
    fi
    
    # Show completion
    show_complete
    
    echo "Tier: $SELECTED_TIER" >> "$LOG_FILE"
    echo "Completed: $(date)" >> "$LOG_FILE"
}

# Run main
main

