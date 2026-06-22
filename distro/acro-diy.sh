#!/bin/bash
# ACRO Suite - DIY Utility
# Allows user configuration additions/deletions without breaking system plumbing

R=$'\033[1;31m'
G=$'\033[1;32m'
Y=$'\033[1;33m'
C=$'\033[1;36m'
W=$'\033[1;37m'
D=$'\033[0m'
CYAN_L=$'\033[38;5;81m'

LOG_FILE="/tmp/acro-diy.log"
USERNAME=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)
[[ -z "$USERNAME" ]] && USERNAME=$(whoami)

# Helper function
status_msg() { echo -e "\n  ${C}▸${W} $1${D}"; }
success_msg() { echo -e "  ${G}✓${W} $1${D}"; }
error_msg() { echo -e "  ${R}✗${W} $1${D}"; }
info_msg() { echo -e "  ${CYAN_L}ℹ${W} $1${D}"; }

banner() {
    clear
    echo "${C}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║        🛠️  ACRO DIY UTILITY (Do-It-Yourself) 🛠️                     ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo "${D}"
    echo "  ${W}Modify & manage your Ubuntu system safely without breaking core VNC/Audio/GPU configs.${D}"
    echo "  ───────────────────────────────────────────────────────────────────"
}

# 1. Reset Desktop settings to default
reset_desktop() {
    status_msg "Resetting desktop environment settings to default..."
    
    local target_home="/home/$USERNAME"
    [[ "$USERNAME" == "root" ]] && target_home="/root"
    
    # Backup existing
    if [ -d "$target_home/.config/xfce4" ]; then
        mv "$target_home/.config/xfce4" "$target_home/.config/xfce4-backup-$(date +%s)" 2>/dev/null
    fi
    
    # Re-apply defaults
    mkdir -p "$target_home/.config/xfce4/xfconf/xfce-perchannel-xml"
    
    # Restore default Orchis wallpaper config
    cat > "$target_home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" << 'XFCE_WALLPAPER_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="single-workspace-mode" type="bool" value="true"/>
    <property name="single-workspace-number" type="int" value="0"/>
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/acro-wallpaper.jpg"/>
          <property name="image-style" type="int" value="5"/>
          <property name="color-style" type="int" value="0"/>
        </property>
      </property>
      <property name="monitorVNC-0" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/acro-wallpaper.jpg"/>
          <property name="image-style" type="int" value="5"/>
          <property name="color-style" type="int" value="0"/>
        </property>
      </property>
      <property name="monitorscreen" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string" value="/usr/share/backgrounds/acro-wallpaper.jpg"/>
          <property name="image-style" type="int" value="5"/>
          <property name="color-style" type="int" value="0"/>
        </property>
      </property>
    </property>
  </property>
</channel>
XFCE_WALLPAPER_EOF
    
    # Default compositor off (VNC performance)
    cat > "$target_home/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" << 'XFWM4_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="use_compositing" type="bool" value="false"/>
    <property name="sync_to_vblank" type="bool" value="false"/>
    <property name="unredirect_overlays" type="bool" value="true"/>
    <property name="show_frame_shadow" type="bool" value="false"/>
    <property name="box_move" type="bool" value="true"/>
    <property name="box_resize" type="bool" value="true"/>
  </property>
</channel>
XFWM4_EOF
    
    chown -R "$USERNAME:$USERNAME" "$target_home/.config/xfce4" 2>/dev/null
    
    success_msg "Desktop layout and configuration files restored to default!"
    info_msg "Please restart your desktop session (vncreset) to see the changes."
    sleep 3
}

# 2. Safe package uninstaller (Avoid deleting critical system packages)
safe_remove() {
    echo ""
    read -p "  Enter package name to remove: " pkg_to_remove
    
    if [ -z "$pkg_to_remove" ]; then
        error_msg "Package name cannot be empty."
        sleep 2
        return
    fi
    
    # Protected lists
    local protected=(
        pulseaudio pulseaudio-utils pavucontrol alsa-utils alsa-base dbus-x11 
        tigervnc-standalone-server x11vnc xvfb xauth x11-utils xinit xfce4 xfce4-terminal
        sudo bash dialog whiptail grep sed awk coreutils proot-distro
    )
    
    for prot in "${protected[@]}"; do
        if [[ "$pkg_to_remove" == "$prot" ]]; then
            echo ""
            error_msg "CRITICAL: '$pkg_to_remove' is protected because the GUI and audio system depends on it."
            warning_msg "Removing this package could break the ACRO environment."
            read -p "  Are you absolutely sure you want to force remove it? [y/N]: " force_choice
            if [[ ! "$force_choice" =~ ^[yY]$ ]]; then
                echo "  Removal cancelled."
                sleep 2
                return
            fi
        fi
    done
    
    status_msg "Removing package: $pkg_to_remove..."
    apt-get purge -y "$pkg_to_remove"
    apt-get autoremove -y
    
    success_msg "Package removed safely!"
    sleep 2
}

# 3. Manage custom startup hook
manage_startup() {
    local target_home="/home/$USERNAME"
    [[ "$USERNAME" == "root" ]] && target_home="/root"
    local hook_file="$target_home/.acro-diy-startup.sh"
    
    if [ ! -f "$hook_file" ]; then
        cat > "$hook_file" << 'EOF'
#!/bin/bash
# ACRO DIY Startup Hook
# Place commands here that you want to auto-run inside Ubuntu when starting GUI (VNC / Termux-X11)
# Example:
# rclone mount ... &
# python3 my_server.py &
EOF
        chmod +x "$hook_file"
        chown "$USERNAME:$USERNAME" "$hook_file" 2>/dev/null
    fi
    
    # Open in nano
    nano "$hook_file"
}

# 4. Manage auto-install package lists
manage_pkg_list() {
    local target_home="/home/$USERNAME"
    [[ "$USERNAME" == "root" ]] && target_home="/root"
    local pkg_file="$target_home/.acro-diy-packages"
    
    if [ ! -f "$pkg_file" ]; then
        cat > "$pkg_file" << 'EOF'
# ACRO DIY Custom Packages
# Add Debian package names here (one per line) that you want to keep installed.
# The system updater and DIY installer will auto-install these.
# Example:
# neovim
# fastfetch
# build-essential
EOF
        chown "$USERNAME:$USERNAME" "$pkg_file" 2>/dev/null
    fi
    
    nano "$pkg_file"
    
    # Process package list to install now
    status_msg "Syncing and installing custom package lists..."
    local pkgs=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Ignore comments and empty lines
        [[ "$line" =~ ^# ]] && continue
        [[ -z "$line" ]] && continue
        pkgs+=("$line")
    done < "$pkg_file"
    
    if [ ${#pkgs[@]} -gt 0 ]; then
        apt-get update -y
        apt-get install -y "${pkgs[@]}"
        success_msg "Custom package list synchronized!"
    else
        info_msg "No packages in the list."
    fi
    sleep 3
}

# 5. Clean system cache
clean_cache() {
    status_msg "Cleaning system logs, package cache, and thumbnail history..."
    
    local target_home="/home/$USERNAME"
    [[ "$USERNAME" == "root" ]] && target_home="/root"
    
    apt-get clean
    apt-get autoremove -y
    
    # Clear thumbnails and browser cache
    rm -rf "$target_home"/.cache/thumbnails/* 2>/dev/null
    rm -rf "$target_home"/.cache/sessions/* 2>/dev/null
    rm -rf /var/log/*.log 2>/dev/null
    rm -rf /var/log/*/*.log 2>/dev/null
    rm -rf /tmp/* 2>/dev/null
    
    success_msg "System clean completed successfully! Free space increased."
    sleep 2
}

# Main loop
while true; do
    banner
    echo ""
    echo "  ${GREEN_L}[1]${W} Reset Desktop Layout & Themes${D}"
    echo "      ${GRAY}Restores default Orchis-Dark panels & backgrounds if broken${D}"
    echo ""
    echo "  ${GREEN_L}[2]${W} Safe Package Uninstaller${D}"
    echo "      ${GRAY}Safe removal of user packages preventing core system breaks${D}"
    echo ""
    echo "  ${GREEN_L}[3]${W} Customize Startup Actions${D}"
    echo "      ${GRAY}Edit custom script to run automatically at desktop session start${D}"
    echo ""
    echo "  ${GREEN_L}[4]${W} Edit Auto-Install Package List${D}"
    echo "      ${GRAY}Add packages you want auto-installed and updated${D}"
    echo ""
    echo "  ${GREEN_L}[5]${W} Clean System Caches & Log Files${D}"
    echo "      ${GRAY}Safely clear disk space inside Termux storage${D}"
    echo ""
    echo "  ${R}[0]${W} Exit DIY Utility${D}"
    echo ""
    read -p "  Select option [0-5]: " choice
    
    case "$choice" in
        1) reset_desktop ;;
        2) safe_remove ;;
        3) manage_startup ;;
        4) manage_pkg_list ;;
        5) clean_cache ;;
        0) exit 0 ;;
        *) error_msg "Invalid selection." ; sleep 1 ;;
    esac
done
