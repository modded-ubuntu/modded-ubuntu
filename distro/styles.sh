#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# ACRO PREMIUM STYLES LIBRARY
# Defines colors, animations, and common TUI elements.
# ═══════════════════════════════════════════════════════════════════════════

# COLOR PALETTE
R=$'\033[1;31m'          # Red
G=$'\033[1;32m'          # Green
Y=$'\033[1;33m'          # Yellow
B=$'\033[1;34m'          # Blue
M=$'\033[1;35m'          # Magenta
C=$'\033[1;36m'          # Cyan
W=$'\033[1;37m'          # White
D=$'\033[0m'             # Reset

# Extended Palette
PURPLE=$'\033[38;5;141m'
LPURPLE=$'\033[38;5;177m'
PINK=$'\033[38;5;213m'
CYAN_L=$'\033[38;5;81m'
GREEN_L=$'\033[38;5;120m'
ORANGE=$'\033[38;5;208m'
GRAY=$'\033[38;5;245m'
DGRAY=$'\033[38;5;238m'

# Formatting
BOLD=$'\033[1m'
DIM=$'\033[2m'
ITALIC=$'\033[3m'
UNDERLINE=$'\033[4m'

# ═══════════════════════════════════════════════════════════════════════════
# ANIMATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════

spinner() {
    local pid=$1
    local msg=$2
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local delay=0.1
    
    tput civis
    while kill -0 $pid 2>/dev/null; do
        for (( i=0; i<${#spinstr}; i++ )); do
            printf "\r  ${CYAN_L}${spinstr:$i:1}${D} ${msg}"
            sleep $delay
        done
    done
    tput cnorm
    printf "\r"
    # Clear line
    printf "                                                                \r"
}

type_text() {
    local text=$1
    local delay=${2:-0.02}
    for (( i=0; i<${#text}; i++ )); do
        printf "%s" "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

fade_line() {
    local text=$1
    local color=$2
    printf "${DIM}${color}%s${D}\n" "$text"
    sleep 0.02
}

# ═══════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════

# Logging Helper
log_msg() {
    if [ -n "$LOG_FILE" ]; then
        echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
    fi
}

status_msg() {
    echo -e "  ${PURPLE}▸${CYAN_L} $1${D}"
    log_msg "$1"
}

success_msg() {
    echo -e "  ${GREEN_L}✓${W} $1${D}"
    log_msg "[OK] $1"
}

error_msg() {
    echo -e "  ${R}✗${W} $1${D}"
    log_msg "[ERROR] $1"
}

warning_msg() {
    echo -e "  ${ORANGE}⚠${W} $1${D}"
    log_msg "[WARN] $1"
}

info_msg() {
    echo -e "  ${CYAN_L}ℹ${W} $1${D}"
    log_msg "[INFO] $1"
}

section_header() {
    local title=$1
    echo ""
    echo -e "  ${BG_DGRAY}${W} $title ${D}"
    echo -e "  ${DGRAY}$(printf '─%.0s' {1..60})${D}"
    log_msg "=== $title ==="
}

pro_banner() {
    clear
    echo ""
    echo "${CYAN_L}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║              🚀 A C R O   P R E M I U M   E D I T I O N 🚀               ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo "${D}"
    echo "  ${CYAN_L}┌───────────────────────────────────────────────────────────────────┐${D}"
    echo "  ${CYAN_L}│${W}  Secure Installer               ${Y}│${GREEN_L} Verified by ACRO Cloud${CYAN_L}        │${D}"
    echo "  ${CYAN_L}└───────────────────────────────────────────────────────────────────┘${D}"
    echo ""
}
