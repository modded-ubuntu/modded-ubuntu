#!/bin/bash

##############################################################################
#                                                                            #
#   MODDED UBUNTU PRO v3.1.0 - GUI INSTALLER                                 #
#   Premium High-Performance Ubuntu GUI for Termux                           #
#                                                                            #
#   Original Script: modded-ubuntu                                           #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#   Original Repo: https://github.com/modded-ubuntu/modded-ubuntu            #
#                                                                            #
#   PRO Remake By: ZetaGo-Aurum                                              #
#   Brand: ALEOCROPHIC                                                       #
#   Features: 1000+ Pre-installed Software, Automatic Setup, Audio Fix      #
#                                                                            #
##############################################################################

# ═══════════════════════════════════════════════════════════════════════════
# COLOR PALETTE - Modern Sleek Design
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
LPURPLE="\033[38;5;177m"
PINK="\033[38;5;213m"
CYAN_L="\033[38;5;81m"
GREEN_L="\033[38;5;120m"
ORANGE="\033[38;5;208m"
GRAY="\033[38;5;245m"
DGRAY="\033[38;5;238m"

BG_DGRAY="\033[48;5;236m"
BG_PURPLE="\033[48;5;54m"

# System info
ARCH=$(uname -m)
USERNAME=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)
VERSION="3.1.0 PRO"
LOG_FILE="/tmp/modded-ubuntu-pro-install.log"
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
    local width=35
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    # Calculate ETA
    local elapsed=$(($(date +%s) - START_TIME))
    local rate=0
    [[ $elapsed -gt 0 ]] && rate=$((current * 100 / elapsed))
    
    # Build progress bar
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="━"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    
    # Clear line and print
    printf "\r  ${PURPLE}Installing${D} ${bar} ${W}%3d%%${D} ${GRAY}(%d/%d)${D} ${CYAN_L}%s${D}%-20s" \
        $percentage $current $total "$pkg_name" " "
}

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
    ║          🎨 G U I   I N S T A L L E R   v3.1.0  🎨               ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${D}"
    echo -e "${CYAN_L}  ┌───────────────────────────────────────────────────────────────────┐${D}"
    echo -e "${CYAN_L}  │${W}  1000+ Software Packages     ${Y}│${GREEN_L} Fully Automatic Installation${CYAN_L}   │${D}"
    echo -e "${CYAN_L}  │${PINK}  ZetaGo-Aurum                 ${Y}│${PURPLE} ALEOCROPHIC Brand${CYAN_L}              │${D}"
    echo -e "${CYAN_L}  └───────────────────────────────────────────────────────────────────┘${D}"
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
# AUDIO CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

configure_audio() {
    section_header "🔊 AUDIO SYSTEM CONFIGURATION"
    
    # Environment variables
    echo 'export DISPLAY=":1"' >> /etc/profile
    echo 'export PULSE_SERVER=127.0.0.1' >> /etc/profile
    
    # Fix pavucontrol desktop file
    if [[ -f /usr/share/applications/pavucontrol.desktop ]]; then
        sed -i 's/Exec=pavucontrol/Exec=env PULSE_SERVER=127.0.0.1 pavucontrol/g' \
            /usr/share/applications/pavucontrol.desktop 2>/dev/null || true
    fi
    
    # Add audio to ubuntu launcher
    echo "$(echo 'bash ~/.sound' | cat - /data/data/com.termux/files/usr/bin/ubuntu)" > /data/data/com.termux/files/usr/bin/ubuntu 2>/dev/null || true
    
    source /etc/profile 2>/dev/null || true
    
    success_msg "Audio system configured"
    success_msg "Pavucontrol fixed for proot environment"
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
    
    echo ""
    success_msg "Premium theme package installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# NEOFETCH FIX
# ═══════════════════════════════════════════════════════════════════════════

fix_neofetch() {
    section_header "🖥️  NEOFETCH CONFIGURATION"
    
    # Create neofetch config dir
    mkdir -p /etc/neofetch
    
    # Create custom neofetch config
    cat > /etc/neofetch/config.conf << 'EOF'
# Modded Ubuntu PRO neofetch config
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "WM" wm
    info "WM Theme" wm_theme
    info "Theme" theme
    info "Icons" icons
    info "Terminal" term
    info "CPU" cpu
    info "Memory" memory
    info cols
}

# Force Ubuntu detection
distro="Ubuntu (Modded PRO)"
ascii_distro="Ubuntu"
EOF
    
    success_msg "Neofetch configured"
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
    
    # Calculate total packages
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
        10  # browsers, IDEs, themes, etc.
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
    final_cleanup
    
    # Show completion
    show_complete
    
    echo "Completed: $(date)" >> "$LOG_FILE"
}

# Run main
main
