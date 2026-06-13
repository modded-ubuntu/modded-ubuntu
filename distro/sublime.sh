#!/bin/bash
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

[[ $(command -v subl) ]] && echo -e "${Y}Sublime is already Installed!${W}\n" || {
	echo -e "${G}Installing ${Y}Sublime${W}"
	apt install gnupg2 software-properties-common --no-install-recommends -y
	echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
	curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2> /dev/null
	apt update -y
	apt install sublime-text -y 
	echo -e "${C} Sublime Text Editor Installed Successfully\n${W}"
}
