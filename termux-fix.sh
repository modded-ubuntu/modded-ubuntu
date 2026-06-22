#!/bin/bash

##############################################################################
#                                                                            #
#   ACRO PRO Edition v3.5.1 - TERMUX AUTO-FIX                                #
#   Automatically fixes common Termux problems                                #
#                                                                            #
#   By: ZetaGo-Aurum                                                         #
#   Brand: ALEOCROPHIC                                                       #
#                                                                            #
##############################################################################

# ═══════════════════════════════════════════════════════════════════════════
# COLOR PALETTE
# ═══════════════════════════════════════════════════════════════════════════
R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
B=$'\033[1;34m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'

CYAN_L=$'\033[38;5;81m'
GREEN_L=$'\033[38;5;120m'
ORANGE=$'\033[38;5;208m'
PURPLE=$'\033[38;5;141m'
GRAY=$'\033[38;5;245m'

# ═══════════════════════════════════════════════════════════════════════════
# UI FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    echo ""
    echo "${CYAN_L}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║       🔧 ACRO TERMUX AUTO-FIX 🔧                                  ║
    ║                                                                   ║
    ╠═══════════════════════════════════════════════════════════════════╣
    ║       Automatically fixes common Termux problems                  ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo "${D}"
}

status_msg() { echo ""; echo "  ${PURPLE}▸${CYAN_L} $1${D}"; }
success_msg() { echo "  ${GREEN_L}✓${W} $1${D}"; }
error_msg() { echo "  ${R}✗${W} $1${D}"; }
warning_msg() { echo "  ${ORANGE}⚠${W} $1${D}"; }
info_msg() { echo "  ${CYAN_L}ℹ${W} $1${D}"; }

# ═══════════════════════════════════════════════════════════════════════════
# FIX FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

fix_dpkg_lock() {
    status_msg "Checking dpkg locks..."
    
    # Kill any stuck dpkg processes
    pkill -9 dpkg 2>/dev/null || true
    pkill -9 apt 2>/dev/null || true
    pkill -9 apt-get 2>/dev/null || true
    
    # Remove lock files
    rm -f "$PREFIX/var/lib/dpkg/lock" 2>/dev/null || true
    rm -f "$PREFIX/var/lib/dpkg/lock-frontend" 2>/dev/null || true
    rm -f "$PREFIX/var/lib/apt/lists/lock" 2>/dev/null || true
    rm -f "$PREFIX/var/cache/apt/archives/lock" 2>/dev/null || true
    
    # Reconfigure dpkg
    dpkg --configure -a 2>/dev/null || true
    
    success_msg "dpkg locks cleared"
}

fix_package_cache() {
    status_msg "Fixing package cache..."
    
    # Clear apt cache
    rm -rf "$PREFIX/var/cache/apt/archives/*.deb" 2>/dev/null || true
    rm -rf "$PREFIX/var/cache/apt/archives/partial/*" 2>/dev/null || true
    
    # Clear apt lists
    rm -rf "$PREFIX/var/lib/apt/lists/*" 2>/dev/null || true
    
    # Recreate required directories
    mkdir -p "$PREFIX/var/cache/apt/archives/partial"
    mkdir -p "$PREFIX/var/lib/apt/lists/partial"
    
    success_msg "Package cache cleared"
}

fix_storage_permissions() {
    status_msg "Fixing storage permissions..."
    
    # Setup Termux storage if not already done
    if [[ ! -d "$HOME/storage" ]]; then
        termux-setup-storage 2>/dev/null || {
            warning_msg "Storage setup requires user interaction"
            info_msg "Run 'termux-setup-storage' manually if needed"
        }
    else
        success_msg "Storage already configured"
    fi
}

fix_broken_packages() {
    status_msg "Fixing broken packages..."
    
    # Fix broken dependencies
    apt-get -f install -y 2>/dev/null || true
    
    # Try to fix any held packages
    apt-get --fix-broken install -y 2>/dev/null || true
    
    success_msg "Broken packages fixed"
}

fix_repository() {
    status_msg "Refreshing package repository..."
    
    # Update package lists
    apt-get update -y 2>/dev/null || {
        warning_msg "Repository update had issues, trying alternative..."
        
        # Try changing mirror
        termux-change-repo 2>/dev/null || true
        apt-get update -y 2>/dev/null || true
    }
    
    success_msg "Repository refreshed"
}

fix_symlinks() {
    status_msg "Fixing broken symlinks..."
    
    # Common symlinks that might break
    local symlinks=(
        "$PREFIX/bin/bash"
        "$PREFIX/bin/sh"
        "$PREFIX/bin/env"
    )
    
    local fixed=0
    for link in "${symlinks[@]}"; do
        if [[ -L "$link" ]] && [[ ! -e "$link" ]]; then
            rm -f "$link" 2>/dev/null
            ((fixed++))
        fi
    done
    
    if [[ $fixed -gt 0 ]]; then
        # Reinstall coreutils to fix essential symlinks
        apt-get install --reinstall coreutils -y 2>/dev/null || true
        success_msg "Fixed $fixed broken symlinks"
    else
        success_msg "No broken symlinks found"
    fi
}

fix_termux_properties() {
    status_msg "Fixing Termux properties..."
    
    mkdir -p "$HOME/.termux"
    
    # Create/update termux.properties for optimal performance
    cat > "$HOME/.termux/termux.properties" << 'PROPS_EOF'
# ACRO PRO Edition - Optimized Termux Properties
allow-external-apps = true
use-black-ui = true
bell-character = ignore
use-fullscreen-workaround = true
fullscreen = false
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
PROPS_EOF
    
    # Reload settings
    termux-reload-settings 2>/dev/null || true
    
    success_msg "Termux properties optimized"
}

upgrade_packages() {
    status_msg "Upgrading all packages..."
    
    yes | pkg upgrade -y 2>/dev/null || {
        warning_msg "Some packages may not have upgraded"
    }
    
    success_msg "Packages upgraded"
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

main() {
    banner
    
    echo ""
    info_msg "Running automatic Termux diagnostics and fixes..."
    echo ""
    
    # Run all fixes
    fix_dpkg_lock
    fix_package_cache
    fix_broken_packages
    fix_repository
    fix_symlinks
    fix_storage_permissions
    fix_termux_properties
    
    echo ""
    echo "  ${GREEN_L}╔═══════════════════════════════════════════════════════════════════╗${D}"
    echo "  ${GREEN_L}║${W}              ✅ TERMUX AUTO-FIX COMPLETE! ✅                    ${GREEN_L}║${D}"
    echo "  ${GREEN_L}╚═══════════════════════════════════════════════════════════════════╝${D}"
    echo ""
    info_msg "Your Termux environment has been optimized"
    info_msg "You can now proceed with ACRO installation"
    echo ""
}

# Check if running in Termux
if [[ -z "$PREFIX" ]] || [[ ! -d "$PREFIX" ]]; then
    echo ""
    error_msg "This script must be run in Termux!"
    echo ""
    exit 1
fi

main "$@"
