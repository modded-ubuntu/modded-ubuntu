#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
arch=$(uname -m)
username=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)

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
	echo -e " ${G} [!] Successfully Installed !\n"${W}
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
	rm /var/lib/dpkg/info/udisks2.postinst
	echo "" > /var/lib/dpkg/info/udisks2.postinst
	dpkg --configure -a
	apt-mark hold udisks2
	
	packs=(sudo gnupg2 curl nano git at-spi2-core xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
	for hulu in "${packs[@]}"; do
		type -p "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
			apt-get install "$hulu" -y --no-install-recommends
		}
	done
	
	apt-get update -y
	apt-get upgrade -y
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
		mv /data/data/com.termux/files/home/modded-ubuntu/patches/code.desktop /usr/share/applications/
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
	[[ $(command -v chromium) ]] && echo "${Y}Chromium is already Installed!${W}" || {
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
		echo -e "${G} Chromium Installed Successfully\n"
	}
}

install_firefox() {
	[[ $(command -v firefox) ]] && echo "${Y}Firefox is already Installed!${W}" || {
		echo -e "${G}Installing ${Y}Firefox${W}"
		bash <(curl -fsSL "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu-config/main/firefox.sh")
		echo -e "${G} Firefox Installed Successfully\n"
	}
}

install_softwares() {
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
	{ banner; sleep 1; }

	if [[ ${BROWSER_OPTION} == 2 ]]; then
		install_chromium
	elif [[ ${BROWSER_OPTION} == 3 ]]; then
		install_firefox
		install_chromium
	else
		install_firefox
	fi

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

}

downloader(){
	path="$1"
	[[ -e "$path" ]] && rm -rf "$path"
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
}

vnc() {
	banner
	echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}
	[[ ! -d "/home/$username/.vnc" ]] && mkdir -p "/home/$username/.vnc"

	downloader "/home/$username/.vnc/xstartup" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/xstartup"
	downloader "/usr/local/bin/vncstart" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstart"
	downloader "/usr/local/bin/vncstop" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstop"
	chmod +x /home/$username/.vnc/xstartup /usr/local/bin/vncstart /usr/local/bin/vncstop

	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/ubuntu)" > /data/data/com.termux/files/usr/bin/ubuntu
	echo "export DISPLAY=":1"" >> /etc/profile
	echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile 
	source /etc/profile
}

config() {
	banner
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
	yes | apt upgrade
	yes | apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin
	mv -vf /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfceverticals-old.png
	temp_folder=$(mktemp -d -p "$HOME")
	{ banner; sleep 1; cd $temp_folder; }

	echo -e "${R} [${W}-${R}]${C} Downloading Required Files.."${W}
	downloader "fonts.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/fonts.tar.gz"
	downloader "icons.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/icons.tar.gz"
	downloader "wallpaper.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
	downloader "ubuntu-settings.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz"
	downloader "Layan-gtk.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/Layan-gtk.tar.gz"
	downloader "Papirus-Dark-Custom.tar.xz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/Papirus-Dark-Custom.tar.xz" # https://github.com/owl4ce/dotfiles/

	echo -e "${R} [${W}-${R}]${C} Unpacking Files.."${W}
	tar -xvzf fonts.tar.gz -C "/usr/local/share/fonts/"
	tar -xvzf icons.tar.gz -C "/usr/share/icons/"
	tar -xvzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/"
	tar -xvf Papirus-Dark-Custom.tar.xz -C "/usr/share/icons/"
	tar -xvzf Layan-gtk.tar.gz -C "/usr/share/themes/"
	tar -xvzf ubuntu-settings.tar.gz -C "/home/$username/"	
	rm -fr $temp_folder

	echo -e "${R} [${W}-${R}]${C} Rebuilding Font Cache.."${W}
	fc-cache -fv

	echo -e "${R} [${W}-${R}]${C} Upgrading the System.."${W}
	apt update
	yes | apt upgrade
	yes | apt autoremove

}


# ----------- UNWANTED FUNCS -----------

rem_theme() {
	theme=(Bright Xfce-flat Daloa Xfce-kde2 Xfce-kolors Xfce-4.4 Xfce-light Xfce-4.6 Xfce-orange Emacs Xfce-b5 Xfce-redmondxp Xfce-basic Xfce-saltlake Moheli Xfce-cadmium Xfce-smooth Xfce-curve Xfce-stellar Retro Xfce-dawn Xfce-winter Smoke Xfce-dusk)
	for rmi in "${theme[@]}"; do
		type -p "$rmi" &>/dev/null || {
			rm -rf /usr/share/themes/"$rmi"
		}
	done
}

rem_font() {
	fonts=(hicolor LoginIcons ubuntu-mono-light)
	for rmf in "${fonts[@]}"; do
		type -p "$rmf" &>/dev/null || {
			rm -rf /usr/share/icons/"$rmf"
		}
	done
}

# rem_theme
# rem_font

# ----------------------------

check_root
package
install_softwares
config
vnc
note

