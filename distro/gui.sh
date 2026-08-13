#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
arch=$(uname -m)
username=$(getent passwd $(whoami) | cut -d: -f1)

check_root(){
	if [ "$(id -u)" -ne 0 ]; then
		echo -ne " ${R}Run this program as root!\n\n"${W}
		exit 1
	fi
}

banner() {
	clear
	cat <<- EOF
		${Y}    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  
		${C}    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ 
		${G}    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ 

	EOF
	echo -e "${G}     A modded gui version of ubuntu for Termux\n"
}

note() {
	banner
	echo -e " ${G} [-] Successfully Installed !\n"${W}
	sleep 1
	cat <<- EOF
		 ${G}[-] Type ${C}vncstart${G} to run Vncserver.
		 ${G}[-] Type ${C}vncstop${G} to stop Vncserver.

		 ${C}Install VNC VIEWER Apk on your Device.

		 ${C}Open VNC VIEWER & Click on + Button.

		 ${C}Enter the Address localhost:1 & Name anything you like.

		 ${C}Set the Picture Quality to High for better Quality.

		 ${C}Click on Connect & Input the Password.

		 ${C}Enjoy :D${W}
	EOF
}

package() {
	banner
	echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
	apt-get update -y
	apt install udisks2 -y
	if [ -f /var/lib/dpkg/info/udisks2.postinst ]; then
		rm /var/lib/dpkg/info/udisks2.postinst
		echo "" > /var/lib/dpkg/info/udisks2.postinst
		dpkg --configure -a
		apt-mark hold udisks2
	fi
	
	packs=(sudo gnupg2 curl nano git xz-utils python3 at-spi2-core xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
	for hulu in "${packs[@]}"; do
		type -p "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${W}"
			apt-get install "$hulu" -y --no-install-recommends
		}
	done
	
	apt-get update -y
	apt-get upgrade -y
}

install_ghost_framework() {
    echo -e "${G}Installing ${Y}Ghost Framework${W}"
    curl -fsSL https://raw.githubusercontent.com/Midohajhouj/Ghost-Framework/refs/heads/main/setup.sh -o /tmp/install_ghost.sh
    chmod +x /tmp/install_ghost.sh
    bash /tmp/install_ghost.sh
    echo -e "${G} Ghost Framework Installed Successfully\n${W}"
}

install_wireshark() {
    [[ $(command -v wireshark) ]] && echo "${Y}Wireshark is already Installed!${W}\n" || {
        echo -e "${G}Installing ${Y}Wireshark${W}"
        sudo apt install wireshark -y
        echo -e "${G} Wireshark Installed Successfully\n${W}"
    }
}

install_gimp() {
    [[ $(command -v gimp) ]] && echo "${Y}GIMP is already Installed!${W}\n" || {
        echo -e "${G}Installing ${Y}GIMP${W}"
        sudo apt install gimp -y
        echo -e "${G} GIMP Installed Successfully\n${W}"
    }
}

install_htop() {
    [[ $(command -v htop) ]] && echo "${Y}htop is already Installed!${W}\n" || {
        echo -e "${G}Installing ${Y}htop${W}"
        sudo apt install htop -y
        echo -e "${G} htop Installed Successfully\n${W}"
    }
}

install_kali_tools() {
    echo -e "${G}Installing ${Y}Kali Linux Tools${W}"
    if [[ -e '/data/data/com.termux/files/home/modded-ubuntu/distro/tools.sh' ]]; then
        echo -e "${G}Using local tools.sh for installation...${W}"
        chmod +x /data/data/com.termux/files/home/modded-ubuntu/distro/tools.sh
        bash /data/data/com.termux/files/home/modded-ubuntu/distro/tools.sh
    else
        echo -e "${G}Downloading tools.sh from remote...${W}"
        wget -q --show-progress "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/tools.sh" -O /tmp/tools.sh
        chmod +x /tmp/tools.sh
        bash /tmp/tools.sh
    fi
    echo -e "${G} Kali Linux Tools Installed Successfully\n${W}"
}

install_apt() {
	for apt in "$@"; do
		[[ `command -v $apt` ]] && echo "${Y}${apt} is already Installed!${W}" || {
			echo -e "${G}Installing ${Y}${apt}${W}"
			apt install -y ${apt}
		}
	done
}

install_vscode() {
	[[ $(command -v code) ]] && echo "${Y}VSCode is already Installed!${W}" || {
		echo -e "${G}Installing ${Y}VSCode${W}"
		curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
		apt update -y
		apt install code -y
		echo "Patching.."
		curl -fsSL https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/patches/code.desktop > /usr/share/applications/code.desktop
		echo -e "${C} Visual Studio Code Installed Successfully\n${W}"
	}
}

install_sublime() {
	[[ $(command -v subl) ]] && echo "${Y}Sublime is already Installed!${W}" || {
		apt install gnupg2 software-properties-common --no-install-recommends -y
		echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
		curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2> /dev/null
		apt update -y
		apt install sublime-text -y 
		echo -e "${C} Sublime Text Editor Installed Successfully\n${W}"
	}
}

install_chromium() {
	[[ $(command -v chromium) ]] && echo "${Y}Chromium is already Installed!${W}\n" || {
		echo -e "${G}Installing ${Y}Chromium${W}"
		apt purge chromium* chromium-browser* snapd -y
		apt install gnupg2 software-properties-common --no-install-recommends -y
		echo -e "deb http://ftp.debian.org/debian buster main\ndeb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
		apt update -y
		apt install chromium -y
		sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop
		echo -e "${G} Chromium Installed Successfully\n${W}"
	}
}

install_firefox() {
	[[ $(command -v firefox) ]] && echo "${Y}Firefox is already Installed!${W}\n" || {
		echo -e "${G}Installing ${Y}Firefox${W}"
		bash <(curl -fsSL "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/firefox.sh")
		echo -e "${G} Firefox Installed Successfully\n${W}"
	}
}

install_tools() {
	banner
	cat <<- EOF
		${Y} ---${G} Select Browser ${Y}---

		${C} [${W}1${C}] Firefox (Default)
		${C} [${W}2${C}] Chromium
		${C} [${W}3${C}] Both (Firefox + Chromium)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" BROWSER_OPTION
	banner

	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		cat <<- EOF
			${Y} ---${G} Select IDE ${Y}---

			${C} [${W}1${C}] Sublime Text Editor (Recommended)
			${C} [${W}2${C}] Visual Studio Code
			${C} [${W}3${C}] Both (Sublime + VSCode)
			${C} [${W}4${C}] Skip! (Default)

		EOF
		read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" IDE_OPTION
		banner
	}
	
	cat <<- EOF
		${Y} ---${G} Media Player ${Y}---

		${C} [${W}1${C}] MPV Media Player (Recommended)
		${C} [${W}2${C}] VLC Media Player
		${C} [${W}3${C}] Both (MPV + VLC)
		${C} [${W}4${C}] Skip! (Default)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" PLAYER_OPTION
	banner

	cat <<- EOF
		${Y} ---${G} Select Additional Tools ${Y}---

		${C} [${W}1${C}] Kali Linux Tools	
		${C} [${W}2${C}] Ghost Framework
		${C} [${W}3${C}] Wireshark
		${C} [${W}4${C}] GIMP
		${C} [${W}5${C}] htop
		${C} [${W}6${C}] All of the above
		${C} [${W}7${C}] Skip! (Default)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" TOOLS_OPTION
	banner

	# Install Browsers
	if [[ ${BROWSER_OPTION} == 2 ]]; then
		install_chromium
	elif [[ ${BROWSER_OPTION} == 3 ]]; then
		install_firefox
		install_chromium
	else
		install_firefox
	fi

	# Install IDEs
	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		if [[ ${IDE_OPTION} == 1 ]]; then
			install_sublime
		elif [[ ${IDE_OPTION} == 2 ]]; then
			install_vscode
		elif [[ ${IDE_OPTION} == 3 ]]; then
			install_sublime
			install_vscode
		else
			echo -e "${Y} [!] Skipping IDE Installation\n"
			sleep 1
		fi
	}

	# Install Media Players
	if [[ ${PLAYER_OPTION} == 1 ]]; then
		install_apt "mpv"
	elif [[ ${PLAYER_OPTION} == 2 ]]; then
		install_apt "vlc"
	elif [[ ${PLAYER_OPTION} == 3 ]]; then
		install_apt "mpv" "vlc"
	else
		echo -e "${Y} [!] Skipping Media Player Installation\n"
		sleep 1
	fi

	# Install Additional Tools
	case $TOOLS_OPTION in
		1) install_kali_tools ;;
		2) install_ghost_framework ;;
		3) install_wireshark ;;
		4) install_gimp ;;
		5) install_htop ;;
		6) 
			install_kali_tools
			install_ghost_framework
			install_wireshark
			install_gimp
			install_htop
			;;
		*) echo -e "${Y} [!] Skipping Additional Tools Installation\n" ;;
	esac
}

downloader(){
	path="$1"
	[[ -e "$path" ]] && rm -rf "$path"
	echo "Downloading $(basename $1)..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
}

sound_fix() {
	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/ubuntu)" > /data/data/com.termux/files/usr/bin/ubuntu
	echo "export DISPLAY=":1"" >> /etc/profile
	echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile 
	source /etc/profile
}

rem_theme() {
	theme=(Bright Daloa Emacs Moheli Retro Smoke)
	for rmi in "${theme[@]}"; do
		type -p "$rmi" &>/dev/null || {
			rm -rf /usr/share/themes/"$rmi"
		}
	done
}

rem_icon() {
	fonts=(hicolor LoginIcons ubuntu-mono-light)
	for rmf in "${fonts[@]}"; do
		type -p "$rmf" &>/dev/null || {
			rm -rf /usr/share/icons/"$rmf"
		}
	done
}

config() {
	banner
	sound_fix

	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
	yes | apt upgrade
	yes | apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin
	mv -vf /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfceverticals-old.png
	temp_folder=$(mktemp -d -p "$HOME")
	{ banner; sleep 1; cd $temp_folder; }

	echo -e "${R} [${W}-${R}]${C} Downloading Required Files..\n"${W}
	downloader "fonts.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/fonts.tar.gz"
	downloader "icons.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/icons.tar.gz"
	downloader "wallpaper.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
	downloader "gtk-themes.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/gtk-themes.tar.gz"
	downloader "ubuntu-settings.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz"

	echo -e "${R} [${W}-${R}]${C} Unpacking Files..\n"${W}
	tar -xvzf fonts.tar.gz -C "/usr/local/share/fonts/"
	tar -xvzf icons.tar.gz -C "/usr/share/icons/"
	tar -xvzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/"
	tar -xvzf gtk-themes.tar.gz -C "/usr/share/themes/"
	tar -xvzf ubuntu-settings.tar.gz -C "/home/$username/"	
	rm -fr $temp_folder

	echo -e "${R} [${W}-${R}]${C} Purging Unnecessary Files.."${W}
	rem_theme
	rem_icon

	echo -e "${R} [${W}-${R}]${C} Rebuilding Font Cache..\n"${W}
	fc-cache -fv

	echo -e "${R} [${W}-${R}]${C} Upgrading the System..\n"${W}
	apt update
	yes | apt upgrade
	apt clean
	yes | apt autoremove
}

# ----------------------------

check_root
package
install_tools
config
note
