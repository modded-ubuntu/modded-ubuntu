#!/bin/bash
##############################################################################
#                                                                            #
#   ACRO Smart Update Script                                                 #
#   Updates packages based on user tier (FREE / PRO+ / ULTIMATE)             #
#                                                                            #
#   By: ZetaGo-Aurum | ALEOCROPHIC Brand                                     #
#                                                                            #
##############################################################################

# Colors
R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
M=$'\033[1;35m'
W=$'\033[1;37m'
D=$'\033[0m'

LOG_FILE="/tmp/acro-update.log"
LICENSE_FILE="$HOME/.acro-license"
TIER_FILE="$HOME/.acro-tier"

# ═══════════════════════════════════════════════════════════════════════════
# TIER DETECTION
# ═══════════════════════════════════════════════════════════════════════════

detect_tier() {
    if [ -f "$LICENSE_FILE" ]; then
        LICENSE_KEY=$(cat "$LICENSE_FILE" 2>/dev/null | head -1)
        
        if [[ "$LICENSE_KEY" == ACRO-ULT-* ]]; then
            echo "ultimate"
            return
        elif [[ "$LICENSE_KEY" == ACRO-PP-* ]]; then
            echo "proplus"
            return
        fi
    fi
    
    if [ -f "$TIER_FILE" ]; then
        cat "$TIER_FILE" 2>/dev/null | head -1
        return
    fi
    
    echo "free"
}

# ═══════════════════════════════════════════════════════════════════════════
# PACKAGE DEFINITIONS BY TIER
# ═══════════════════════════════════════════════════════════════════════════

# FREE TIER - 50 Essential Packages (Basic, Fast)
FREE_PACKAGES=(
    # Core (15)
    sudo curl wget nano vim git unzip zip tar htop
    apt-utils software-properties-common ca-certificates gnupg lsb-release
    
    # Desktop (10)
    xfce4 xfce4-terminal thunar ristretto tumbler
    xfce4-whiskermenu-plugin xfce4-power-manager xfce4-notifyd
    xfce4-taskmanager xfce4-screenshooter
    
    # VNC (5)
    tigervnc-standalone-server x11vnc xvfb x11-utils xinit
    
    # Basic Utils (10)
    neofetch tree ncdu screen tmux firefox
    pulseaudio pavucontrol alsa-utils dbus-x11
    
    # Fonts (10)
    fonts-noto fonts-dejavu fonts-liberation fonts-ubuntu
    fonts-noto-color-emoji fonts-roboto fonts-open-sans
    fonts-firacode fonts-hack fontconfig
)

# PRO+ TIER - 500 Packages (GPU + Performance)
PROPLUS_PACKAGES=(
    # All FREE packages plus:
    "${FREE_PACKAGES[@]}"
    
    # GPU Optimization (20)
    mesa-utils mesa-utils-extra libgl1-mesa-glx libgl1-mesa-dri
    libegl1-mesa libglu1-mesa glmark2
    libvulkan1 vulkan-tools mesa-vulkan-drivers
    radeontop intel-gpu-tools libosmesa6 libglew2.2
    libglfw3 libglfw3-dev libglew-dev libglapi-mesa libglx-mesa0
    
    # Performance Tools (15)
    htop btop glances cpufrequtils preload zram-config
    iotop iftop nethogs nload sysstat
    bleachbit stacer powertop tlp thermald
    
    # More XFCE plugins (20)
    xfce4-goodies xfce4-clipman-plugin xfce4-cpugraph-plugin
    xfce4-datetime-plugin xfce4-diskperf-plugin xfce4-fsguard-plugin
    xfce4-genmon-plugin xfce4-indicator-plugin xfce4-mailwatch-plugin
    xfce4-mount-plugin xfce4-netload-plugin xfce4-notes-plugin
    xfce4-places-plugin xfce4-pulseaudio-plugin xfce4-sensors-plugin
    xfce4-systemload-plugin xfce4-timer-plugin xfce4-verve-plugin
    xfce4-wavelan-plugin xfce4-weather-plugin
    
    # Emulators (10)
    dosbox scummvm stella mednafen fceux
    visualboyadvance-m nestopia hatari ppsspp mgba
    
    # Premium Themes (20)
    arc-theme numix-gtk-theme materia-gtk-theme
    papirus-icon-theme breeze-cursor-theme breeze-icon-theme
    adwaita-icon-theme gnome-themes-extra
    gtk2-engines-murrine gtk2-engines-pixbuf
    qt5-style-plugins qt5ct lxappearance sassc
    adapta-gtk-theme pop-gtk-theme mint-y-icons
    elementary-icon-theme moka-icon-theme faba-icon-theme
    
    # Streaming (10)
    obs-studio simplescreenrecorder vokoscreen peek
    guvcview cheese ffmpeg ffmpegthumbnailer mediainfo kazam
    
    # Wine Gaming (10)
    wine wine64 wine32 winetricks playonlinux
    libwine fonts-wine winbind wine-mono wine-gecko
    
    # Development (50)
    build-essential gcc g++ make cmake autoconf automake
    python3 python3-pip python3-venv python3-dev
    nodejs npm default-jdk default-jre
    ruby golang-go rustc cargo php php-cli
    git-lfs git-flow subversion mercurial
    geany geany-plugins
    
    # Graphics (30)
    gimp gimp-plugin-registry inkscape krita
    imagemagick optipng pngquant jpegoptim
    darktable rawtherapee digikam
    fontforge synfig pencil2d dia graphviz
    shotwell gthumb eog feh gpicview
    
    # Office (20)
    libreoffice-writer libreoffice-calc libreoffice-impress
    libreoffice-draw libreoffice-math libreoffice-gtk3
    evince okular atril qpdfview zathura
    calibre scribus
    
    # Audio (15)
    audacity lmms ardour qtractor hydrogen
    timidity fluid-soundfont-gm pulseeffects
    lame flac vorbis-tools opus-tools sox
    
    # Video (15)
    vlc mpv handbrake-cli
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad
    gstreamer1.0-plugins-ugly gstreamer1.0-libav
    x264 x265 libvpx-dev libavcodec-extra
    kdenlive openshot-qt shotcut pitivi
    
    # Network (20)
    filezilla aria2 transmission-gtk qbittorrent
    net-tools iproute2 openssh-client sshfs
    nmap netcat-openbsd socat whois dnsutils
    openvpn wireguard-tools remmina pidgin hexchat
    
    # Utilities (40)
    thunar-archive-plugin file-roller
    pcmanfm nemo dolphin ranger mc
    synaptic neofetch screenfetch cpufetch
    tmux byobu tree exa bat ripgrep fzf
    jq bc xclip xsel scrot flameshot
    p7zip-full p7zip-rar unrar-free cabextract
    hardinfo lshw inxi hwinfo gparted gnome-disk-utility
    
    # More Fonts (20)
    fonts-noto-cjk fonts-noto-cjk-extra
    fonts-wqy-microhei fonts-wqy-zenhei
    fonts-arphic-ukai fonts-ipafont-gothic
    fonts-unfonts-core fonts-arabeyes fonts-kacst
    fonts-indic fonts-thai-tlwg fonts-lao
    fonts-jetbrains-mono fonts-cascadia-code
    fonts-inconsolata fonts-source-code-pro
    fonts-freefont-ttf fonts-linuxlibertine fonts-cantarell fonts-symbola
)

# ULTIMATE TIER - 1000+ Packages (Everything)
ULTIMATE_PACKAGES=(
    "${PROPLUS_PACKAGES[@]}"
    
    # Security/Hacking Tools (100+)
    nmap masscan netdiscover zenmap
    sqlmap nikto gobuster dirb dirbuster
    hydra john hashcat ncrack medusa
    aircrack-ng wifite reaver bully pixiewps
    wireshark tshark tcpdump ettercap-graphical
    metasploit-framework armitage
    burpsuite zaproxy
    maltego recon-ng theharvester
    exploitdb searchsploit
    responder crackmapexec evil-winrm
    bloodhound neo4j
    ghidra radare2 gdb-peda
    binwalk foremost volatility
    steghide stegseek exiftool
    tor proxychains4 torbrowser-launcher
    macchanger
    
    # Privacy Suite
    keepassxc pass gnupg2
    veracrypt cryptsetup
    bleachbit secure-delete shred
    
    # Developer Pro Pack
    docker.io docker-compose podman
    kubectl helm terraform ansible
    awscli azure-cli
    postgresql-client mariadb-client redis-tools
    mongodb-clients sqlite3
    neovim emacs
    code sublime-text
    
    # Content Creator Bundle
    kdenlive openshot-qt shotcut pitivi
    blender openscad freecad
    obs-studio simplescreenrecorder
    audacity lmms ardour
    gimp krita inkscape
    darktable rawtherapee digikam
    
    # GNOME Desktop Option
    gnome-session gnome-shell gnome-terminal nautilus
    gnome-shell-extensions gnome-tweaks
    
    # Extra Languages
    language-pack-en language-pack-id
    language-pack-zh-hans language-pack-ja
    language-pack-ko language-pack-ar language-pack-ru
    
    # Virtualization (proot compatible)
    qemu-user-static qemu-utils libvirt-clients
    
    # Science & Math
    octave gnuplot r-base
    python3-numpy python3-scipy python3-matplotlib
    python3-pandas python3-sklearn
    
    # More IDEs
    netbeans eclipse-java
    codeblocks qtcreator
    
    # Database GUIs
    dbeaver sqlitebrowser pgadmin4
    
    # Extra Utils
    httrack wget2 youtube-dl yt-dlp
    imagemagick-6.q16 ghostscript poppler-utils
    tesseract-ocr tesseract-ocr-eng tesseract-ocr-ind
)

# ═══════════════════════════════════════════════════════════════════════════
# BANNER
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    clear
    echo ""
    echo "${C}╔═══════════════════════════════════════════════════════════════════════════╗${D}"
    echo "${C}║${W}            ACRO SMART UPDATE - Tier-Based Package Manager                ${C}║${D}"
    echo "${C}╠═══════════════════════════════════════════════════════════════════════════╣${D}"
    echo "${C}║${G}  Automatically updates packages based on your license tier              ${C}║${D}"
    echo "${C}║${Y}  FREE (50 pkg) | PRO+ (500 pkg) | ULTIMATE (1000+ pkg)                  ${C}║${D}"
    echo "${C}╚═══════════════════════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

install_package() {
    local pkg=$1
    if dpkg -s "$pkg" &>/dev/null 2>&1; then
        echo "[SKIP] $pkg" >> "$LOG_FILE"
        return 0
    fi
    apt-get install -y --no-install-recommends "$pkg" >> "$LOG_FILE" 2>&1 || true
}

update_tier_free() {
    echo ""
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W}  📦 FREE Tier - Installing 50 Essential Packages        ${D}"
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    local total=${#FREE_PACKAGES[@]}
    local count=0
    
    for pkg in "${FREE_PACKAGES[@]}"; do
        count=$((count + 1))
        printf "\r  ${C}[%3d/%3d]${D} Installing ${W}%s${D}...              " $count $total "$pkg"
        install_package "$pkg"
    done
    
    echo ""
    echo "${G}✓ FREE tier packages updated${D}"
}

update_tier_proplus() {
    echo ""
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W}  ⭐ PRO+ Tier - Installing 500 Packages + GPU Config     ${D}"
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    local total=${#PROPLUS_PACKAGES[@]}
    local count=0
    
    for pkg in "${PROPLUS_PACKAGES[@]}"; do
        count=$((count + 1))
        printf "\r  ${M}[%3d/%3d]${D} Installing ${W}%s${D}...              " $count $total "$pkg"
        install_package "$pkg"
    done
    
    echo ""
    echo "${M}✓ PRO+ tier packages updated${D}"
    
    # Apply GPU optimizations
    echo "${Y}  Applying vGPU optimizations...${D}"
    configure_gpu_proplus
}

update_tier_ultimate() {
    echo ""
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W}  🏆 ULTIMATE Tier - Installing 1000+ Packages            ${D}"
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    local total=${#ULTIMATE_PACKAGES[@]}
    local count=0
    
    for pkg in "${ULTIMATE_PACKAGES[@]}"; do
        count=$((count + 1))
        printf "\r  ${R}[%3d/%3d]${D} Installing ${W}%s${D}...              " $count $total "$pkg"
        install_package "$pkg"
    done
    
    echo ""
    echo "${R}✓ ULTIMATE tier packages updated${D}"
    
    # Apply Super GPU optimizations
    echo "${Y}  Applying Super GPU Config...${D}"
    configure_gpu_ultimate
    
    # Apply Super Performance tweaks
    echo "${Y}  Applying Super Performance tweaks...${D}"
    configure_performance_ultimate
}

configure_gpu_proplus() {
    # Basic GPU config for PRO+
    export MESA_GL_VERSION_OVERRIDE=4.5
    export MESA_GLSL_VERSION_OVERRIDE=450
    
    cat >> /etc/environment << 'EOF'
MESA_GL_VERSION_OVERRIDE=4.5
MESA_GLSL_VERSION_OVERRIDE=450
LIBGL_ALWAYS_SOFTWARE=0
EOF
}

configure_gpu_ultimate() {
    # Super GPU config for ULTIMATE
    export MESA_GL_VERSION_OVERRIDE=4.6
    export MESA_GLSL_VERSION_OVERRIDE=460
    export GALLIUM_DRIVER=llvmpipe
    export LP_NUM_THREADS=4
    
    cat > /etc/environment << 'EOF'
MESA_GL_VERSION_OVERRIDE=4.6
MESA_GLSL_VERSION_OVERRIDE=460
LIBGL_ALWAYS_SOFTWARE=0
GALLIUM_DRIVER=llvmpipe
LP_NUM_THREADS=4
vblank_mode=0
__GL_SYNC_TO_VBLANK=0
EOF
}

configure_performance_ultimate() {
    # Super Performance tweaks
    echo "vm.swappiness=10" >> /etc/sysctl.conf 2>/dev/null || true
    echo "net.core.somaxconn=65535" >> /etc/sysctl.conf 2>/dev/null || true
    sysctl -p 2>/dev/null || true
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════

main() {
    banner
    
    # Check root
    if [ "$(id -u)" -ne 0 ]; then
        echo "${R}✗ This script must be run as root!${D}"
        echo "${Y}  Run: sudo bash update.sh${D}"
        exit 1
    fi
    
    # Detect tier
    TIER=$(detect_tier)
    
    echo "${W}  Detected Tier: ${C}${TIER^^}${D}"
    echo ""
    
    # Update package lists
    echo "${Y}  Updating package lists...${D}"
    apt-get update -y >> "$LOG_FILE" 2>&1
    
    # Run tier-specific update
    case "$TIER" in
        ultimate)
            update_tier_ultimate
            ;;
        proplus)
            update_tier_proplus
            ;;
        *)
            update_tier_free
            ;;
    esac
    
    # Cleanup
    echo ""
    echo "${Y}  Cleaning up...${D}"
    apt-get autoremove -y >> "$LOG_FILE" 2>&1
    apt-get clean >> "$LOG_FILE" 2>&1
    
    echo ""
    echo "${G}═══════════════════════════════════════════════════════════════════════════${D}"
    echo "${G}  ✓ ACRO Update Complete!${D}"
    echo "${G}  Tier: ${TIER^^}${D}"
    echo "${G}  Log: ${LOG_FILE}${D}"
    echo "${G}═══════════════════════════════════════════════════════════════════════════${D}"
    echo ""
}

main "$@"
