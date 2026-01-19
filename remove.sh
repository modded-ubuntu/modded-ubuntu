#!/bin/bash

##############################################################################
#                                                                            #
#   ACRO PRO Edition v3.5.0 - UNINSTALLER                                    #
#   Premium Linux Distribution for Termux (Ubuntu-based)                     #
#                                                                            #
#   Original Base: modded-ubuntu                                             #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#                                                                            #
#   ACRO Distro By: ZetaGo-Aurum                                             #
#   Brand: ALEOCROPHIC                                                       #
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
PINK=$'\033[38;5;213m'
CYAN_L=$'\033[38;5;81m'
GREEN_L=$'\033[38;5;120m'
ORANGE=$'\033[38;5;208m'
GRAY=$'\033[38;5;245m'
DGRAY=$'\033[38;5;238m'
RED_L=$'\033[38;5;196m'

BG_DGRAY=$'\033[48;5;236m'

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
            printf "\r  ${RED_L}${spinstr:$i:1}${D} ${msg}"
            sleep $delay
        done
    done
    tput cnorm 2>/dev/null
    printf "\r"
}

progress_bar() {
    local current=$1
    local total=$2
    local width=30
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    local bar_filled=""
    local bar_empty=""
    for ((i=0; i<filled; i++)); do bar_filled+="▓"; done
    for ((i=0; i<empty; i++)); do bar_empty+="░"; done
    
    printf "\r  ${PURPLE}[${RED_L}%s${GRAY}%s${PURPLE}]${D} ${W}%3d%%${D} " \
        "$bar_filled" "$bar_empty" $percentage
}

# ═══════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    clear
    echo ""
    echo -e "${RED_L}"
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
    ║              🗑️  U N I N S T A L L E R   v3.1.0  🗑️               ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${D}"
    echo -e "${CYAN_L}  ┌───────────────────────────────────────────────────────────────────┐${D}"
    echo -e "${CYAN_L}  │${W}  PRO Edition v${VERSION}   ${Y}│${PINK}  ZetaGo-Aurum ${Y}│${PURPLE} ALEOCROPHIC${CYAN_L}      │${D}"
    echo -e "${CYAN_L}  └───────────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

status_msg() { echo -e "\n  ${PURPLE}▸${CYAN_L} $1${D}"; }
success_msg() { echo -e "  ${GREEN_L}✓${W} $1${D}"; }
error_msg() { echo -e "  ${R}✗${W} $1${D}"; }
warning_msg() { echo -e "  ${ORANGE}⚠${W} $1${D}"; }
info_msg() { echo -e "  ${CYAN_L}ℹ${W} $1${D}"; }

section_header() {
    echo ""
    echo -e "  ${BG_DGRAY}${W} $1 ${D}"
    echo -e "  ${DGRAY}$(printf '─%.0s' {1..60})${D}"
}

# ═══════════════════════════════════════════════════════════════════════════
# CONFIRMATION
# ═══════════════════════════════════════════════════════════════════════════

confirm_uninstall() {
    echo -e "  ${RED_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${RED_L}║${ORANGE}                        ⚠️  WARNING ⚠️                             ${RED_L}║${D}"
    echo -e "  ${RED_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${RED_L}║${W}  This will completely remove:                                    ${RED_L}║${D}"
    echo -e "  ${RED_L}║${D}                                                                   ${RED_L}║${D}"
    echo -e "  ${RED_L}║${W}    • Ubuntu distribution and all data                            ${RED_L}║${D}"
    echo -e "  ${RED_L}║${W}    • All installed software (1000+ packages)                     ${RED_L}║${D}"
    echo -e "  ${RED_L}║${W}    • User configurations and files                               ${RED_L}║${D}"
    echo -e "  ${RED_L}║${W}    • Audio and VNC configurations                                ${RED_L}║${D}"
    echo -e "  ${RED_L}║${D}                                                                   ${RED_L}║${D}"
    echo -e "  ${RED_L}║${ORANGE}  ⚡ This action cannot be undone!                                ${RED_L}║${D}"
    echo -e "  ${RED_L}║${D}                                                                   ${RED_L}║${D}"
    echo -e "  ${RED_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Are you sure you want to continue? [y/N]: ${D})" confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        info_msg "Uninstallation cancelled by user"
        echo ""
        exit 0
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# UNINSTALL FUNCTION
# ═══════════════════════════════════════════════════════════════════════════

uninstall() {
    section_header "🗑️  REMOVING MODDED UBUNTU PRO"
    echo ""
    
    local steps=6
    local current=0
    
    # Step 1: Stop VNC if running
    current=$((current + 1))
    progress_bar $current $steps
    echo -n "${GRAY}Stopping VNC server...${D}"
    
    vncserver -kill :* 2>/dev/null || true
    rm -rf /tmp/.X*-lock 2>/dev/null || true
    rm -rf /tmp/.X11-unix/X* 2>/dev/null || true
    
    echo -e "\r$(printf ' %.0s' {1..70})\r"
    
    # Step 2: Remove Ubuntu distribution
    current=$((current + 1))
    progress_bar $current $steps
    echo -n "${GRAY}Removing Ubuntu distribution...${D}"
    
    {
        if command -v proot-distro &> /dev/null; then
            proot-distro remove ubuntu 2>/dev/null || true
            proot-distro clear-cache 2>/dev/null || true
        fi
    } &
    local pid=$!
    while kill -0 $pid 2>/dev/null; do
        sleep 0.5
    done
    
    echo -e "\r$(printf ' %.0s' {1..70})\r"
    
    # Step 3: Remove Ubuntu command
    current=$((current + 1))
    progress_bar $current $steps
    echo -n "${GRAY}Removing Ubuntu launcher...${D}"
    
    rm -rf "$PREFIX/bin/ubuntu" 2>/dev/null || true
    
    echo -e "\r$(printf ' %.0s' {1..70})\r"
    
    # Step 4: Remove audio configuration
    current=$((current + 1))
    progress_bar $current $steps
    echo -n "${GRAY}Removing audio configuration...${D}"
    
    rm -f "$HOME/.sound" 2>/dev/null || true
    pulseaudio --kill 2>/dev/null || true
    
    echo -e "\r$(printf ' %.0s' {1..70})\r"
    
    # Step 5: Clean up leftover files
    current=$((current + 1))
    progress_bar $current $steps
    echo -n "${GRAY}Cleaning up leftover files...${D}"
    
    rm -rf "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" 2>/dev/null || true
    rm -rf "$PREFIX/var/lib/proot-distro/dlcache/"*ubuntu* 2>/dev/null || true
    
    echo -e "\r$(printf ' %.0s' {1..70})\r"
    
    # Step 6: Final cleanup
    current=$((current + 1))
    progress_bar $current $steps
    echo -n "${GRAY}Finalizing...${D}"
    
    sleep 1
    
    echo -e "\r$(printf ' %.0s' {1..70})\r"
    
    progress_bar $steps $steps
    echo ""
    echo ""
    
    # Success message
    echo -e "  ${GREEN_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${GREEN_L}║${W}              ✅ UNINSTALLATION COMPLETED ✅                      ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${W}  Modded Ubuntu PRO has been completely removed.                  ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${CYAN_L}  To reinstall, run:${D}                                              ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${Y}    bash setup.sh${D}                                                  ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${D}                                                                   ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╠═══════════════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${GREEN_L}║${PINK}  Thank you for using Modded Ubuntu PRO!                         ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}║${PURPLE}  ZetaGo-Aurum ${Y}│${PURPLE} ALEOCROPHIC${D}                                      ${GREEN_L}║${D}"
    echo -e "  ${GREEN_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

banner
confirm_uninstall
uninstall
