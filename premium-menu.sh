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

if [ -f "$TEMP_STYLE" ]; then
    source "$TEMP_STYLE"
else
    # Fallback minimal styles
    R=$'\033[1;31m'; G=$'\033[1;32m'; C=$'\033[1;36m'; D=$'\033[0m'
    status_msg() { echo -e "  $1"; }
    success_msg() { echo -e "  $1"; }
    error_msg() { echo -e "  $1"; }
fi

# Function to run scripts
run_installer() {
    local script_url=$1
    local name=$2
    
    type_text "${C}Initializing $name Installer...${D}" 0.02
    
    # Download execute
    curl -sL "$script_url" -o "/tmp/install-$name.sh"
    bash "/tmp/install-$name.sh"
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
