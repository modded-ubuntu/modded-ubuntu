#!/bin/bash
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"

[[ $(command -v chromium) ]] && echo -e "${Y}Chromium is already Installed!${W}\n" || {
	echo -e "${G}Installing ${Y}Chromium${W}"
	apt purge chromium* chromium-browser* snapd -y
	apt install gnupg2 software-properties-common --no-install-recommends -y
	
	# Add the xtradeb key and force the PPA to use jammy
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BB4553A04231E126
	echo "deb http://ppa.launchpad.net/xtradeb/apps/ubuntu jammy main" > /etc/apt/sources.list.d/xtradeb.list
	
	apt-get update -y
	apt-get install -y chromium
	sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop
	echo -e "${G} Chromium Installed Successfully\n${W}"
}
