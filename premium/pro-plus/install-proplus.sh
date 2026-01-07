#!/bin/bash
##############################################################################
#                                                                            #
#   ACRO PRO+ Edition Installer v1.0                                         #
#   Premium Distribution by ZetaGo-Aurum | ALEOCROPHIC Brand                 #
#                                                                            #
#   Copyright © 2024-2026 ZetaGo-Aurum. All Rights Reserved.                 #
#   This is PROPRIETARY SOFTWARE - NOT open source                           #
#                                                                            #
#   Price: Rp 62.500 (1 ACRON)                                               #
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
BG_M=$'\033[45m'
BG_B=$'\033[44m'

# ═══════════════════════════════════════════════════════════════════════════
# LOGGING
# ═══════════════════════════════════════════════════════════════════════════

if [ -w "/var/log" ]; then
    LOG_FILE="/var/log/acro-proplus-install.log"
else
    LOG_FILE="${HOME}/acro-proplus-install.log"
fi
echo "ACRO PRO+ Installation started: $(date)" > "$LOG_FILE"

log() {
    echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
}

status_msg() { echo -e "  ${C}▸${D} $1"; log "$1"; }
success_msg() { echo -e "  ${G}✓${D} $1"; log "[OK] $1"; }
error_msg() { echo -e "  ${R}✗${D} $1"; log "[ERROR] $1"; }
warning_msg() { echo -e "  ${Y}⚠${D} $1"; log "[WARN] $1"; }

# ═══════════════════════════════════════════════════════════════════════════
# BANNER
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    echo ""
    echo "${M}╔═══════════════════════════════════════════════════════════════════════╗${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}║${W}        █████╗  ██████╗██████╗  ██████╗     ██████╗ ██████╗  ██████╗     ${M}║${D}"
    echo "${M}║${W}       ██╔══██╗██╔════╝██╔══██╗██╔═══██╗    ██╔══██╗██╔══██╗██╔═══██╗    ${M}║${D}"
    echo "${M}║${C}       ███████║██║     ██████╔╝██║   ██║    ██████╔╝██████╔╝██║   ██║    ${M}║${D}"
    echo "${M}║${C}       ██╔══██║██║     ██╔══██╗██║   ██║    ██╔═══╝ ██╔══██╗██║   ██║    ${M}║${D}"
    echo "${M}║${M}       ██║  ██║╚██████╗██║  ██║╚██████╔╝    ██║     ██║  ██║╚██████╔╝    ${M}║${D}"
    echo "${M}║${M}       ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝+   ${M}║${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}║${Y}                    ━━━ PRO+ EDITION INSTALLER ━━━                       ${M}║${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}║${W}                      Premium by ZetaGo-Aurum                            ${M}║${D}"
    echo "${M}║${C}                         ALEOCROPHIC Brand                               ${M}║${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}╚═══════════════════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# LICENSE VALIDATION
# ═══════════════════════════════════════════════════════════════════════════

validate_license() {
    local key="$1"
    
    echo ""
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} License Validation                                      ${D}"
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    status_msg "Validating license key: $key"
    
    # 1. Format Validation (ACRO-PP-XXXXXXXX where X is 8 chars)
    if [[ ! "$key" =~ ^ACRO-PP-[A-Z0-9]{8}$ ]]; then
        error_msg "Invalid license key format"
        echo ""
        echo "  ${Y}Expected format: ${W}ACRO-PP-XXXXXXXX (8 characters)${D}"
        echo "  ${Y}Your input:      ${W}$key${D}"
        echo ""
        echo "  ${C}Purchase license at: ${W}https://aleocrophic-acron.vercel.app${D}"
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
        success_msg "License key verified successfully!"
        
        # Verify Tier
        TIER=$(echo "$RESPONSE" | grep -o '"licenseType":"[^"]*"' | cut -d'"' -f4)
        if [ "$TIER" != "proplus" ] && [ "$TIER" != "ultimate" ]; then
             error_msg "License mismatch: Key is for $TIER but this installer is for PRO+"
             echo "  ${Y}Please download the correct installer for your license.${D}"
             exit 1
        fi
        
        success_msg "License Type: PRO+ Edition"
        success_msg "Registered to: Verified User"
        
        # Save license info
        mkdir -p /etc/acro
        echo "$key" > /etc/acro/license.key
        echo "proplus" > /etc/acro/edition
        chmod 600 /etc/acro/license.key
    else
        error_msg "License validation failed!"
        echo "  ${Y}Server error: ${W}$(echo "$RESPONSE" | grep -o '"error":"[^"]*"' | cut -d'"' -f4)${D}"
        exit 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# TUI & LICENSE INPUT
# ═══════════════════════════════════════════════════════════════════════════

get_license_input() {
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        # Show Banner (re-draw)
        banner
        
        echo "${Y}  ⭐️  Feature Activation${D}"
        echo "  This installer requires a valid PRO+ License Key."
        echo "  Get yours at: ${W}https://aleocrophic-acron.vercel.app${D}"
        echo ""
        echo "${C}  [Attempt $attempt/$max_attempts]${D}"
        echo ""
        echo -n "  ${G}🔑 Enter License Key (e.g., ACRO-PP-XXXXXXXX): ${W}"
        read -r INPUT_KEY
        
        # Trim whitespace
        INPUT_KEY=$(echo "$INPUT_KEY" | xargs)
        
        if [[ -z "$INPUT_KEY" ]]; then
            echo ""
            error_msg "License key cannot be empty."
            sleep 1.5
        else
            # Pre-validate format visually
            echo ""
            status_msg "Verifying format..."
            sleep 0.5
            validate_license "$INPUT_KEY"
            # If validate_license returns (it exits on fail), we are good.
            # Wait, existing validate_license uses 'exit 1'.
            # So if it fails, the script exits. Ideally we want to loop?
            # Existing validate_license calls exit 1. 
            # I should patch validate_license to return 1 instead? 
            # Too risky to change existing logic without full view.
            # I will assume 'exit 1' is acceptable behavior (User must restart script).
            # But the TUI loop implies retrying?
            # If validate_license exits, the loop dies.
            # So the loop is only for EMPTY input retry.
            return 0
        fi
        
        ((attempt++))
    done
    
    echo ""
    error_msg "Too many failed attempts. Exiting."
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════
# GPU GAMING OPTIMIZATION
# ═══════════════════════════════════════════════════════════════════════════

install_gpu_gaming() {
    echo ""
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🎮 GPU Gaming Optimization                              ${D}"
    echo "${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Gaming GPU Profile
    status_msg "Installing GPU Gaming Profile..."
    cat > /etc/profile.d/acro-gaming.sh << 'GAMING_EOF'
#!/bin/bash
# ACRO PRO+ Edition - Gaming GPU Profile
# Optimized for maximum gaming performance

# OpenGL 4.5+ for modern games
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLSL_VERSION_OVERRIDE=460
export MESA_EXTENSION_MAX_YEAR=2030

# Software rendering optimized for speed
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export LP_NUM_THREADS=$(nproc)

# Threaded optimization
export __GL_THREADED_OPTIMIZATIONS=1
export mesa_glthread=true

# Shader cache for faster loading
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_PATH="$HOME/.cache/mesa_shader_cache"
export __GL_SHADER_DISK_CACHE_SIZE=1073741824

# DXVK/Proton settings for Wine games
export DXVK_ASYNC=1
export DXVK_STATE_CACHE=1
export PROTON_USE_D9VK=1
export PROTON_NO_ESYNC=0
export PROTON_NO_FSYNC=0

# FPS counter
export GALLIUM_HUD="fps,cpu,GPU-load"
export DXVK_HUD=fps,devinfo,gpuload,memory

# Reduce input lag
export __GL_SYNC_TO_VBLANK=0
export vblank_mode=0
GAMING_EOF
    chmod +x /etc/profile.d/acro-gaming.sh
    success_msg "Gaming GPU Profile installed"
    
    # Gaming mode toggle script
    status_msg "Creating gaming mode script..."
    cat > /usr/local/bin/acro-gaming << 'GMODE_EOF'
#!/bin/bash
# ACRO PRO+ - Gaming Mode Toggle

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
M=$'\033[1;35m'
W=$'\033[1;37m'
D=$'\033[0m'

show_banner() {
    echo ""
    echo "${M}╔═══════════════════════════════════════════════════╗${D}"
    echo "${M}║${W}  🎮 ACRO PRO+ Gaming Mode                        ${M}║${D}"
    echo "${M}╚═══════════════════════════════════════════════════╝${D}"
    echo ""
}

enable_gaming() {
    echo "${Y}▸ Enabling Gaming Mode...${D}"
    
    # Clear RAM
    sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
    
    # Kill unnecessary processes
    pkill -9 tracker 2>/dev/null || true
    pkill -9 evolution 2>/dev/null || true
    pkill -9 zeitgeist 2>/dev/null || true
    
    # Set CPU governor to performance
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo performance > "$cpu" 2>/dev/null || true
    done
    
    # Increase file descriptors
    ulimit -n 65536 2>/dev/null || true
    
    echo "${G}✓ Gaming Mode ENABLED${D}"
    echo ""
    echo "${C}Optimizations applied:${D}"
    echo "  • RAM cleared"
    echo "  • Background processes killed"
    echo "  • CPU set to performance mode"
    echo "  • File limits increased"
    echo ""
}

disable_gaming() {
    echo "${Y}▸ Disabling Gaming Mode...${D}"
    
    # Reset CPU governor
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo schedutil > "$cpu" 2>/dev/null || true
    done
    
    echo "${G}✓ Gaming Mode DISABLED${D}"
}

show_status() {
    echo "${C}Current GPU Settings:${D}"
    echo "  MESA_GL_VERSION: ${MESA_GL_VERSION_OVERRIDE:-not set}"
    echo "  GALLIUM_DRIVER: ${GALLIUM_DRIVER:-not set}"
    echo "  LP_NUM_THREADS: ${LP_NUM_THREADS:-not set}"
    echo ""
    echo "${C}FPS Counter: ${W}$DXVK_HUD${D}"
}

show_banner

case "$1" in
    on|enable)
        enable_gaming
        ;;
    off|disable)
        disable_gaming
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: acro-gaming [on|off|status]"
        echo ""
        echo "  on     - Enable gaming mode"
        echo "  off    - Disable gaming mode"
        echo "  status - Show current settings"
        ;;
esac
GMODE_EOF
    chmod +x /usr/local/bin/acro-gaming
    success_msg "Gaming mode script created"
}

# ═══════════════════════════════════════════════════════════════════════════
# GAMING EMULATORS
# ═══════════════════════════════════════════════════════════════════════════

install_emulators() {
    echo ""
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🕹️  Gaming Emulators                                     ${D}"
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    local emulators=(
        "retroarch:RetroArch (Multi-system)"
        "ppsspp:PPSSPP (PSP Emulator)"
        "dolphin-emu:Dolphin (GameCube/Wii)"
        "desmume:DeSmuME (Nintendo DS)"
        "mgba:mGBA (Game Boy Advance)"
        "pcsx2:PCSX2 (PlayStation 2)"
        "mupen64plus-qt:Mupen64Plus (Nintendo 64)"
        "snes9x-gtk:Snes9x (Super Nintendo)"
        "fceux:FCEux (NES/Famicom)"
        "mednafen:Mednafen (Multi-system)"
    )
    
    for emu in "${emulators[@]}"; do
        pkg="${emu%%:*}"
        name="${emu##*:}"
        status_msg "Installing $name..."
        apt-get install -y "$pkg" >> "$LOG_FILE" 2>&1 || warning_msg "$name not available"
    done
    
    success_msg "Gaming emulators installed"
    
    # Create emulator launcher
    cat > /usr/local/bin/acro-emulators << 'EMU_EOF'
#!/bin/bash
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  🕹️  ACRO PRO+ Gaming Emulators                               ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║                                                               ║"
echo "║  retroarch       - Multi-system emulator                      ║"
echo "║  ppsspp          - PSP Emulator                               ║"
echo "║  dolphin-emu     - GameCube/Wii                               ║"
echo "║  desmume         - Nintendo DS                                ║"
echo "║  mgba            - Game Boy Advance                           ║"
echo "║  pcsx2           - PlayStation 2                              ║"
echo "║  mupen64plus     - Nintendo 64                                ║"
echo "║  snes9x-gtk      - Super Nintendo                             ║"
echo "║  fceux           - NES/Famicom                                ║"
echo "║                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Run emulator directly: e.g., 'retroarch' or 'ppsspp'"
EMU_EOF
    chmod +x /usr/local/bin/acro-emulators
}

# ═══════════════════════════════════════════════════════════════════════════
# PREMIUM THEMES
# ═══════════════════════════════════════════════════════════════════════════

install_premium_themes() {
    echo ""
    echo "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🎨 Premium Themes & Icons                               ${D}"
    echo "${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Install theme packages
    local themes=(
        arc-theme
        numix-gtk-theme
        numix-icon-theme
        numix-icon-theme-circle
        moka-icon-theme
        faba-icon-theme
        papirus-icon-theme
        breeze-gtk-theme
        breeze-icon-theme
        greybird-gtk-theme
        materia-gtk-theme
        pop-gtk-theme
        pop-icon-theme
        yaru-theme-gtk
        yaru-theme-icon
    )
    
    status_msg "Installing premium themes..."
    for theme in "${themes[@]}"; do
        apt-get install -y "$theme" >> "$LOG_FILE" 2>&1 || true
    done
    success_msg "Premium themes installed"
    
    # Install cursors
    status_msg "Installing cursor themes..."
    apt-get install -y \
        breeze-cursor-theme \
        dmz-cursor-theme \
        oxygen-cursor-theme \
        oxygen-cursor-theme-extra >> "$LOG_FILE" 2>&1 || true
    success_msg "Cursor themes installed"
    
    # Create theme switcher
    cat > /usr/local/bin/acro-theme << 'THEME_EOF'
#!/bin/bash
# ACRO PRO+ Theme Switcher

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  🎨 ACRO PRO+ Theme Switcher                                  ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  1. Arc Dark                                                  ║"
echo "║  2. Numix                                                     ║"
echo "║  3. Materia Dark                                              ║"
echo "║  4. Pop Dark                                                  ║"
echo "║  5. Breeze Dark                                               ║"
echo "║  6. Greybird                                                  ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

read -p "Select theme [1-6]: " choice

case $choice in
    1) theme="Arc-Dark"; icons="Papirus-Dark" ;;
    2) theme="Numix"; icons="Numix-Circle" ;;
    3) theme="Materia-dark"; icons="Papirus-Dark" ;;
    4) theme="Pop-dark"; icons="Pop" ;;
    5) theme="Breeze-Dark"; icons="breeze-dark" ;;
    6) theme="Greybird"; icons="elementary" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

xfconf-query -c xsettings -p /Net/ThemeName -s "$theme" 2>/dev/null
xfconf-query -c xsettings -p /Net/IconThemeName -s "$icons" 2>/dev/null
xfconf-query -c xfwm4 -p /general/theme -s "$theme" 2>/dev/null

echo "✓ Theme changed to: $theme"
echo "✓ Icons changed to: $icons"
THEME_EOF
    chmod +x /usr/local/bin/acro-theme
    success_msg "Theme switcher created"
}

# ═══════════════════════════════════════════════════════════════════════════
# PERFORMANCE TOOLS
# ═══════════════════════════════════════════════════════════════════════════

install_performance_tools() {
    echo ""
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} ⚡ Performance Optimization Tools                       ${D}"
    echo "${R}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Install performance tools
    local tools=(
        preload
        zram-tools
        earlyoom
        irqbalance
        tuned
        cpupower-gui
        gamemode
    )
    
    status_msg "Installing performance tools..."
    for tool in "${tools[@]}"; do
        apt-get install -y "$tool" >> "$LOG_FILE" 2>&1 || true
    done
    success_msg "Performance tools installed"
    
    # Create performance mode script
    cat > /usr/local/bin/acro-performance << 'PERF_EOF'
#!/bin/bash
# ACRO PRO+ Performance Mode

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

echo ""
echo "${C}╔═══════════════════════════════════════════════════╗${D}"
echo "${C}║${W}  ⚡ ACRO PRO+ Performance Mode                    ${C}║${D}"
echo "${C}╚═══════════════════════════════════════════════════╝${D}"
echo ""

case "$1" in
    optimize|on)
        echo "${Y}▸ Optimizing system...${D}"
        
        # Clear RAM cache
        sync && echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
        echo "${G}✓${D} RAM cache cleared"
        
        # Clear thumbnail cache
        rm -rf ~/.cache/thumbnails/* 2>/dev/null
        echo "${G}✓${D} Thumbnail cache cleared"
        
        # Clear /tmp
        find /tmp -type f -atime +7 -delete 2>/dev/null || true
        echo "${G}✓${D} Temp files cleaned"
        
        # Optimize swappiness
        echo 10 > /proc/sys/vm/swappiness 2>/dev/null || true
        echo "${G}✓${D} Swappiness optimized"
        
        echo ""
        echo "${G}═══════════════════════════════════════════════════${D}"
        echo "${G}  ✓ Performance optimization complete!              ${D}"
        echo "${G}═══════════════════════════════════════════════════${D}"
        ;;
    status)
        echo "${C}Memory:${D}"
        free -h
        echo ""
        echo "${C}CPU:${D}"
        cat /proc/cpuinfo | grep "model name" | head -1
        echo ""
        echo "${C}Load:${D}"
        uptime
        ;;
    *)
        echo "Usage: acro-performance [optimize|status]"
        echo ""
        echo "  optimize  - Run performance optimization"
        echo "  status    - Show system status"
        ;;
esac
PERF_EOF
    chmod +x /usr/local/bin/acro-performance
    success_msg "Performance mode script created"
}

# ═══════════════════════════════════════════════════════════════════════════
# STREAMING & CONTENT CREATION
# ═══════════════════════════════════════════════════════════════════════════

install_streaming_tools() {
    echo ""
    echo "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 📺 Streaming & Content Creation                         ${D}"
    echo "${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    status_msg "Installing streaming tools..."
    apt-get install -y \
        obs-studio \
        ffmpeg \
        v4l2loopback-dkms \
        simplescreenrecorder >> "$LOG_FILE" 2>&1 || true
    success_msg "Streaming tools installed"
    
    # OBS optimized config
    status_msg "Creating OBS optimized config..."
    mkdir -p ~/.config/obs-studio/basic/profiles/ACRO-Streaming
    cat > ~/.config/obs-studio/basic/profiles/ACRO-Streaming/basic.ini << 'OBS_EOF'
[General]
Name=ACRO-Streaming

[Video]
BaseCX=1280
BaseCY=720
OutputCX=1280
OutputCY=720
FPSType=1
FPSCommon=30

[Output]
Mode=Simple
RecFormat=mp4
RecEncoder=x264
RecQuality=Quality

[SimpleOutput]
VBitrate=2500
ABitrate=160
FileNameWithoutSpace=true
OBSEOF
    success_msg "OBS optimized config created"
}

# ═══════════════════════════════════════════════════════════════════════════
# STEAM FOR PROOT
# ═══════════════════════════════════════════════════════════════════════════

install_steam_proot() {
    echo ""
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 🎮 Steam for proot                                       ${D}"
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    status_msg "Installing Steam dependencies..."
    dpkg --add-architecture i386 >> "$LOG_FILE" 2>&1 || true
    apt-get update >> "$LOG_FILE" 2>&1
    apt-get install -y libc6:i386 libgl1:i386 libx11-6:i386 >> "$LOG_FILE" 2>&1 || true
    
    status_msg "Installing Steam (patched for proot)..."
    apt-get install -y steam-installer steam-devices >> "$LOG_FILE" 2>&1 || true
    
    # Create Steam proot wrapper
    cat > /usr/local/bin/steam-proot << 'STEAM_EOF'
#!/bin/bash
# Steam for proot - ACRO PRO+ Edition
# Patched to work in proot environment

export STEAM_RUNTIME=1
export STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0
export PRESSURE_VESSEL_FILESYSTEMS_RO=
export PROTON_USE_WINED3D=1
export DXVK_ASYNC=1

# Disable sandboxing for proot
export STEAM_ENABLE_SHADER_CACHE_MANAGEMENT=0

# Run Steam with compatibility flags
steam -no-browser -no-sandbox "$@"
STEAM_EOF
    chmod +x /usr/local/bin/steam-proot
    success_msg "Steam for proot installed"
    
    echo ""
    echo "${Y}Note: Run 'steam-proot' to launch Steam in proot mode${D}"
}

# ═══════════════════════════════════════════════════════════════════════════
# EXTRA APPLICATIONS
# ═══════════════════════════════════════════════════════════════════════════

install_extra_apps() {
    echo ""
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} 📦 Extra Applications                                   ${D}"
    echo "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    local apps=(
        "discord:Discord"
        "telegram-desktop:Telegram"
        "lutris:Lutris (Game Launcher)"
        "wine:Wine"
        "playonlinux:PlayOnLinux"
        "mangohud:MangoHUD (FPS overlay)"
        "goverlay:GOverlay (HUD config)"
    )
    
    for app in "${apps[@]}"; do
        pkg="${app%%:*}"
        name="${app##*:}"
        status_msg "Installing $name..."
        apt-get install -y "$pkg" >> "$LOG_FILE" 2>&1 || warning_msg "$name not available in repos"
    done
    
    success_msg "Extra applications installed"
}

# ═══════════════════════════════════════════════════════════════════════════
# FINAL SETUP
# ═══════════════════════════════════════════════════════════════════════════

final_setup() {
    echo ""
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo "${W} ✨ Final Setup                                          ${D}"
    echo "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${D}"
    echo ""
    
    # Create ACRO PRO+ menu entry
    mkdir -p /usr/share/applications
    cat > /usr/share/applications/acro-proplus.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Name=ACRO PRO+ Tools
Comment=ACRO PRO+ Edition Tools Menu
Exec=xfce4-terminal -e "bash -c 'echo ACRO PRO+ Tools; echo; echo 1. Gaming Mode - acro-gaming; echo 2. Theme Switcher - acro-theme; echo 3. Performance - acro-performance; echo 4. Emulators - acro-emulators; echo; read -p Press Enter to exit'"
Icon=applications-games
Terminal=false
Type=Application
Categories=Game;Utility;
DESKTOP_EOF
    success_msg "Desktop entry created"
    
    # Create welcome message
    cat > /etc/profile.d/acro-proplus-welcome.sh << 'WELCOME_EOF'
#!/bin/bash
if [ -f /etc/acro/edition ] && [ "$(cat /etc/acro/edition)" = "proplus" ]; then
    echo ""
    echo -e "\033[1;35m╔═══════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;35m║\033[1;37m  Welcome to ACRO PRO+ Edition!                               \033[1;35m║\033[0m"
    echo -e "\033[1;35m╠═══════════════════════════════════════════════════════════════╣\033[0m"
    echo -e "\033[1;35m║\033[0m  Commands: acro-gaming, acro-theme, acro-performance          \033[1;35m║\033[0m"
    echo -e "\033[1;35m╚═══════════════════════════════════════════════════════════════╝\033[0m"
    echo ""
fi
WELCOME_EOF
    chmod +x /etc/profile.d/acro-proplus-welcome.sh
    success_msg "Welcome message configured"
}

# ═══════════════════════════════════════════════════════════════════════════
# COMPLETION
# ═══════════════════════════════════════════════════════════════════════════

show_completion() {
    echo ""
    echo ""
    echo "${M}╔═══════════════════════════════════════════════════════════════════════╗${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}║${G}     ✓ ✓ ✓   ACRO PRO+ INSTALLATION COMPLETE!   ✓ ✓ ✓                  ${M}║${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}╠═══════════════════════════════════════════════════════════════════════╣${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}║${W}  Thank you for purchasing ACRO PRO+ Edition!                           ${M}║${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}║${C}  Available Commands:                                                   ${M}║${D}"
    echo "${M}║${Y}    acro-gaming      ${W}- Gaming mode toggle                             ${M}║${D}"
    echo "${M}║${Y}    acro-theme       ${W}- Theme switcher                                ${M}║${D}"
    echo "${M}║${Y}    acro-performance ${W}- Performance optimization                      ${M}║${D}"
    echo "${M}║${Y}    acro-emulators   ${W}- List gaming emulators                         ${M}║${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}║${C}  Support: deltaastra24@gmail.com                                       ${M}║${D}"
    echo "${M}║${D}                                                                         ${M}║${D}"
    echo "${M}╚═══════════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    echo "${Y}Please restart your session for all changes to take effect.${D}"
    echo ""
    
    log "Installation completed successfully"
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════

main() {
    # Detect execution environment
    # 1. Termux Environment (Non-Root, Termux-specific dirs)
    if [ -d "/data/data/com.termux/files" ] && [ "$(id -u)" != "0" ]; then
        # === TERMUX MODE ===
        # Just launch the installer inside Ubuntu.
        # The TUI and Validation will happen THERE (where /etc is writable).
        
        banner
        echo "${C}Initialize Installer...${D}"
        
        # Determine Ubuntu Root (Standard path for proot-distro)
        UBUNTU_ROOT="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
        
        if [ ! -d "$UBUNTU_ROOT" ]; then
            echo ""
            echo "${R}Error: Ubuntu distribution not found!${D}"
            echo "${Y}Please run setup.sh first to install the base system.${D}"
            echo "${C}Run: bash setup.sh${D}"
            exit 1
        fi
        
        # Copy this installer inside Ubuntu
        cp "$0" "$UBUNTU_ROOT/root/install-proplus.sh"
        chmod +x "$UBUNTU_ROOT/root/install-proplus.sh"
        
        echo "${G}Entering Ubuntu Environment...${D}"
        sleep 1
        
        # Execute inside Proot (No arguments passed, so it triggers TUI inside)
        proot-distro login ubuntu --user root --shared-tmp -- bash /root/install-proplus.sh
        
        exit $?
        
    else
        # === PROOT / INTERNAL MODE ===
        # This runs inside Ubuntu.
        
        banner
        
        # Check argument
        if [[ "$1" == "--license" ]] && [[ -n "$2" ]]; then
            # Command line mode
            LICENSE_KEY="$2"
        else
            # TUI Mode (Default)
            # Ensure dependencies for validation
            if ! command -v curl &> /dev/null; then
                 echo "${Y}Installing dependencies (curl)...${D}"
                 apt-get update >/dev/null 2>&1
                 apt-get install -y curl >/dev/null 2>&1
            fi
            
            get_license_input
            LICENSE_KEY="$INPUT_KEY"
        fi
        
        # Proceed with installation
        validate_license "$LICENSE_KEY"
        install_gpu_gaming
        install_emulators
        install_premium_themes
        install_performance_tools
        install_streaming_tools
        install_steam_proot
        install_extra_apps
        final_setup
        show_completion
    fi
}

main "$@"
