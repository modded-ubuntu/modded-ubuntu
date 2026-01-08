#!/bin/bash

# Define where to fetch styles
STYLE_URL="https://raw.githubusercontent.com/ZetaGo-Aurum/modded-ubuntu/master/distro/styles.sh"
TEMP_STYLE="/tmp/acro_styles.sh"

# Ensure curl
if ! command -v curl &> /dev/null; then
    echo "Installing dependencies..."
    pkg install curl -y >/dev/null 2>&1
fi

# Fetch Styles
echo -e "\033[1;36mFetching Premium UI...\033[0m"
curl -sL "$STYLE_URL" -o "$TEMP_STYLE"

if [ -f "$TEMP_STYLE" ] && [ -s "$TEMP_STYLE" ]; then
    source "$TEMP_STYLE"
else
    # Fallback minimal styles (when download fails)
    R=$'\033[1;31m'; G=$'\033[1;32m'; Y=$'\033[1;33m'; C=$'\033[1;36m'; W=$'\033[1;37m'; M=$'\033[1;35m'; D=$'\033[0m'
    GRAY=$'\033[38;5;245m'; CYAN_L=$'\033[38;5;81m'
    
    status_msg() { echo -e "  ${C}▸${D} $1"; }
    success_msg() { echo -e "  ${G}✓${D} $1"; }
    error_msg() { echo -e "  ${R}✗${D} $1"; }
    
    type_text() {
        local text=$1
        echo -e "$text"
    }
    
    pro_banner() {
        clear
        echo ""
        echo -e "${C}╔═══════════════════════════════════════════════════════════════════╗${D}"
        echo -e "${C}║${W}           🚀 A C R O   P R E M I U M   E D I T I O N 🚀          ${C}║${D}"
        echo -e "${C}╚═══════════════════════════════════════════════════════════════════╝${D}"
        echo ""
    }
fi

# Function to run scripts
run_installer() {
    local script_url=$1
    local name=$2
    local target="/tmp/install-$name.sh"
    
    type_text "${C}Initializing $name Installer...${D}" 0.02
    
    # Remove old file if exists
    rm -f "$target" 2>/dev/null
    
    # Download with verbose output and retry
    echo "${Y}▸ Downloading installer from GitHub...${D}"
    
    # Try up to 3 times
    local attempt=1
    while [ $attempt -le 3 ]; do
        echo "  ${GRAY}Attempt $attempt/3...${D}"
        curl -fL --connect-timeout 10 --max-time 60 "$script_url" -o "$target" 2>&1
        
        if [ -f "$target" ] && [ -s "$target" ]; then
            echo "${G}✓ Download successful${D}"
            break
        else
            echo "${R}✗ Download failed${D}"
            rm -f "$target" 2>/dev/null
            ((attempt++))
            sleep 2
        fi
    done
    
    # Verify file exists and is not empty
    if [ ! -f "$target" ] || [ ! -s "$target" ]; then
        echo ""
        echo "${R}═══════════════════════════════════════════════════════════════${D}"
        echo "${R}  ERROR: Failed to download installer script!${D}"
        echo "${R}═══════════════════════════════════════════════════════════════${D}"
        echo ""
        echo "${Y}Possible causes:${D}"
        echo "  1. No internet connection"
        echo "  2. GitHub is blocked or down"
        echo "  3. DNS resolution failed"
        echo ""
        echo "${C}Try:${D}"
        echo "  • Check internet: ${W}curl -I https://github.com${D}"
        echo "  • Update Termux: ${W}pkg update && pkg upgrade${D}"
        echo "  • Reinstall curl: ${W}pkg install curl${D}"
        echo ""
        exit 1
    fi
    
    # Make executable and run
    chmod +x "$target"
    bash "$target"
}

# Main Menu
clear
pro_banner

echo "${W}Select Premium Edition to Install:${D}"
echo ""
echo "  ${C}[1]${D} ${W}ACRO PRO+ Edition${D}      ${Y}(Rp 62.500)${D}"
echo "      ${GRAY}Optimized, Gaming, Basic Tools${D}"
echo ""
echo "  ${M}[2]${D} ${W}ACRO ULTIMATE Edition${D}  ${Y}(Rp 125.000)${D}"
echo "      ${GRAY}Full Pack, CyberSec, Privacy, Dev${D}"
echo ""
echo "  ${R}[0]${D} Exit"
echo ""
echo -n "  ${G}▸ Selection: ${W}"
read -r choice

case "$choice" in
    1)
        run_installer "https://raw.githubusercontent.com/ZetaGo-Aurum/modded-ubuntu/master/premium/pro-plus/install-proplus.sh" "proplus"
        ;;
    2)
        run_installer "https://raw.githubusercontent.com/ZetaGo-Aurum/modded-ubuntu/master/premium/ultimate/install-ultimate.sh" "ultimate"
        ;;
    0)
        exit 0
        ;;
    *)
        error_msg "Invalid selection"
        exit 1
        ;;
esac
