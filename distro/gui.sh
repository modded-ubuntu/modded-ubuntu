#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

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
			sudo apt update;sudo apt install firefox -y 
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
		sudo apt update && sudo apt install mpv -y
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
		sudo apt update && sudo apt install vlc -y
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
		echo "installing Firefox browser.."
		echo 
		sudo apt install firefox -y 
	elif [[ ${selected_b} == "2" ]]; then
		clear
		echo "installing Chromium browser.."
		echo
		chromium
	elif [[ ${selected_b} == "3" ]]; then
		clear
		echo "installing Firefox and Chromium browser.."
		echo
		sudo apt install firefox -y 
		chromium
	elif [[ ${selected_b} == "" ]]; then
		clear
		echo "installing Firefox browser.."
		echo 
		sudo apt install firefox -y
	else 
		echo "installing Firefox browser.."
		echo 
		sudo apt install firefox -y
	fi
}
		
package() {
    banner
    echo -e "${R} [${W}-${R}]${C} Checking required packages..."${W}
    sudo apt-get update -y
    sudo apt install udisks2 -y
    sudo rm /var/lib/dpkg/info/udisks2.postinst
    echo "" > /var/lib/dpkg/info/udisks2.postinst
    sudo dpkg --configure -a
    sudo apt-mark hold udisks2
    packs=(sudo wget gnupg2 curl nano git at-spi2-core tzdata xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra  gtk2-engines-murrine gtk2-engines-pixbuf)
    for hulu in "${packs[@]}"; do
        type -p "$hulu" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
            sudo apt-get install "$hulu" -y --no-install-recommends
        }
    done
    sudo apt-get update -y
    sudo apt-get upgrade -y 
}

chromium() {
    banner
    echo -e "${R} [${W}-${R}]${C} Uninstalling OLD chromium..."${W}
    chrome=(chromium* chromium-browser* snapd)
    for hula in "${chrome[@]}"; do
        type -p "$hula" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Purging package : ${Y}$hula${C}"${W}
            apt purge "$hula" -y 
            sudo apt purge "$hula" -y 
        }
    done
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install software-properties-common gnupg2 --no-install-recommends -y
    banner
    echo -e "${R} [${W}-${R}]${C} Installing Chromium..."${W}
    sudo echo "deb http://ftp.debian.org/debian buster main
deb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    sudo apt update -y
    sudo apt install chromium -y
    sudo sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop
    sudo apt-get upgrade -y
}

theme() {
    theme=(Bright Xfce-flat Daloa Xfce-kde2 Xfce-kolors Xfce-4.4 Xfce-light Xfce-4.6 Xfce-orange Emacs Xfce-b5 Xfce-redmondxp Xfce-basic Xfce-saltlake Moheli Xfce-cadmium Xfce-smooth Xfce-curve Xfce-stellar Retro Xfce-dawn Xfce-winter Smoke Xfce-dusk)
    for rmi in "${theme[@]}"; do
        type -p "$rmi" &>/dev/null || {
            sudo rm -rf /usr/share/themes/"$rmi"
        }
    done
}

font() {
    fonts=(hicolor LoginIcons ubuntu-mono-light)
    for rmf in "${fonts[@]}"; do
        type -p "$rmf" &>/dev/null || {
            sudo rm -rf /usr/share/icons/"$rmf"
        }
    done
}

vscode_installer() {
	banner
	echo
	echo "installing Visual Studio Code (vscode).."
	echo
  sudo apt install gnupg2 -y 
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt install apt-transport-https -y
    sudo apt update -y
    sudo apt install code -y
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
  sudo apt install gnupg2 -y
	sudo apt install  software-properties-common gnupg2 --no-install-recommends -y
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-get install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update
	sudo apt-get install sublime-text -y 
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
    sudo apt update && yes | sudo apt install gnupg2
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    sudo apt-get upgrade -y
    sudo apt install gnupg2 gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin -y 
    banner
    echo
    git clone --depth=1 https://github.com/vinceliuice/Layan-gtk-theme.git $HOME/Layan-gtk-theme
    sudo chmod +x $HOME/Layan-gtk-theme/install.sh
    sudo bash $HOME/Layan-gtk-theme/install.sh
	
	git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme $HOME/WhiteSur-gtk-theme
	sudo chmod +x $HOME/WhiteSur-gtk-theme/install.sh
	sudo bash $HOME/WhiteSur-gtk-theme/install.sh
	
	git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme $HOME/WhiteSur-icon-theme
	sudo chmod +x $HOME/WhiteSur-icon-theme/install.sh
	sudo bash $HOME/WhiteSur-icon-theme/install.sh 
	

    git clone --depth=1 https://github.com/vinceliuice/Qogir-icon-theme.git $HOME/Qogir-icon-theme
    sudo chmod +x $HOME/Qogir-icon-theme/install.sh
    sudo bash $HOME/Qogir-icon-theme/install.sh --name ubuntu  

    sudo apt update -y
}

vnc() {
    banner
    echo -e "${R} [${W}-${R}]${C} Setting up VNC Server..."${W}

    if [[ ! -d "$HOME/.vnc" ]]; then
        mkdir -p "$HOME/.vnc"
    fi

    if [[ -e "$HOME/.vnc/xstartup" ]]; then
        rm -rf $HOME/.vnc/xstartup
    fi

    wget https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/xstartup
    mv -f xstartup $HOME/.vnc/xstartup
    chmod +x $HOME/.vnc/xstartup

    if [[ -e "/usr/local/bin/vncstart" ]]; then
        rm -rf /usr/local/bin/vncstart
    fi

    wget https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstart
    mv -f vncstart /usr/local/bin/vncstart
    chmod +x /usr/local/bin/vncstart

    if [[ -e "/usr/local/bin/vncstop" ]]; then
        rm -rf /usr/local/bin/vncstop
    fi

    wget https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstop
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
clenup() {
	clear
	banner
	echo
	echo "Cleaning up system.."
	echo
	sleep 2
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
	sleep 2
	sudo rm -rf $HOME/WhiteSur-gtk-theme $HOME/WhiteSur-icon-theme $HOME/Layan-gtk-theme $HOME/Qogir-icon-theme

}

cng_bg() {
	sudo mv /usr/share/backgrounds/xfce/xfce-verticals.jpg /usr/share/backgrounds/xfce/xfceverticals-old.jpg
	sudo wget -q -P /usr/share/backgrounds/xfce/ -O xfce-verticals.png https://w.wallhaven.cc/full/l3/wallhaven-l3kq9y.png
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
cng_bg
clenup
vnc
note
