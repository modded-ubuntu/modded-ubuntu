#!/bin/bash

##############################################################################
#                                                                            #
#   MODDED UBUNTU PRO v3.0.0 - UNINSTALLER                                   #
#   Premium High-Performance Ubuntu GUI for Termux                           #
#                                                                            #
#   Original Script: modded-ubuntu                                           #
#   Original Authors: Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx               #
#                                                                            #
#   PRO Remake By: ZetaGo-Aurum                                              #
#   Brand: ALEOCROPHIC                                                       #
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

VERSION="3.0.0 PRO"

banner() {
    clear
    echo -e "${R}"
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
    ║                 🗑️  U N I N S T A L L E R  🗑️                  ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${D}"
    echo -e "${C}  ┌─────────────────────────────────────────────────────────────┐${D}"
    echo -e "${C}  │${W}  PRO Edition v${VERSION}  ${Y}│${M}  ZetaGo-Aurum ${Y}|${B} ALEOCROPHIC   ${C}│${D}"
    echo -e "${C}  └─────────────────────────────────────────────────────────────┘${D}"
    echo ""
}

status_msg() {
    echo -e "  ${M}▸${C} $1${D}"
}

success_msg() {
    echo -e "  ${G}✓${W} $1${D}"
}

warning_msg() {
    echo -e "  ${Y}!${W} $1${D}"
}

error_msg() {
    echo -e "  ${R}✗${W} $1${D}"
}

# Confirmation prompt
confirm_uninstall() {
    echo -e "  ${R}╔═══════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${R}║${Y}                     ⚠️  WARNING ⚠️                         ${R}║${D}"
    echo -e "  ${R}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${R}║${W}  This will completely remove:                            ${R}║${D}"
    echo -e "  ${R}║${D}                                                           ${R}║${D}"
    echo -e "  ${R}║${W}    • Ubuntu distribution and all data                    ${R}║${D}"
    echo -e "  ${R}║${W}    • All installed software (124+ packages)              ${R}║${D}"
    echo -e "  ${R}║${W}    • User configurations and files                       ${R}║${D}"
    echo -e "  ${R}║${W}    • Audio and VNC configurations                        ${R}║${D}"
    echo -e "  ${R}║${D}                                                           ${R}║${D}"
    echo -e "  ${R}╚═══════════════════════════════════════════════════════════╝${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Are you sure you want to continue? [y/N]: ${D})" confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        warning_msg "Uninstallation cancelled by user"
        echo ""
        exit 0
    fi
}

# Progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r  ${C}[${R}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${W}"
    printf "%${empty}s" | tr ' ' '░'
    printf "${C}]${W} %3d%% ${D}" $percentage
}

# Uninstall function
uninstall() {
    echo ""
    status_msg "Starting uninstallation process..."
    echo ""
    
    local steps=5
    local current=0
    
    # Step 1: Remove Ubuntu distribution
    current=$((current + 1))
    progress_bar $current $steps
    echo -e " Removing Ubuntu distribution..."
    
    if command -v proot-distro &> /dev/null; then
        proot-distro remove ubuntu 2>/dev/null || true
        proot-distro clear-cache 2>/dev/null || true
    fi
    
    # Step 2: Remove Ubuntu command
    current=$((current + 1))
    progress_bar $current $steps
    echo -e " Removing Ubuntu launcher..."
    
    rm -rf "$PREFIX/bin/ubuntu" 2>/dev/null || true
    
    # Step 3: Remove audio configuration
    current=$((current + 1))
    progress_bar $current $steps
    echo -e " Removing audio configuration..."
    
    rm -f "$HOME/.sound" 2>/dev/null || true
    
    # Stop PulseAudio if running
    pulseaudio --kill 2>/dev/null || true
    
    # Step 4: Clean up any leftover files
    current=$((current + 1))
    progress_bar $current $steps
    echo -e " Cleaning up leftover files..."
    
    rm -rf "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" 2>/dev/null || true
    rm -rf "$PREFIX/var/lib/proot-distro/dlcache/"*ubuntu* 2>/dev/null || true
    
    # Step 5: Final cleanup
    current=$((current + 1))
    progress_bar $current $steps
    echo -e " Finalizing..."
    
    sleep 1
    
    echo ""
    echo ""
    
    # Success message
    echo -e "  ${G}╔═══════════════════════════════════════════════════════════╗${D}"
    echo -e "  ${G}║${W}          🗑️  UNINSTALLATION COMPLETED  🗑️                 ${G}║${D}"
    echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${W}  Modded Ubuntu PRO has been completely removed.          ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}║${C}  To reinstall, run:${D}                                       ${G}║${D}"
    echo -e "  ${G}║${Y}    bash setup.sh${D}                                          ${G}║${D}"
    echo -e "  ${G}║${D}                                                           ${G}║${D}"
    echo -e "  ${G}╠═══════════════════════════════════════════════════════════╣${D}"
    echo -e "  ${G}║${M}  Thank you for using Modded Ubuntu PRO!                   ${G}║${D}"
    echo -e "  ${G}║${B}  ZetaGo-Aurum ${Y}|${B} ALEOCROPHIC${D}                              ${G}║${D}"
    echo -e "  ${G}╚═══════════════════════════════════════════════════════════╝${D}"
    echo ""
}

# Main execution
banner
confirm_uninstall
uninstall
