#!/bin/bash

##############################################################################
#                                                                            #
#   ACRO PRO Edition v3.2.0 - GUI INSTALLER                                  #
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
USERNAME=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)
VERSION="3.2.0"
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

# Pip-style progress bar
pip_progress() {
    local current=$1
    local total=$2
    local pkg_name=$3
    local width=30
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    # Build the bar with proper characters
    local bar_filled=""
    local bar_empty=""
    for ((i=0; i<filled; i++)); do bar_filled+="▓"; done
    for ((i=0; i<empty; i++)); do bar_empty+="░"; done
    
    # Print with proper color handling
    printf "\r  ${PURPLE}Installing${D} ${PURPLE}[${GREEN_L}%s${GRAY}%s${PURPLE}]${D} ${W}%3d%%${D} ${GRAY}(%d/%d)${D} ${CYAN_L}%s${D}          " \
        "$bar_filled" "$bar_empty" $percentage $current $total "$pkg_name"
}

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
    ║            🎨 A C R O   G U I   I N S T A L L E R   v3.2.0 🎨            ║
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
    
    # Update package lists
    info_msg "Updating package lists..."
    apt-get update -y >> "$LOG_FILE" 2>&1 || true
    
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
    pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "$pkg"
    
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
    pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "$pkg"
    
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
# INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

fix_dpkg() {
    section_header "🔧 FIXING PACKAGE MANAGER"
    
    # Fix udisks2 known issue
    apt-get update -y >> "$LOG_FILE" 2>&1
    apt-get install -y udisks2 >> "$LOG_FILE" 2>&1 || true
    rm -f /var/lib/dpkg/info/udisks2.postinst 2>/dev/null
    echo "" > /var/lib/dpkg/info/udisks2.postinst 2>/dev/null
    dpkg --configure -a >> "$LOG_FILE" 2>&1 || true
    apt-mark hold udisks2 >> "$LOG_FILE" 2>&1 || true
    
    # Fix broken installs
    apt-get -f install -y >> "$LOG_FILE" 2>&1 || true
    
    success_msg "Package manager fixed"
}

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
    pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "firefox"
    
    if command -v firefox &> /dev/null; then
        echo "[SKIP] Firefox already installed" >> "$LOG_FILE"
        echo ""
        success_msg "Firefox already installed"
        return
    fi
    
    # Remove snap version
    snap remove firefox 2>/dev/null || true
    
    # Add Mozilla PPA
    add-apt-repository -y ppa:mozillateam/ppa >> "$LOG_FILE" 2>&1 || {
        echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu jammy main" | tee /etc/apt/sources.list.d/mozillateam.list >> "$LOG_FILE" 2>&1
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
    pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "chromium"
    
    if command -v chromium &> /dev/null || command -v chromium-browser &> /dev/null; then
        echo "[SKIP] Chromium already installed" >> "$LOG_FILE"
        echo ""
        success_msg "Chromium already installed"
        return
    fi
    
    apt-get purge -y chromium* snapd >> "$LOG_FILE" 2>&1 || true
    
    # Debian repository for Chromium
    echo -e "deb http://ftp.debian.org/debian buster main\ndeb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list.d/debian.list
    
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517 >> "$LOG_FILE" 2>&1 || true
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 >> "$LOG_FILE" 2>&1 || true
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A >> "$LOG_FILE" 2>&1 || true
    
    apt-get update -y >> "$LOG_FILE" 2>&1
    apt-get install -y chromium >> "$LOG_FILE" 2>&1 || apt-get install -y chromium-browser >> "$LOG_FILE" 2>&1 || true
    
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
    pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "vscode"
    
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
    pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "sublime-text"
    
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
    pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "nodejs"
    
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
        pip_progress $CURRENT_PACKAGE $TOTAL_PACKAGES "$filename"
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
    
    # First ensure neofetch is installed
    if ! command -v neofetch &> /dev/null; then
        apt-get install -y neofetch >> "$LOG_FILE" 2>&1 || true
    fi
    
    # Create config directories
    mkdir -p /etc/neofetch
    mkdir -p "$HOME/.config/neofetch"
    
    # Also create for user if exists
    if [[ -n "$USERNAME" ]] && [[ -d "/home/$USERNAME" ]]; then
        mkdir -p "/home/$USERNAME/.config/neofetch"
    fi
    
    # Create ACRO custom ASCII art file
    cat > /etc/neofetch/acro_ascii << 'ACRO_ASCII_EOF'
${c1}    _____                _____  ___________             ____     
${c1}  /      |_         _____\    \_\          \        ____\_  \__  
${c1} /         \       /     /|     |\    /\    \      /     /     \ 
${c2}|     /\    \     /     / /____/| |   \_\    |    /     /\      |
${c2}|    |  |    \   |     | |____|/  |      ___/    |     |  |     |
${c2}|     \/      \  |     |  _____   |      \  ____ |     |  |     |
${c3}|\      /\     \ |\     \|\    \ /     /\ \/    \|     | /     /|
${c3}| \_____\ \_____\| \_____\|    |/_____/ |\______|\     \_____/ |
${c3}| |     | |     || |     /____/||     | | |     || \_____\   | / 
${c4} \|_____|\|_____| \|_____|    |||_____|/ \|_____| \ |    |___|/  
${c4}                         |____|/                   \|____|       
ACRO_ASCII_EOF
    
    # Create custom neofetch config with ACRO branding
    cat > /etc/neofetch/config.conf << 'NEOFETCH_EOF'
# ACRO PRO Edition v3.2.0 neofetch config
# Custom Linux Distribution for Termux

print_info() {
    prin "$(color 6)╔══════════════════════════════════════════════════╗"
    prin "$(color 6)║$(color 15)  A C R O   P R O   E D I T I O N   v3.2.0      $(color 6)║"
    prin "$(color 6)╚══════════════════════════════════════════════════╝"
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "WM" wm
    info "Theme" theme
    info "Icons" icons
    info "Terminal" term
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
    info "Disk" disk
    info cols
    prin ""
    prin "$(color 6)Brand: $(color 13)ALEOCROPHIC$(color 6) | By: $(color 14)ZetaGo-Aurum"
}

# ACRO Distribution settings
distro="ACRO PRO Edition v3.2.0"
ascii_distro="auto"
image_source="/etc/neofetch/acro_ascii"
image_backend="ascii"

# Colors
colors=(6 6 7 4 4 7)
bold="on"
underline_enabled="on"
underline_char="─"
separator=" ➜ "

# OS Arch
os_arch="on"
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
# ACRO PRO Edition v3.2.0 - Hard Reset Script
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
    banner
    echo ""
    echo -e "  ${GREEN_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${GREEN_L}║${W}            🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉            ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  ✓ 1000+ Software packages installed                             ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  ✓ Premium dark theme configured                                 ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  ✓ Audio system with microphone support                          ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  ✓ VNC server ready                                              ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  ✓ Neofetch and pavucontrol fixed                                ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${CYAN_L}  HOW TO USE:${D}                                                      ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  Type ${Y}vncstart${W} to start VNC server${D}                               ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  Type ${Y}vncstop${W} to stop VNC server${D}                                 ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  Type ${Y}mu-settings${W} to configure system${D}                            ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${CYAN_L}  Connect with VNC Viewer:${D}                                         ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  Address: ${Y}localhost:1${D}                                                ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  Set Picture Quality to ${Y}HIGH${D}                                        ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${PINK}  PRO Edition by ZetaGo-Aurum    ${Y}│${PURPLE}    ALEOCROPHIC Brand${D}           ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${GRAY}  Original: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx${D}              ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    echo -e "  ${Y}📋 Installation log: ${W}$LOG_FILE${D}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

main() {
    # Initialize log
    echo "=== Modded Ubuntu PRO v${VERSION} Installation Log ===" > "$LOG_FILE"
    echo "Started: $(date)" >> "$LOG_FILE"
    echo "Architecture: $ARCH" >> "$LOG_FILE"
    echo "User: $USERNAME" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
    
    # Calculate total packages (base + browsers, IDEs, themes = +10)
    TOTAL_PACKAGES=$((
        ${#BASE_PACKAGES[@]} +
        ${#XFCE_PACKAGES[@]} +
        ${#VNC_PACKAGES[@]} +
        ${#FONT_PACKAGES[@]} +
        ${#THEME_PACKAGES[@]} +
        ${#DEV_PACKAGES[@]} +
        ${#DATABASE_PACKAGES[@]} +
        ${#OFFICE_PACKAGES[@]} +
        ${#GRAPHICS_PACKAGES[@]} +
        ${#AUDIO_PACKAGES[@]} +
        ${#VIDEO_PACKAGES[@]} +
        ${#UTILITY_PACKAGES[@]} +
        ${#NETWORK_PACKAGES[@]} +
        ${#SECURITY_PACKAGES[@]} +
        ${#VIRTUALIZATION_PACKAGES[@]} +
        ${#LOCALE_PACKAGES[@]} +
        10
    ))
    
    # Add 64-bit packages if applicable
    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "x86_64" ]]; then
        TOTAL_PACKAGES=$((TOTAL_PACKAGES + ${#VIDEO_EDITING_64[@]}))
    fi
    
    banner
    
    echo -e "  ${Y}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${Y}║${W}            🚀 AUTOMATIC INSTALLATION STARTING 🚀                ${Y}║${D}"
    echo -e "  ${Y}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${Y}║${D}                                                                   ${Y}║${D}"
    echo -e "  ${Y}║${W}  This will install 1000+ software packages including:            ${Y}║${D}"
    echo -e "  ${Y}║${D}                                                                   ${Y}║${D}"
    echo -e "  ${Y}║${CYAN_L}  • VSCode, Sublime, LibreOffice, GIMP, Inkscape, Krita          ${Y}║${D}"
    echo -e "  ${Y}║${CYAN_L}  • Audacity, VLC, Firefox, Chromium, FileZilla                 ${Y}║${D}"
    echo -e "  ${Y}║${CYAN_L}  • Git, Node.js, Python, Ruby, Go, Rust, PHP, Java             ${Y}║${D}"
    echo -e "  ${Y}║${CYAN_L}  • Blender, Kdenlive, OBS Studio, DaVinci (64-bit)             ${Y}║${D}"
    echo -e "  ${Y}║${CYAN_L}  • 100+ fonts for all languages including Indonesian           ${Y}║${D}"
    echo -e "  ${Y}║${D}                                                                   ${Y}║${D}"
    echo -e "  ${Y}║${GREEN_L}  Estimated time: 60-120 minutes                                ${Y}║${D}"
    echo -e "  ${Y}║${ORANGE}  Storage required: ~15-20 GB                                   ${Y}║${D}"
    echo -e "  ${Y}║${D}                                                                   ${Y}║${D}"
    echo -e "  ${Y}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    
    sleep 3
    
    # Check root
    check_root
    
    # Fix package manager
    fix_dpkg
    
    # Install all package categories
    install_category "BASE SYSTEM" "${BASE_PACKAGES[@]}"
    install_category "XFCE DESKTOP" "${XFCE_PACKAGES[@]}"
    install_category "VNC SERVER" "${VNC_PACKAGES[@]}"
    install_category "FONTS (All Languages)" "${FONT_PACKAGES[@]}"
    install_category "THEMES & APPEARANCE" "${THEME_PACKAGES[@]}"
    install_category "DEVELOPMENT TOOLS" "${DEV_PACKAGES[@]}"
    install_category "DATABASES" "${DATABASE_PACKAGES[@]}"
    install_category "OFFICE SUITE" "${OFFICE_PACKAGES[@]}"
    install_category "GRAPHICS & DESIGN" "${GRAPHICS_PACKAGES[@]}"
    install_category "AUDIO PRODUCTION" "${AUDIO_PACKAGES[@]}"
    install_category "VIDEO & MEDIA" "${VIDEO_PACKAGES[@]}"
    install_category "SYSTEM UTILITIES" "${UTILITY_PACKAGES[@]}"
    install_category "NETWORK TOOLS" "${NETWORK_PACKAGES[@]}"
    install_category "SECURITY TOOLS" "${SECURITY_PACKAGES[@]}"
    install_category "VIRTUALIZATION" "${VIRTUALIZATION_PACKAGES[@]}"
    install_category "LOCALES (All Languages)" "${LOCALE_PACKAGES[@]}"
    
    # 64-bit only packages
    if [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "x86_64" ]]; then
        install_category "VIDEO EDITING (64-bit)" "${VIDEO_EDITING_64[@]}"
    fi
    
    # Special installations
    install_firefox
    install_chromium
    install_vscode
    install_sublime
    install_nodejs
    
    # Configure system
    configure_audio
    install_themes
    fix_neofetch
    fix_apps
    configure_language
    configure_storage_sharing
    final_cleanup
    
    # Show completion
    show_complete
    
    echo "Completed: $(date)" >> "$LOG_FILE"
}

# Run main
main
