#!/bin/bash
# ==============================================================================
# Interactive Modular Installer (using whiptail)
# ==============================================================================

export PROJ_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"
source "${PROJ_ROOT}/utils/logger.sh"

# Ensure whiptail is installed
if ! command -v whiptail &> /dev/null; then
    log_info "Installing whiptail (newt) for the interactive installer..."
    pkg install newt -y
fi

whiptail --title "Ubuntu Termux Environment Manager" --msgbox "Welcome to the highly advanced, modular, production-grade platform setup for Ubuntu in Termux.\n\nThis installer will guide you through customizing your environment." 12 60

GUI_CHOICE=$(whiptail --title "GUI System Selection" --radiolist \
"Select a Desktop Environment (Switchable later):" 15 60 4 \
"XFCE" "Lightweight (Default)" ON \
"LXDE" "Ultra Minimal" OFF \
"KDE" "Heavy / Feature-Rich" OFF \
"None" "Headless Server" OFF 3>&1 1>&2 2>&3)

DEV_TOOLS=$(whiptail --title "Developer Tools" --checklist \
"Select development kits to install:" 15 60 4 \
"NodeJS" "Node.js + NPM + Yarn" OFF \
"Python" "Python 3 + PIP + Venv" OFF \
"Git" "Git + GitHub CLI" ON \
"VSCode" "VS Code Server" OFF 3>&1 1>&2 2>&3)

PERF_MODE=$(whiptail --title "Performance Profile" --menu \
"Select your desired performance profile:" 15 60 3 \
"Low" "Disable animations, minimal RAM usage" \
"Balanced" "Standard desktop experience" \
"High" "Maximum performance, all features enabled" 3>&1 1>&2 2>&3)

log_info "Saving configuration..."
cat << EOF > "${PROJ_ROOT}/config/system.env"
GUI_ENV="${GUI_CHOICE}"
DEV_TOOLS="${DEV_TOOLS}"
PERF_MODE="${PERF_MODE}"
EOF

log_success "Configuration saved to /config/system.env"

# Execute installations based on choices
log_info "Applying configurations..."
# Here you would call individual module installers, e.g.,
# bash "${PROJ_ROOT}/modules/gui/install.sh" "$GUI_CHOICE"
