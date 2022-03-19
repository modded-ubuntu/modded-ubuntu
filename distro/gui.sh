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
    packs=(sudo wget curl nano git keyboard-configuration tzdata xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common dbus-x11 fonts-beng fonts-beng-extra vlc gtk2-engines-murrine gtk2-engines-pixbuf)
    for hulu in "${packs[@]}"; do
        type -p "$hulu" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Installing package : ${Y}$hulu${C}"${W}
            sudo apt-get install "$hulu" -y --no-install-recommends
        }
    done
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get clean
}

chromium() {
    banner
    echo -e "${R} [${W}-${R}]${C} Uninstalling OLD chromium..."${W}
    chrome=(chromium* chromium-browser* snapd)
    for hula in "${chrome[@]}"; do
        type -p "$hula" &>/dev/null || {
            echo -e "\n${R} [${W}-${R}]${G} Purging package : ${Y}$hula${C}"${W}
            apt purge "$hula" -y && apt autoremove -y
            sudo apt purge "$hula" -y && sudo apt autoremove -y
        }
    done
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install software-properties-common gnupg --no-install-recommends -y
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
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt install apt-transport-https -y
    sudo apt update -y
    sudo apt install code -y
}
sublime_installer() {
	banner
	echo 
	echo "installing Sublime Text Editor.."
	echo
	sudo apt install  software-properties-common gnupg --no-install-recommends -y
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
		sublime_installer
		vscode_installer
	elif [[ ${selected_ide} == "" ]]; then
		sublime_installer
	else
		sublime_installer
	fi
}

refs() {
    sudo apt-get update -y
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
    sudo apt-get upgrade -y
    sudo apt autoremove -y
	sudo apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin -y 
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
	sudo bash $HOME/WhiteSur-icon-theme/install.sh -b
	

    git clone --depth=1 https://github.com/vinceliuice/Qogir-icon-theme.git $HOME/Qogir-icon-theme
    sudo chmod +x $HOME/Qogir-icon-theme/install.sh
    sudo bash $HOME/Qogir-icon-theme/install.sh

    git clone --depth=1 https://github.com/s-h-3-l-l/katoolin3.git $HOME/katoolin3
    sudo chmod +x $HOME/katoolin3/install.sh
    cd $HOME/katoolin3 && sudo bash install.sh

    sudo apt update -y
    sudo apt autoremove -y

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
package
browser_installer
ide_installer
#chromium
#theme
font
refs
add_sound
vnc
note
