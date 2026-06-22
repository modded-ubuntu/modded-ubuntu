#!/bin/bash

##############################################################################
#                                                                            #
#   ACRO PRO Edition v3.5.1 - SETTINGS UTILITY                               #
#   Comprehensive GUI Configuration Tool                                     #
#                                                                            #
#   ACRO Distro By: ZetaGo-Aurum                                             #
#   Brand: ALEOCROPHIC                                                       #
#                                                                            #
##############################################################################

# ═══════════════════════════════════════════════════════════════════════════
# COLOR PALETTE - Using $'...' syntax for Termux compatibility
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
LPURPLE=$'\033[38;5;177m'
PINK=$'\033[38;5;213m'
CYAN_L=$'\033[38;5;81m'
GREEN_L=$'\033[38;5;120m'
ORANGE=$'\033[38;5;208m'
GRAY=$'\033[38;5;245m'
DGRAY=$'\033[38;5;238m'

BG_DGRAY=$'\033[48;5;236m'

VERSION="3.5.1"
DISTRO_NAME="ACRO PRO Edition"
CONFIG_DIR="$HOME/.config/acro"
VNC_CONFIG="$HOME/.vnc/config"

# ═══════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════

banner() {
    clear
    echo ""
    echo "${CYAN_L}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║       ⚙️  ACRO PRO SETTINGS  ⚙️                                    ║
    ║                                                                   ║
    ╠═══════════════════════════════════════════════════════════════════╣
    ║           Comprehensive System Configuration Tool                 ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF
    echo "${D}"
    echo "  ${GRAY}Version: ${W}${VERSION}${D}  │  ${GRAY}Brand: ${PINK}ALEOCROPHIC${D}"
    echo "  ${DGRAY}─────────────────────────────────────────────────────────────────${D}"
    echo ""
}

status_msg() { echo ""; echo "  ${PURPLE}▸${CYAN_L} $1${D}"; }
success_msg() { echo "  ${GREEN_L}✓${W} $1${D}"; }
error_msg() { echo "  ${R}✗${W} $1${D}"; }
warning_msg() { echo "  ${ORANGE}⚠${W} $1${D}"; }
info_msg() { echo "  ${CYAN_L}ℹ${W} $1${D}"; }

menu_item() {
    local num=$1
    local icon=$2
    local title=$3
    local desc=$4
    echo "  ${GREEN_L}[$num]${D} $icon ${W}$title${D}"
    [[ -n "$desc" ]] && echo "      ${GRAY}$desc${D}"
}

section_header() {
    echo ""
    echo "  ${BG_DGRAY}${W} $1 ${D}"
    echo "  ${DGRAY}────────────────────────────────────────────────────────────${D}"
}

# Initialize config directory
init_config() {
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$HOME/.vnc"
}

# ═══════════════════════════════════════════════════════════════════════════
# LANGUAGE SETTINGS - Now properly sets in .bashrc
# ═══════════════════════════════════════════════════════════════════════════

configure_language() {
    banner
    section_header "🌐 LANGUAGE SETTINGS"
    echo ""
    
    local languages=(
        "en_US.UTF-8:English (United States)"
        "en_GB.UTF-8:English (United Kingdom)"
        "id_ID.UTF-8:Bahasa Indonesia"
        "ms_MY.UTF-8:Bahasa Melayu (Malaysia)"
        "zh_CN.UTF-8:中文 (简体)"
        "zh_TW.UTF-8:中文 (繁體)"
        "ja_JP.UTF-8:日本語"
        "ko_KR.UTF-8:한국어"
        "th_TH.UTF-8:ไทย"
        "vi_VN.UTF-8:Tiếng Việt"
        "ar_SA.UTF-8:العربية"
        "hi_IN.UTF-8:हिन्दी"
        "bn_BD.UTF-8:বাংলা"
        "ru_RU.UTF-8:Русский"
        "de_DE.UTF-8:Deutsch"
        "fr_FR.UTF-8:Français"
        "es_ES.UTF-8:Español"
        "pt_BR.UTF-8:Português (Brasil)"
        "it_IT.UTF-8:Italiano"
        "nl_NL.UTF-8:Nederlands"
        "pl_PL.UTF-8:Polski"
        "tr_TR.UTF-8:Türkçe"
        "uk_UA.UTF-8:Українська"
    )
    
    local current_lang=$(cat /etc/default/locale 2>/dev/null | grep LANG= | cut -d= -f2 | tr -d '"')
    [[ -z "$current_lang" ]] && current_lang="Not set"
    
    info_msg "Current language: ${Y}$current_lang${D}"
    echo ""
    
    local i=1
    for lang in "${languages[@]}"; do
        IFS=':' read -r code name <<< "$lang"
        printf "  ${GREEN_L}[%2d]${D} %-15s ${GRAY}%s${D}\n" $i "$code" "$name"
        ((i++))
    done
    
    echo ""
    echo "  ${R}[0]${W}  Back to main menu${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Select language [0-${#languages[@]}]: ${D})" choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#languages[@]} ]]; then
        local selected=${languages[$((choice-1))]}
        IFS=':' read -r locale name <<< "$selected"
        
        status_msg "Setting language to: $name"
        
        # Generate locale
        locale-gen "$locale" > /dev/null 2>&1 || true
        
        # Set default locale in system
        echo "LANG=$locale" > /etc/default/locale
        echo "LANGUAGE=$locale" >> /etc/default/locale
        echo "LC_ALL=$locale" >> /etc/default/locale
        
        # IMPORTANT: Update .bashrc for proper locale detection
        # Remove old locale settings first
        sed -i '/^export LANG=/d' "$HOME/.bashrc" 2>/dev/null || true
        sed -i '/^export LC_ALL=/d' "$HOME/.bashrc" 2>/dev/null || true
        sed -i '/^export LANGUAGE=/d' "$HOME/.bashrc" 2>/dev/null || true
        
        # Add new locale settings to .bashrc
        cat >> "$HOME/.bashrc" << BASHRC_LOCALE_EOF

# Modded Ubuntu PRO - Language settings (set by mu-settings)
export LANG="$locale"
export LC_ALL="$locale"
export LANGUAGE="$locale"
BASHRC_LOCALE_EOF
        
        # Export for current session
        export LANG=$locale
        export LANGUAGE=$locale
        export LC_ALL=$locale
        
        success_msg "Language set to: $name"
        info_msg "Settings saved to .bashrc"
        info_msg "Restart terminal or run: source ~/.bashrc"
        sleep 3
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# TIMEZONE SETTINGS
# ═══════════════════════════════════════════════════════════════════════════

configure_timezone() {
    banner
    section_header "🕐 TIMEZONE SETTINGS"
    echo ""
    
    local current_tz=$(cat /etc/timezone 2>/dev/null || echo "Not set")
    info_msg "Current timezone: ${Y}$current_tz${D}"
    echo ""
    
    local regions=(
        "Asia"
        "Europe"
        "America"
        "Africa"
        "Australia"
        "Pacific"
        "Atlantic"
        "Indian"
        "Arctic"
        "Antarctica"
    )
    
    echo -e "  ${W}Select Region:${D}"
    echo ""
    
    local i=1
    for region in "${regions[@]}"; do
        echo -e "  ${GREEN_L}[$i]${D} $region"
        ((i++))
    done
    
    echo ""
    echo -e "  ${R}[0]${W} Back to main menu${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Select region [0-${#regions[@]}]: ${D})" choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#regions[@]} ]]; then
        local region=${regions[$((choice-1))]}
        
        banner
        section_header "🕐 TIMEZONE - $region"
        echo ""
        
        # Get cities for the region
        local cities=($(ls /usr/share/zoneinfo/$region/ 2>/dev/null | grep -v "+" | head -30))
        
        local i=1
        for city in "${cities[@]}"; do
            printf "  ${GREEN_L}[%2d]${D} %s\n" $i "$city"
            ((i++))
        done
        
        echo ""
        echo -e "  ${R}[0]${W}  Back${D}"
        echo ""
        
        read -p "  $(echo -e ${Y}Select city [0-${#cities[@]}]: ${D})" city_choice
        
        if [[ "$city_choice" =~ ^[0-9]+$ ]] && [[ $city_choice -ge 1 ]] && [[ $city_choice -le ${#cities[@]} ]]; then
            local city=${cities[$((city_choice-1))]}
            local tz="$region/$city"
            
            status_msg "Setting timezone to: $tz"
            
            # Set timezone
            ln -sf "/usr/share/zoneinfo/$tz" /etc/localtime
            echo "$tz" > /etc/timezone
            
            success_msg "Timezone set to: $tz"
            sleep 2
        fi
    fi
}

# ═══════════════════════════════════════════════════════════════════════════
# VNC SETTINGS
# ═══════════════════════════════════════════════════════════════════════════

configure_vnc() {
    banner
    section_header "🖥️  VNC DISPLAY SETTINGS"
    echo ""
    
    # Load current settings
    local current_res=$(grep "geometry=" "$VNC_CONFIG" 2>/dev/null | cut -d= -f2 || echo "1920x1080")
    local current_depth=$(grep "depth=" "$VNC_CONFIG" 2>/dev/null | cut -d= -f2 || echo "24")
    
    info_msg "Current resolution: ${Y}$current_res${D}"
    info_msg "Current color depth: ${Y}$current_depth bit${D}"
    echo ""
    
    echo -e "  ${W}Resolution Options:${D}"
    echo ""
    menu_item "1" "📱" "720p (1280x720)" "Good for phones"
    menu_item "2" "💻" "1080p (1920x1080)" "Full HD - Recommended"
    menu_item "3" "🖥️ " "1440p (2560x1440)" "QHD - High end devices"
    menu_item "4" "📺" "4K (3840x2160)" "Ultra HD - May be slow"
    menu_item "5" "📐" "Custom" "Enter custom resolution"
    echo ""
    echo -e "  ${R}[0]${W}  Back to main menu${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Select resolution [0-5]: ${D})" choice
    
    case $choice in
        1) local res="1280x720" ;;
        2) local res="1920x1080" ;;
        3) local res="2560x1440" ;;
        4) local res="3840x2160" ;;
        5)
            read -p "  $(echo -e ${Y}Enter resolution \(e.g., 1920x1080\): ${D})" res
            if [[ ! "$res" =~ ^[0-9]+x[0-9]+$ ]]; then
                error_msg "Invalid resolution format"
                sleep 2
                return
            fi
            ;;
        0|*) return ;;
    esac
    
    # Color depth selection
    echo ""
    echo -e "  ${W}Color Depth:${D}"
    echo ""
    menu_item "1" "🎨" "16-bit" "Faster, lower quality"
    menu_item "2" "🎨" "24-bit" "Balanced - Recommended"
    menu_item "3" "🎨" "32-bit" "Best quality, slower"
    echo ""
    
    read -p "  $(echo -e ${Y}Select color depth [1-3]: ${D})" depth_choice
    
    case $depth_choice in
        1) local depth=16 ;;
        3) local depth=32 ;;
        *) local depth=24 ;;
    esac
    
    # Save configuration
    mkdir -p "$HOME/.vnc"
    cat > "$VNC_CONFIG" << EOF
# Modded Ubuntu PRO VNC Configuration
geometry=$res
depth=$depth
localhost=no
SecurityTypes=VncAuth
EOF
    
    success_msg "VNC settings saved"
    info_msg "Resolution: $res"
    info_msg "Color depth: ${depth}-bit"
    info_msg "Restart VNC to apply changes (vncstop && vncstart)"
    sleep 2
}

# ═══════════════════════════════════════════════════════════════════════════
# AUDIO SETTINGS
# ═══════════════════════════════════════════════════════════════════════════

configure_audio() {
    banner
    section_header "🔊 AUDIO SETTINGS"
    echo ""
    
    menu_item "1" "🔈" "Test Audio Output" "Play a test sound"
    menu_item "2" "🎤" "Test Microphone" "Record and playback"
    menu_item "3" "🔧" "Restart PulseAudio" "Fix audio issues"
    menu_item "4" "📊" "Volume Control" "Open pavucontrol"
    echo ""
    echo -e "  ${R}[0]${W}  Back to main menu${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Select option [0-4]: ${D})" choice
    
    case $choice in
        1)
            status_msg "Playing test sound..."
            paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || \
            speaker-test -t sine -f 440 -l 1 2>/dev/null || \
            error_msg "No audio output available"
            sleep 2
            ;;
        2)
            status_msg "Recording for 3 seconds..."
            arecord -d 3 /tmp/mic_test.wav 2>/dev/null && \
            status_msg "Playing back..." && \
            aplay /tmp/mic_test.wav 2>/dev/null && \
            rm -f /tmp/mic_test.wav || \
            error_msg "Microphone test failed"
            sleep 2
            ;;
        3)
            status_msg "Restarting PulseAudio..."
            pulseaudio --kill 2>/dev/null
            pulseaudio --start --exit-idle-time=-1 --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1"
            pacmd load-module module-aaudio-sink 2>/dev/null || pacmd load-module module-opensles-sink 2>/dev/null || pacmd load-module module-sles-sink 2>/dev/null || true
            pacmd load-module module-aaudio-source 2>/dev/null || pacmd load-module module-sles-source 2>/dev/null || pacmd load-module module-opensles-source 2>/dev/null || true
            pacmd set-default-sink Android_AAudio_Output 2>/dev/null || pacmd set-default-sink opensles_output 2>/dev/null || pacmd set-default-sink sles_output 2>/dev/null || true
            pacmd set-default-source Android_AAudio_Input 2>/dev/null || pacmd set-default-source sles_input 2>/dev/null || pacmd set-default-source opensles_input 2>/dev/null || true
            success_msg "PulseAudio restarted with mic input enabled"
            sleep 2
            ;;
        4)
            if command -v pavucontrol &> /dev/null; then
                pavucontrol &
                success_msg "Volume control opened"
            else
                error_msg "pavucontrol not installed"
                info_msg "Install with: sudo apt install pavucontrol"
            fi
            sleep 2
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════
# APPEARANCE SETTINGS
# ═══════════════════════════════════════════════════════════════════════════

configure_appearance() {
    banner
    section_header "🎨 APPEARANCE SETTINGS"
    echo ""
    
    menu_item "1" "🌙" "Dark Theme" "Orchis Dark"
    menu_item "2" "☀️ " "Light Theme" "Orchis Light"
    menu_item "3" "🔤" "Font Scaling" "Adjust font size"
    menu_item "4" "📏" "DPI Settings" "Screen scaling"
    echo ""
    echo -e "  ${R}[0]${W}  Back to main menu${D}"
    echo ""
    
    read -p "  $(echo -e ${Y}Select option [0-4]: ${D})" choice
    
    case $choice in
        1)
            status_msg "Applying dark theme..."
            xfconf-query -c xsettings -p /Net/ThemeName -s "Orchis-Dark" 2>/dev/null || \
            gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark" 2>/dev/null || \
            warning_msg "Theme might need to be applied manually"
            success_msg "Dark theme applied"
            sleep 2
            ;;
        2)
            status_msg "Applying light theme..."
            xfconf-query -c xsettings -p /Net/ThemeName -s "Orchis-Light" 2>/dev/null || \
            gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Light" 2>/dev/null || \
            warning_msg "Theme might need to be applied manually"
            success_msg "Light theme applied"
            sleep 2
            ;;
        3)
            echo ""
            echo -e "  ${W}Font Scaling:${D}"
            echo -e "  ${GREEN_L}[1]${D} 1.0x (100%)"
            echo -e "  ${GREEN_L}[2]${D} 1.25x (125%)"
            echo -e "  ${GREEN_L}[3]${D} 1.5x (150%)"
            echo -e "  ${GREEN_L}[4]${D} 2.0x (200%)"
            echo ""
            read -p "  $(echo -e ${Y}Select scale [1-4]: ${D})" scale_choice
            case $scale_choice in
                1) local scale=1.0 ;;
                2) local scale=1.25 ;;
                3) local scale=1.5 ;;
                4) local scale=2.0 ;;
                *) local scale=1.0 ;;
            esac
            xfconf-query -c xsettings -p /Xft/DPI -s $((96 * ${scale%.*})) 2>/dev/null || true
            success_msg "Font scaling set to ${scale}x"
            sleep 2
            ;;
        4)
            echo ""
            read -p "  $(echo -e ${Y}Enter DPI value \(e.g., 96, 120, 144\): ${D})" dpi
            if [[ "$dpi" =~ ^[0-9]+$ ]]; then
                xfconf-query -c xsettings -p /Xft/DPI -s $dpi 2>/dev/null || true
                success_msg "DPI set to $dpi"
            else
                error_msg "Invalid DPI value"
            fi
            sleep 2
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════
# SYSTEM INFO
# ═══════════════════════════════════════════════════════════════════════════

show_system_info() {
    banner
    section_header "📊 SYSTEM INFORMATION"
    echo ""
    
    neofetch 2>/dev/null || {
        echo -e "  ${W}OS:${D} $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
        echo -e "  ${W}Kernel:${D} $(uname -r)"
        echo -e "  ${W}Architecture:${D} $(uname -m)"
        echo -e "  ${W}Shell:${D} $SHELL"
        echo -e "  ${W}User:${D} $(whoami)"
        echo -e "  ${W}Timezone:${D} $(cat /etc/timezone 2>/dev/null || echo 'Not set')"
        echo -e "  ${W}Locale:${D} $LANG"
    }
    
    echo ""
    echo -e "  ${DGRAY}Press Enter to return...${D}"
    read
}

# ═══════════════════════════════════════════════════════════════════════════
# DONATION & SUPPORT SCREEN
# ═══════════════════════════════════════════════════════════════════════════

show_donation_info() {
    banner
    section_header "💖 SUPPORT & DONATIONS"
    echo ""
    echo -e "  ${PINK}  ████████╗██████╗  █████╗ ██╗  ██╗████████╗███████╗███████╗██████╗ ${D}"
    echo -e "  ${PINK}  ╚══██╔══╝██╔══██╗██╔══██╗██║ ██╔╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗${D}"
    echo -e "  ${PINK}     ██║   ██████╔╝███████║█████╔╝    ██║   █████╗  █████╗  ██████╔╝${D}"
    echo -e "  ${PINK}     ██║   ██╔══██╗██╔══██║██╔═██╗    ██║   ██╔══╝  ██╔══╝  ██╔══██╗${D}"
    echo -e "  ${PINK}     ██║   ██║  ██║██║  ██║██║  ██╗   ██║   ███████╗███████╗██║  ██║${D}"
    echo -e "  ${PINK}     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═╝${D}"
    echo ""
    echo -e "  ${Y}─────────────────────────────────────────────────────────────────${D}"
    echo -e "  ${W}If you enjoy using ${CYAN_L}${DISTRO_NAME}${W} and want to support its ongoing${D}"
    echo -e "  ${W}development, please consider donating on Trakteer!${D}"
    echo ""
    echo -e "  ${LPURPLE}  ☕ Trakteer Tip Link (Click or Copy):${D}"
    echo -e "  ${GREEN_L}  👉  https://trakteer.id/Aleocrophic/tip  👈${D}"
    echo ""
    echo -e "  ${GRAY}  Your support helps keep this project updated, optimized, and free!${D}"
    echo -e "  ${Y}─────────────────────────────────────────────────────────────────${D}"
    echo ""
    echo -e "  ${DGRAY}Press Enter to return to main menu...${D}"
    read
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN MENU
# ═══════════════════════════════════════════════════════════════════════════

main_menu() {
    while true; do
        banner
        
        echo "  ${W}Main Menu:${D}"
        echo ""
        menu_item "1" "🌐" "Language" "Set system language"
        menu_item "2" "🕐" "Timezone" "Configure timezone"
        menu_item "3" "🖥️ " "VNC Display" "Resolution and color depth"
        menu_item "4" "🔊" "Audio" "Audio input/output settings"
        menu_item "5" "🎨" "Appearance" "Themes and scaling"
        menu_item "6" "📊" "System Info" "View system information"
        menu_item "7" "🛠️ " "DIY Utility" "Safely manage custom packages & startup"
        menu_item "8" "🔄" "Hard Reset" "Clear cache, kill apps, restart VNC"
        menu_item "9" "💖" "Support & Donate" "Trakteer tip to developer"
        echo ""
        echo "  ${R}[0]${W}  Exit${D}"
        echo ""
        
        read -p "  $(echo -e ${Y}Select option [0-9]: ${D})" choice
        
        case $choice in
            1) configure_language ;;
            2) configure_timezone ;;
            3) configure_vnc ;;
            4) configure_audio ;;
            5) configure_appearance ;;
            6) show_system_info ;;
            7) 
                if [[ -f "/usr/local/bin/acro-diy" ]]; then
                    /usr/local/bin/acro-diy
                elif [[ -f "/usr/local/bin/mu-diy" ]]; then
                    /usr/local/bin/mu-diy
                else
                    error_msg "DIY utility not found!"
                    info_msg "Run 'update.sh' or gui installer to install it."
                    sleep 2
                fi
                ;;
            8) 
                if command -v vncreset &> /dev/null; then
                    vncreset
                    echo ""
                    read -p "  ${GRAY}Press Enter to continue...${D}"
                else
                    error_msg "vncreset command not found"
                    info_msg "Run GUI installer to install: sudo bash gui.sh"
                    sleep 2
                fi
                ;;
            9) show_donation_info ;;
            0) 
                echo ""
                info_msg "Goodbye!"
                echo ""
                exit 0
                ;;
        esac
    done
}

# ═══════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════

init_config
main_menu
