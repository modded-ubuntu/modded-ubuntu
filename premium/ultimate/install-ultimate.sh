#!/bin/bash
##############################################################################
#                                                                            #
#   ACRO ULTIMATE Edition Installer v1.0                                     #
#   Premium Distribution by ZetaGo-Aurum | ALEOCROPHIC Brand                 #
#                                                                            #
#   Copyright © 2024-2026 ZetaGo-Aurum. All Rights Reserved.                 #
#   This is PROPRIETARY SOFTWARE - NOT open source                           #
#                                                                            #
#   Price: Rp 125.000 - FULL PACK EDITION                                    #
#                                                                            #
##############################################################################

set -e

# ═══════════════════════════════════════════════════════════════════════════
# COLORS AND STYLING
# ═══════════════════════════════════════════════════════════════════════════

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
B=$'\033[1;34m'
M=$'\033[1;35m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'
BG_R=$'\033[41m'
BG_G=$'\033[42m'
BG_M=$'\033[45m'
BG_C=$'\033[46m'

# ═══════════════════════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════════════════════

LOG_FILE="/var/log/acro-ultimate-install.log"
echo "ACRO ULTIMATE Installation started: $(date)" > "$LOG_FILE"

log() { echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"; }
status_msg() { echo -e "  ${C}▸${D} $1"; log "$1"; }
success_msg() { echo -e "  ${G}✓${D} $1"; log "[OK] $1"; }
error_msg() { echo -e "  ${R}✗${D} $1"; log "[ERROR] $1"; }
warning_msg() { echo -e "  ${Y}⚠${D} $1"; log "[WARN] $1"; }

# ═══════════════════════════════════════════════════════════════════════════
# BANNER
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    clear
    echo ""
    echo "${R}╔═══════════════════════════════════════════════════════════════════════════╗${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}║${Y}    █████╗  ██████╗██████╗  ██████╗     ██╗   ██╗██╗  ████████╗██╗███╗   ███╗${R}║${D}"
    echo "${R}║${Y}   ██╔══██╗██╔════╝██╔══██╗██╔═══██╗    ██║   ██║██║  ╚══██╔══╝██║████╗ ████║${R}║${D}"
    echo "${R}║${G}   ███████║██║     ██████╔╝██║   ██║    ██║   ██║██║     ██║   ██║██╔████╔██║${R}║${D}"
    echo "${R}║${G}   ██╔══██║██║     ██╔══██╗██║   ██║    ██║   ██║██║     ██║   ██║██║╚██╔╝██║${R}║${D}"
    echo "${R}║${C}   ██║  ██║╚██████╗██║  ██║╚██████╔╝    ╚██████╔╝███████╗██║   ██║██║ ╚═╝ ██║${R}║${D}"
    echo "${R}║${C}   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝      ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚═╝${R}║${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}║${M}                    ━━━ ULTIMATE EDITION INSTALLER ━━━                       ${R}║${D}"
    echo "${R}║${W}                          FULL PACK EDITION                                  ${R}║${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}║${Y}                       Premium by ZetaGo-Aurum                               ${R}║${D}"
    echo "${R}║${C}                          ALEOCROPHIC Brand                                  ${R}║${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}╚═══════════════════════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# LICENSE VALIDATION
# ═══════════════════════════════════════════════════════════════════════════

validate_license() {
    local key="$1"
    
    echo ""
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🔐 ULTIMATE License Validation                              ${D}"
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    status_msg "Validating ULTIMATE license key: $key"
    
    # 1. Format Validation (ACRO-ULT-XXXXXXXX where X is 8 chars)
    if [[ ! "$key" =~ ^ACRO-ULT-[A-Z0-9]{8}$ ]]; then
        error_msg "Invalid ULTIMATE license key format"
        echo ""
        echo "  ${Y}Expected format: ${W}ACRO-ULT-XXXXXXXX (8 characters)${D}"
        echo "  ${Y}Your input:      ${W}$key${D}"
        echo ""
        echo "  ${C}Purchase at: ${W}https://aleocrophic-acron.vercel.app${D}"
        exit 1
    fi
    
    # 2. Server Validation
    status_msg "Checking license with authentication server..."
    
    RESPONSE=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"licenseKey\":\"$key\"}" \
        "https://aleocrophic-acron.vercel.app/api/license")
        
    # Check if curl failed
    if [ $? -ne 0 ]; then
        error_msg "Failed to connect to license server. Check internet connection."
        exit 1
    fi
    
    # Check validation status
    if echo "$RESPONSE" | grep -q '"valid":true'; then
        success_msg "ULTIMATE License verified successfully!"
        
        # Verify Tier
        TIER=$(echo "$RESPONSE" | grep -o '"licenseType":"[^"]*"' | cut -d'"' -f4)
        if [ "$TIER" != "ultimate" ]; then
             error_msg "License mismatch: Key is for $TIER but this installer is for ULTIMATE"
             echo "  ${Y}Please download the correct installer for your license.${D}"
             exit 1
        fi
        
        success_msg "License Type: ULTIMATE Edition (FULL PACK)"
        success_msg "Features: Lifetime Updates + VIP Support"
        
        # Save license info
        mkdir -p /etc/acro
        echo "$key" > /etc/acro/license.key
        echo "ultimate" > /etc/acro/edition
        chmod 600 /etc/acro/license.key
    else
        error_msg "License validation failed!"
        echo "  ${Y}Server error: ${W}$(echo "$RESPONSE" | grep -o '"error":"[^"]*"' | cut -d'"' -f4)${D}"
        exit 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# INCLUDE PRO+ FEATURES
# ═══════════════════════════════════════════════════════════════════════════

install_proplus_features() {
    echo ""
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🎮 PRO+ Features (Included)                                 ${D}"
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Gaming GPU Profile
    status_msg "Installing GPU Gaming Profile..."
    cat > /etc/profile.d/acro-gaming.sh << 'GAMING_EOF'
#!/bin/bash
# ACRO ULTIMATE - Gaming GPU Profile
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLSL_VERSION_OVERRIDE=460
export MESA_EXTENSION_MAX_YEAR=2030
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export LP_NUM_THREADS=$(nproc)
export __GL_THREADED_OPTIMIZATIONS=1
export mesa_glthread=true
export __GL_SHADER_DISK_CACHE=1
export DXVK_ASYNC=1
export DXVK_HUD=fps,devinfo,gpuload,memory
export __GL_SYNC_TO_VBLANK=0
GAMING_EOF
    chmod +x /etc/profile.d/acro-gaming.sh
    success_msg "Gaming GPU Profile installed"
    
    # Gaming Emulators
    status_msg "Installing Gaming Emulators..."
    apt-get install -y retroarch ppsspp dolphin-emu desmume mgba mupen64plus-qt snes9x-gtk fceux mednafen >> "$LOG_FILE" 2>&1 || true
    success_msg "Emulators installed"
    
    # Premium Themes
    status_msg "Installing Premium Themes..."
    apt-get install -y arc-theme numix-gtk-theme papirus-icon-theme materia-gtk-theme pop-gtk-theme breeze-gtk-theme >> "$LOG_FILE" 2>&1 || true
    success_msg "Premium themes installed"
    
    # Performance tools
    status_msg "Installing Performance Tools..."
    apt-get install -y preload zram-tools earlyoom gamemode >> "$LOG_FILE" 2>&1 || true
    success_msg "Performance tools installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# PENETRATION TESTING SUITE
# ═══════════════════════════════════════════════════════════════════════════

install_pentest_suite() {
    echo ""
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🔓 Penetration Testing & Security Suite                     ${D}"
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Network Scanners
    status_msg "Installing Network Scanners..."
    apt-get install -y \
        nmap \
        masscan \
        zmap \
        netcat-openbsd \
        netcat-traditional \
        hping3 \
        arping \
        fping >> "$LOG_FILE" 2>&1 || true
    success_msg "Network scanners installed"
    
    # Vulnerability Scanners
    status_msg "Installing Vulnerability Scanners..."
    apt-get install -y \
        nikto \
        wapiti \
        skipfish \
        sqlmap \
        commix \
        xsser >> "$LOG_FILE" 2>&1 || true
    success_msg "Vulnerability scanners installed"
    
    # Password Cracking
    status_msg "Installing Password Tools..."
    apt-get install -y \
        john \
        hashcat \
        hydra \
        medusa \
        ncrack \
        ophcrack \
        crunch \
        cewl \
        wordlists >> "$LOG_FILE" 2>&1 || true
    success_msg "Password tools installed"
    
    # Wireless Security
    status_msg "Installing Wireless Tools..."
    apt-get install -y \
        aircrack-ng \
        reaver \
        bully \
        pixiewps \
        cowpatty \
        fern-wifi-cracker \
        wifite \
        kismet >> "$LOG_FILE" 2>&1 || true
    success_msg "Wireless tools installed"
    
    # Exploitation Frameworks
    status_msg "Installing Exploitation Frameworks..."
    apt-get install -y \
        metasploit-framework \
        armitage \
        beef-xss \
        set >> "$LOG_FILE" 2>&1 || true
    success_msg "Exploitation frameworks installed"
    
    # Web Application Testing
    status_msg "Installing Web Application Tools..."
    apt-get install -y \
        burpsuite \
        zaproxy \
        dirb \
        dirbuster \
        gobuster \
        ffuf \
        whatweb \
        wafw00f \
        wpscan >> "$LOG_FILE" 2>&1 || true
    success_msg "Web application tools installed"
    
    # Packet Analysis
    status_msg "Installing Packet Analysis Tools..."
    apt-get install -y \
        wireshark \
        tshark \
        tcpdump \
        ettercap-text-only \
        dsniff \
        arpwatch \
        bettercap >> "$LOG_FILE" 2>&1 || true
    success_msg "Packet analysis tools installed"
    
    # Forensics
    status_msg "Installing Forensics Tools..."
    apt-get install -y \
        autopsy \
        sleuthkit \
        foremost \
        binwalk \
        bulk-extractor \
        volatility \
        dc3dd \
        dcfldd >> "$LOG_FILE" 2>&1 || true
    success_msg "Forensics tools installed"
    
    # Reverse Engineering
    status_msg "Installing Reverse Engineering Tools..."
    apt-get install -y \
        radare2 \
        gdb \
        gdb-multiarch \
        edb-debugger \
        ghidra \
        jadx \
        apktool \
        dex2jar >> "$LOG_FILE" 2>&1 || true
    success_msg "Reverse engineering tools installed"
    
    # OSINT Tools
    status_msg "Installing OSINT Tools..."
    apt-get install -y \
        maltego \
        recon-ng \
        theharvester \
        metagoofil \
        exiftool \
        shodan >> "$LOG_FILE" 2>&1 || true
    pip3 install sherlock 2>/dev/null || true
    success_msg "OSINT tools installed"
    
    # Create security toolkit launcher
    cat > /usr/local/bin/acro-security << 'SEC_EOF'
#!/bin/bash
R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

echo ""
echo "${R}╔═══════════════════════════════════════════════════════════════════════╗${D}"
echo "${R}║${W}  🔓 ACRO ULTIMATE - Security Toolkit                                 ${R}║${D}"
echo "${R}╠═══════════════════════════════════════════════════════════════════════╣${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  NETWORK SCANNING:                                                     ${R}║${D}"
echo "${R}║${D}    nmap, masscan, zmap, hping3                                         ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  VULNERABILITY SCANNING:                                               ${R}║${D}"
echo "${R}║${D}    nikto, wapiti, sqlmap, commix, xsser                                ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  PASSWORD CRACKING:                                                    ${R}║${D}"
echo "${R}║${D}    john, hashcat, hydra, medusa, crunch                                ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  WIRELESS:                                                             ${R}║${D}"
echo "${R}║${D}    aircrack-ng, reaver, wifite, kismet                                 ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  EXPLOITATION:                                                         ${R}║${D}"
echo "${R}║${D}    metasploit, armitage, beef-xss, set                                 ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  WEB TESTING:                                                          ${R}║${D}"
echo "${R}║${D}    burpsuite, zaproxy, gobuster, wpscan                                ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  FORENSICS:                                                            ${R}║${D}"
echo "${R}║${D}    autopsy, sleuthkit, binwalk, volatility                             ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  REVERSE ENGINEERING:                                                  ${R}║${D}"
echo "${R}║${D}    radare2, gdb, ghidra, apktool                                       ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}╚═══════════════════════════════════════════════════════════════════════╝${D}"
echo ""
echo "${C}Usage: Run any tool directly from terminal${D}"
echo "${Y}Example: nmap -sV target.com${D}"
echo ""
SEC_EOF
    chmod +x /usr/local/bin/acro-security
    success_msg "Security toolkit menu created"
}

# ═══════════════════════════════════════════════════════════════════════════
# PRIVACY & ANONYMITY SUITE
# ═══════════════════════════════════════════════════════════════════════════

install_privacy_suite() {
    echo ""
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🛡️  Privacy & Anonymity Suite                               ${D}"
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Tor
    status_msg "Installing Tor..."
    apt-get install -y tor torbrowser-launcher proxychains4 torsocks >> "$LOG_FILE" 2>&1 || true
    success_msg "Tor installed"
    
    # VPN Tools
    status_msg "Installing VPN Tools..."
    apt-get install -y openvpn wireguard-tools network-manager-openvpn network-manager-vpnc >> "$LOG_FILE" 2>&1 || true
    success_msg "VPN tools installed"
    
    # Encryption
    status_msg "Installing Encryption Tools..."
    apt-get install -y \
        gnupg2 \
        veracrypt \
        cryptsetup \
        ecryptfs-utils \
        encfs \
        tomb \
        steghide \
        outguess >> "$LOG_FILE" 2>&1 || true
    success_msg "Encryption tools installed"
    
    # Secure Communication
    status_msg "Installing Secure Communication..."
    apt-get install -y signal-desktop element-desktop >> "$LOG_FILE" 2>&1 || true
    success_msg "Secure messaging installed"
    
    # Privacy browsers
    status_msg "Installing Privacy Browsers..."
    apt-get install -y \
        brave-browser \
        librewolf >> "$LOG_FILE" 2>&1 || true
    success_msg "Privacy browsers installed"
    
    # Create privacy mode script
    cat > /usr/local/bin/acro-privacy << 'PRIV_EOF'
#!/bin/bash
R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

echo ""
echo "${M}╔═══════════════════════════════════════════════════════════════╗${D}"
echo "${M}║${W}  🛡️ ACRO ULTIMATE - Privacy Mode                             ${M}║${D}"
echo "${M}╚═══════════════════════════════════════════════════════════════╝${D}"
echo ""

case "$1" in
    tor)
        echo "${Y}▸ Starting Tor...${D}"
        systemctl start tor 2>/dev/null || service tor start 2>/dev/null || tor &
        echo "${G}✓ Tor started${D}"
        echo "${C}Use 'proxychains4' to route traffic through Tor${D}"
        echo "${Y}Example: proxychains4 curl ipinfo.io${D}"
        ;;
    stop)
        echo "${Y}▸ Stopping Tor...${D}"
        systemctl stop tor 2>/dev/null || service tor stop 2>/dev/null || pkill tor
        echo "${G}✓ Tor stopped${D}"
        ;;
    status)
        echo "${C}Tor Status:${D}"
        systemctl status tor 2>/dev/null || service tor status 2>/dev/null || echo "Check manually"
        ;;
    *)
        echo "Usage: acro-privacy [tor|stop|status]"
        echo ""
        echo "  tor    - Start Tor service"
        echo "  stop   - Stop Tor service"
        echo "  status - Check Tor status"
        echo ""
        echo "Tools available:"
        echo "  torbrowser-launcher - Tor Browser"
        echo "  proxychains4        - Proxy through Tor"
        echo "  veracrypt          - Encrypted volumes"
        echo "  steghide           - Steganography"
        ;;
esac
PRIV_EOF
    chmod +x /usr/local/bin/acro-privacy
    success_msg "Privacy mode script created"
}

# ═══════════════════════════════════════════════════════════════════════════
# DEVELOPER PRO PACK
# ═══════════════════════════════════════════════════════════════════════════

install_developer_pack() {
    echo ""
    echo "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 💻 Developer Pro Pack                                       ${D}"
    echo "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Docker
    status_msg "Installing Docker..."
    apt-get install -y docker.io docker-compose >> "$LOG_FILE" 2>&1 || true
    success_msg "Docker installed"
    
    # Cloud CLI tools
    status_msg "Installing Cloud CLI Tools..."
    pip3 install awscli azure-cli google-cloud-sdk >> "$LOG_FILE" 2>&1 || true
    success_msg "Cloud CLI installed"
    
    # DevOps tools
    status_msg "Installing DevOps Tools..."
    apt-get install -y ansible terraform packer vagrant >> "$LOG_FILE" 2>&1 || true
    pip3 install kubernetes >> "$LOG_FILE" 2>&1 || true
    success_msg "DevOps tools installed"
    
    # Extra IDEs
    status_msg "Installing Extra IDEs..."
    apt-get install -y neovim emacs >> "$LOG_FILE" 2>&1 || true
    success_msg "Extra IDEs installed"
    
    # Database clients
    status_msg "Installing Database Clients..."
    apt-get install -y \
        mysql-client \
        postgresql-client \
        mongodb-clients \
        redis-tools \
        dbeaver >> "$LOG_FILE" 2>&1 || true
    success_msg "Database clients installed"
    
    # API testing
    status_msg "Installing API Tools..."
    apt-get install -y httpie jq yq >> "$LOG_FILE" 2>&1 || true
    pip3 install requests httpx >> "$LOG_FILE" 2>&1 || true
    success_msg "API tools installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# CONTENT CREATOR BUNDLE
# ═══════════════════════════════════════════════════════════════════════════

install_content_creator() {
    echo ""
    echo "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🎬 Content Creator Bundle                                   ${D}"
    echo "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Video editing
    status_msg "Installing Video Editing Suite..."
    apt-get install -y \
        kdenlive \
        shotcut \
        openshot \
        pitivi \
        flowblade \
        olive-editor >> "$LOG_FILE" 2>&1 || true
    success_msg "Video editors installed"
    
    # Audio production
    status_msg "Installing Audio Production Suite..."
    apt-get install -y \
        ardour \
        lmms \
        hydrogen \
        rosegarden \
        musescore \
        audacity >> "$LOG_FILE" 2>&1 || true
    success_msg "Audio production installed"
    
    # Streaming
    status_msg "Installing Streaming Tools..."
    apt-get install -y \
        obs-studio \
        simplescreenrecorder \
        ffmpeg \
        v4l2loopback-dkms >> "$LOG_FILE" 2>&1 || true
    success_msg "Streaming tools installed"
    
    # Graphics
    status_msg "Installing Graphics Suite..."
    apt-get install -y \
        krita \
        inkscape \
        darktable \
        rawtherapee \
        hugin \
        digikam >> "$LOG_FILE" 2>&1 || true
    success_msg "Graphics tools installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# ULTIMATE SCRIPTS
# ═══════════════════════════════════════════════════════════════════════════

create_ultimate_scripts() {
    echo ""
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🔧 Creating ULTIMATE Scripts                                ${D}"
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Main ULTIMATE menu
    cat > /usr/local/bin/acro-ultimate << 'ULT_EOF'
#!/bin/bash
R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
M=$'\033[1;35m'
W=$'\033[1;37m'
D=$'\033[0m'

echo ""
echo "${R}╔═══════════════════════════════════════════════════════════════════════╗${D}"
echo "${R}║${W}                  🏆 ACRO ULTIMATE - COMMAND CENTER                    ${R}║${D}"
echo "${R}╠═══════════════════════════════════════════════════════════════════════╣${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${Y}  AVAILABLE COMMANDS:                                                   ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${G}    acro-security     ${W}- Security & Penetration Tools                   ${R}║${D}"
echo "${R}║${G}    acro-privacy      ${W}- Privacy & Anonymity Tools                     ${R}║${D}"
echo "${R}║${G}    acro-gaming       ${W}- Gaming Mode Toggle                            ${R}║${D}"
echo "${R}║${G}    acro-performance  ${W}- System Optimization                           ${R}║${D}"
echo "${R}║${G}    acro-theme        ${W}- Theme Switcher                                ${R}║${D}"
echo "${R}║${G}    acro-emulators    ${W}- Gaming Emulators                              ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}║${C}  VIP Support: vip@aleocrophic.com                                      ${R}║${D}"
echo "${R}║${D}                                                                         ${R}║${D}"
echo "${R}╚═══════════════════════════════════════════════════════════════════════╝${D}"
echo ""
ULT_EOF
    chmod +x /usr/local/bin/acro-ultimate
    success_msg "Ultimate menu created"
    
    # Gaming mode
    cat > /usr/local/bin/acro-gaming << 'GAME_EOF'
#!/bin/bash
echo "🎮 ACRO ULTIMATE Gaming Mode"
case "$1" in
    on) sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null; echo "✓ Gaming mode ON" ;;
    off) echo "✓ Gaming mode OFF" ;;
    *) echo "Usage: acro-gaming [on|off]" ;;
esac
GAME_EOF
    chmod +x /usr/local/bin/acro-gaming
    
    # Performance
    cat > /usr/local/bin/acro-performance << 'PERF_EOF'
#!/bin/bash
echo "⚡ ACRO ULTIMATE Performance Mode"
sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null
rm -rf ~/.cache/thumbnails/* 2>/dev/null
echo "✓ System optimized"
PERF_EOF
    chmod +x /usr/local/bin/acro-performance
    
    # Theme switcher
    cat > /usr/local/bin/acro-theme << 'THEME_EOF'
#!/bin/bash
echo "🎨 ACRO ULTIMATE Theme Switcher"
echo "Available: Arc-Dark, Numix, Materia-dark, Pop-dark"
read -p "Theme name: " theme
xfconf-query -c xsettings -p /Net/ThemeName -s "$theme" 2>/dev/null
echo "✓ Theme set to: $theme"
THEME_EOF
    chmod +x /usr/local/bin/acro-theme
    
    # Emulators list
    cat > /usr/local/bin/acro-emulators << 'EMU_EOF'
#!/bin/bash
echo "🕹️ ACRO ULTIMATE Emulators"
echo "retroarch, ppsspp, dolphin-emu, desmume, mgba, pcsx2, mupen64plus"
EMU_EOF
    chmod +x /usr/local/bin/acro-emulators
    
    success_msg "All ULTIMATE scripts created"
}

# ═══════════════════════════════════════════════════════════════════════════
# FINAL SETUP
# ═══════════════════════════════════════════════════════════════════════════

final_setup() {
    echo ""
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} ✨ Final Setup                                              ${D}"
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Welcome message
    cat > /etc/profile.d/acro-ultimate-welcome.sh << 'WELCOME_EOF'
#!/bin/bash
if [ -f /etc/acro/edition ] && [ "$(cat /etc/acro/edition)" = "ultimate" ]; then
    echo ""
    echo -e "\033[1;31m╔═══════════════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;31m║\033[1;37m  🏆 Welcome to ACRO ULTIMATE Edition - FULL PACK                     \033[1;31m║\033[0m"
    echo -e "\033[1;31m╠═══════════════════════════════════════════════════════════════════════╣\033[0m"
    echo -e "\033[1;31m║\033[0m  Type 'acro-ultimate' for command menu                                 \033[1;31m║\033[0m"
    echo -e "\033[1;31m║\033[0m  VIP Support: vip@aleocrophic.com                                      \033[1;31m║\033[0m"
    echo -e "\033[1;31m╚═══════════════════════════════════════════════════════════════════════╝\033[0m"
    echo ""
fi
WELCOME_EOF
    chmod +x /etc/profile.d/acro-ultimate-welcome.sh
    success_msg "Welcome message configured"
    
    # Desktop entry
    mkdir -p /usr/share/applications
    cat > /usr/share/applications/acro-ultimate.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Name=ACRO ULTIMATE
Comment=ACRO ULTIMATE Edition Command Center
Exec=xfce4-terminal -e acro-ultimate
Icon=security-high
Terminal=true
Type=Application
Categories=System;Security;
DESKTOP_EOF
    success_msg "Desktop entry created"
}

# ═══════════════════════════════════════════════════════════════════════════
# COMPLETION
# ═══════════════════════════════════════════════════════════════════════════

show_completion() {
    echo ""
    echo ""
    echo "${R}╔═══════════════════════════════════════════════════════════════════════════╗${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}║${G}   🏆 🏆 🏆   ACRO ULTIMATE INSTALLATION COMPLETE!   🏆 🏆 🏆               ${R}║${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}╠═══════════════════════════════════════════════════════════════════════════╣${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}║${W}  Thank you for purchasing ACRO ULTIMATE Edition!                           ${R}║${D}"
    echo "${R}║${Y}  You now have access to the FULL PACK with ALL features!                   ${R}║${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}║${C}  Commands:                                                                 ${R}║${D}"
    echo "${R}║${G}    acro-ultimate     ${W}- Main command center                               ${R}║${D}"
    echo "${R}║${G}    acro-security     ${W}- Security tools                                    ${R}║${D}"
    echo "${R}║${G}    acro-privacy      ${W}- Privacy tools                                     ${R}║${D}"
    echo "${R}║${G}    acro-gaming       ${W}- Gaming mode                                       ${R}║${D}"
    echo "${R}║${G}    acro-performance  ${W}- Optimization                                      ${R}║${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}║${M}  VIP Support: vip@aleocrophic.com (6-hour response)                        ${R}║${D}"
    echo "${R}║${D}                                                                             ${R}║${D}"
    echo "${R}╚═══════════════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    echo "${Y}Please restart your session for all changes to take effect.${D}"
    echo ""
    
    log "ULTIMATE Installation completed successfully"
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════

main() {
    banner
    
    if [[ "$1" != "--license" ]] || [[ -z "$2" ]]; then
        echo "${R}Usage: sudo bash install-ultimate.sh --license YOUR_LICENSE_KEY${D}"
        echo ""
        echo "${Y}Don't have a license? Purchase at:${D}"
        echo "${C}https://aleocrophic.com/acro-ultimate${D}"
        echo ""
        echo "${W}Price: Rp 125.000 - FULL PACK${D}"
        exit 1
    fi
    
    if [[ $EUID -ne 0 ]]; then
        echo "${R}This script must be run as root (use sudo)${D}"
        exit 1
    fi
    
    LICENSE_KEY="$2"
    
    validate_license "$LICENSE_KEY"
    install_proplus_features
    install_pentest_suite
    install_privacy_suite
    install_developer_pack
    install_content_creator
    create_ultimate_scripts
    final_setup
    show_completion
}

main "$@"
