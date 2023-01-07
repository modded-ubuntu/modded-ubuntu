#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

if [ "$(id -u)" -ne 0 ]; then
	echo -ne " ${R}Run this program as root!"${W}
    exit 1
fi

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "\033[0m\n"

}

extra_things() {
	clear
	banner
	echo
	echo "-----Select Browser-----"
	echo
	echo "1. firefox (recommended)"
	echo
	echo "2. chromium."
	echo 
	echo "3. both firefox and chromium"
	echo
	echo "4. skip this part"
	echo
	read -p "Select option(default 1): " select_browser
	echo
	sleep 1.5
	clear
	banner
	echo
	echo "-----Select IDE (not for arm devices)-----"
	echo
	echo "1. Sublime Text Editor (recommended)"
	echo
	echo "2. Visual Studio Code (VSCODE)"
	echo
	echo "3. Both vscode and sublime"
	echo
	echo "4. skip this part"
	echo
	read -p "Select option(default 1): " select_ide
	echo
	sleep 1.5
	clear
	banner
	echo "-----Select Media Player-----"
	echo 
	echo "1. mpv media player(recommended)"
	echo
	echo "2. VLC media player"
	echo
	echo "3. both VLC and mpv"
	echo
	echo "4. skip this part"
	echo
	read -p "Select option(default 1): " select_media
	clear
	banner
	if [[ $select_browser == "1" ]]; then
		firefox_install	 
	elif [[ $select_browser == "2" ]]; then
		clear
		banner
		sleep 1
		chromium
	elif [[ $select_browser == "3" ]]; then
		firefox_install
		chromium
	elif [[ $select_browser == "4" ]]; then
		echo
		echo "Skiping Browser Installation"
		echo
		sleep 2
		clear
	elif [[ $select_browser == "" ]]; then
		firefox_install
	else 
		firefox_install
	fi
	if [[ $select_ide == "1" ]]; then
		sublime_installer
	elif [[ $select_ide == "2" ]]; then
		vscode_installer
	elif [[ $select_ide == "3" ]]; then
		sublime_installer
		sleep 1
		vscode_installer
	elif [[ $select_ide == "4" ]]; then
		echo
		echo "Skiping IDE Installation"
		echo
		sleep 2
		clear
	else
		sublime_installer
	fi
	if [[ $select_media == "1" ]]; then
		mpv_installer
	elif [[ $select_media == "2" ]]; then
		vlc_installer
	elif [[ $select_media == "3" ]]; then
		mpv_installer
		sleep 1
		vlc_installer
	elif [[ $select_media == "4" ]]; then
		echo
		echo "Skiping Media Player Installation"
		echo
		sleep 2
		clear
	else
		mpv_installer
	fi
}

firefox_install() {
		clear
		banner
		sleep 1
		echo "Checking if  Firefox browser installed already.."
		echo
		echo
		if [[ $(command -v firefox) ]]; then
			echo "Firefox is already installed.."
			sleep .5
			clear
		else
			clear
			banner
			sleep 1
			echo "Firefox not found.Installing now.."
			echo
			echo
			apt install curl gnupg2 -y
			curl -fSsL https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu-config/main/firefox.sh | bash
		fi

}

video_player_installer() {
	banner
	echo
	echo "Select video player from bellow"
	echo
	echo "1. mpv (recommended)"
	echo
	echo "2. vlc media player"
	echo
	echo "3. both vlc and mpv"
	echo
	echo "4. skip this part"
	echo
	read -p "select an option(Default 1): " select_vd
	echo
	if [[ ${select_vd} == "1" ]]; then
		mpv_installer
	elif [[ ${select_vd} == "2" ]]; then
		vlc_installer
	elif [[ ${select_vd} == "3" ]]; then
		mpv_installer
		sleep 1
		vlc_installer
	elif [[ ${select_vd} == "4" ]]; then
		echo "moving to the next part"
		sleep 1.7
		clear
	elif [[ ${select_vd} == "" ]]; then
		mpv_installer
	fi

}

mpv_installer() {

	clear
	banner
	echo
	echo "Checking if mpv is available or not"
	if [[ $(command -v mpv) ]]; then
		echo 
		echo "mpv is already Installed"
		sleep 1
	else
		echo "mpv is not installed. Installing mpv.."
		echo
		sleep 1
		apt update && apt install mpv -y
	fi
}

vlc_installer() {

	clear
	banner
	echo
	echo "Checking if vlc is available or not"
	if [[ $(command -v vlc) ]]; then
		echo 
		echo "vlc is already Installed"
		sleep 1
	else
		echo "vlc  is not installed. Installing mpv.."
		echo
		sleep 1
		apt update && apt install vlc -y
	fi

}


browser_installer() {
	banner
	echo 
	echo "Select which browser do you want."
	echo
	echo "1. firefox"
	echo
	echo "2. chromium"
	echo 
	echo "3. firefox & chromium (both)"
	echo
	read -p "select an option(Default 1): " selected_b
	echo
	if [[ ${selected_b} == "1" ]]; then
		clear
		firefox_install 
	elif [[ ${selected_b} == "2" ]]; then
		clear
		echo "installing Chromium browser.."
		echo
		chromium
	elif [[ ${selected_b} == "3" ]]; then
		clear
		echo "installing Firefox and Chromium browser.."
		echo
		firefox_install
		chromium
	elif [[ ${selected_b} == "" ]]; then
		clear
		firefox_install
	else 
		clear
		firefox_install 
	fi
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
    packs=(sudo wget gnupg2 curl nano git at-spi2-core xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra  gtk2-engines-murrine gtk2-engines-pixbuf)
    for hulu in "${packs[@]}"; do
        type -p "$hulu" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
            apt-get install "$hulu" -y --no-install-recommends
        }
    done
    apt-get update -y
    apt-get upgrade -y
}

chromium() {
    banner
    echo -e "${R} [${W}-${R}]${C} Uninstalling OLD chromium..."${W}
    chrome=(chromium* chromium-browser* snapd)
    for hula in "${chrome[@]}"; do
        type -p "$hula" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Purging package : ${Y}$hula${C}"${W}
            apt purge "$hula" -y 
            apt purge "$hula" -y 
        }
    done
    apt update -y
    apt upgrade -y
    apt install software-properties-common gnupg2 --no-install-recommends -y
    banner
    echo -e "${R} [${W}-${R}]${C} Installing Chromium..."${W}
    echo "deb http://ftp.debian.org/debian buster main
deb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    apt update -y
    apt install chromium -y
    sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop
    apt-get upgrade -y
}

theme() {
    theme=(Bright Xfce-flat Daloa Xfce-kde2 Xfce-kolors Xfce-4.4 Xfce-light Xfce-4.6 Xfce-orange Emacs Xfce-b5 Xfce-redmondxp Xfce-basic Xfce-saltlake Moheli Xfce-cadmium Xfce-smooth Xfce-curve Xfce-stellar Retro Xfce-dawn Xfce-winter Smoke Xfce-dusk)
    for rmi in "${theme[@]}"; do
        type -p "$rmi" &>/dev/null || {
            rm -rf /usr/share/themes/"$rmi"
        }
    done
}

font() {
    fonts=(hicolor LoginIcons ubuntu-mono-light)
    for rmf in "${fonts[@]}"; do
        type -p "$rmf" &>/dev/null || {
            rm -rf /usr/share/icons/"$rmf"
        }
    done
}

vscode_installer() {
	banner
	echo
	echo "installing Visual Studio Code (vscode).."
	echo
	apt install gnupg2 -y 
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    apt install apt-transport-https -y
    apt update -y
    apt install code -y
	echo "Patching vscode..."
	echo
	sleep .5
	mv /data/data/com.termux/files/home/modded-ubuntu/patches/code.desktop /usr/share/applications/
}
sublime_installer() {
	clear
	banner
	echo 
	echo "installing Sublime Text Editor.."
	echo
	apt install gnupg2 -y
	apt install  software-properties-common gnupg2 --no-install-recommends -y
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
	apt-get install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
	apt-get update
	apt-get install sublime-text -y 
}
ide_installer() {
	banner
	echo
	echo "Choose Coding software(IDE) [only for aarch64/arm64 devices.]"
	echo
	echo "1. Sublime Text Editor(lightweight [recommended])"
	echo 
	echo "2. Visual Studio Code(vscode) [very nice IDE but ram hungry]"
	echo
	echo "3. VSCODE & SUBLIME (both IDEs)"
	echo
	read -p "Select option(Default 1): " selected_ide
	if [[ ${selected_ide} == "1" ]]; then
		sublime_installer
	elif [[ ${selected_ide} == "2" ]]; then
		vscode_installer
	elif [[ ${selected_ide} == "3" ]]; then
		banner
		echo
		echo "Installing both IDEs (A bamboo is waiting for your Ram:) )"
		echo 
		sleep 2
		sublime_installer
		vscode_installer
	elif [[ ${selected_ide} == "" ]]; then
		sublime_installer
	else
		sublime_installer
	fi
}

refs() {
    apt update && yes | apt install gnupg2
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    apt-get upgrade -y
    apt install gnupg2 gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin -y 
    banner
    echo
    git clone --depth=1 https://github.com/vinceliuice/Layan-gtk-theme.git $HOME/Layan-gtk-theme
    chmod +x $HOME/Layan-gtk-theme/install.sh
    bash $HOME/Layan-gtk-theme/install.sh
	
	git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/WhiteSur-gtk-theme
	chmod +x $HOME/WhiteSur-gtk-theme/install.sh
	bash $HOME/WhiteSur-gtk-theme/install.sh
	
	git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme $HOME/WhiteSur-icon-theme
	chmod +x $HOME/WhiteSur-icon-theme/install.sh
	bash $HOME/WhiteSur-icon-theme/install.sh 
	
	mkdir -pv ~/.icons
	wget -q --show-progress https://github.com/owl4ce/dotfiles/releases/download/ng/Papirus-Dark-Custom.tar.xz
	tar -xf Papirus-Dark-Custom.tar.xz -C ~/.icons/
	ln -vs ~/.icons/Papirus-Dark-Custom /usr/share/icons/

	git clone https://github.com/alvatip/Nordzy-cursors --depth=1
	cd Nordzy-cursors
	./install.sh

}

vnc() {
    banner
    echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}

    [[ ! -d "$HOME/.vnc" ]] && mkdir -p "$HOME/.vnc"
    [[ -e "$HOME/.vnc/xstartup" ]] && rm -rf "$HOME/.vnc/xstartup"

    wget -q --show-progress https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/xstartup
    mv -f xstartup $HOME/.vnc/xstartup
    chmod +x $HOME/.vnc/xstartup

    [[ -e "/usr/local/bin/vncstart" ]] && rm -rf /usr/local/bin/vncstart

    wget -q --show-progress https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstart
    mv -f vncstart /usr/local/bin/vncstart
    chmod +x /usr/local/bin/vncstart

    [[ -e "/usr/local/bin/vncstop" ]] && rm -rf /usr/local/bin/vncstop

    wget -q --show-progress https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstop
    mv -f vncstop /usr/local/bin/vncstop
    chmod +x /usr/local/bin/vncstop

    echo "export DISPLAY=":1"" >> /etc/profile
    echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile 
    source /etc/profile

}

note() {
    banner
    echo -e " ${G} Successfully Installed !"${W}
    sleep 1
    echo
    echo -e " ${G}Type ${C}vncstart${G} to run Vncserver."${W}
    echo -e " ${G}Type ${C}vncstop${G} to stop Vncserver."${W}
    echo
    echo -e " ${C}Install VNC VIEWER Apk on your Device."${W}
    echo
    echo -e " ${C}Open VNC VIEWER & Click on + Button."${W}
    echo
    echo -e " ${C}Enter the Address localhost:1 & Name anything you like."${W}
    echo
    echo -e " ${C}Set the Picture Quality to High for better Quality."${W}
    echo
    echo -e " ${C}Click on Connect & Input the Password."${W}
    echo
    echo -e " ${C}Enjoy :D"${W}
    echo
    echo

}

add_sound() {
	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/ubuntu)" > /data/data/com.termux/files/usr/bin/ubuntu

}

config_ubuntu() {
	banner
	cd ~/

	wget -q --show-progress https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/fonts.tar.gz
	mkdir -pv ~/.fonts
	tar -xvzf fonts.tar.gz -C ~/

	wget -q --show-progress https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz
	tar -xvzf ubuntu-settings.tar.gz -C ~/

	wget -q --show-progress https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/wallpaper.tar.gz
	mv -rf /usr/share/backgrounds/xfce/xfce-verticals.png  /usr/share/backgrounds/xfce/xfceverticals-old.png
	tar -xvzf wallpaper.tar.gz -C /usr/share/backgrounds/xfce/
	
}

clenup() {
	clear
	banner
	echo "Cleaning up system.."
	echo
	apt update
	apt upgrade -y
	apt autoremove -y
	rm -rf $HOME/WhiteSur-gtk-theme $HOME/WhiteSur-icon-theme $HOME/Layan-gtk-theme $HOME/Nordzy-cursors ~/*.tar.gz
}

package
extra_things
#browser_installer
#ide_installer
#video_player_installer
#chromium
#theme
#font
refs
add_sound
config_ubuntu
clenup
vnc
note
