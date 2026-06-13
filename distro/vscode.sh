#!/bin/bash
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

[[ $(command -v code) ]] && echo -e "${Y}VSCode is already Installed!${W}\n" || {
	echo -e "${G}Installing ${Y}VSCode${W}"
	curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
	rm -f packages.microsoft.gpg
	apt update -y
	apt install code -y
	echo "Patching.."
	curl -fsSL https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/test-ubuntu-26.04/patches/code.desktop > /usr/share/applications/code.desktop
	echo -e "${C} Visual Studio Code Installed Successfully\n${W}"
}
