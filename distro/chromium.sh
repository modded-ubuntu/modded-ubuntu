#!/bin/bash
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"

[[ $(command -v chromium) ]] && echo -e "${Y}Chromium is already Installed!${W}\n" || {
	echo -e "${G}Installing ${Y}Chromium${W}"
	# Quote wildcards to prevent bash glob expansion in the working directory
	apt purge "chromium*" "chromium-browser*" snapd -y
	apt install gnupg2 curl software-properties-common --no-install-recommends -y
	
	# Clean up previous PPA configurations
	rm -f /etc/apt/sources.list.d/xtradeb.list
	rm -f /etc/apt/trusted.gpg.d/xtradeb.gpg
	
	# Create keyring directory
	install -d -m 0755 /etc/apt/keyrings
	
	# Add the xtradeb key
	curl -sS "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x82BB6851C64F6880" | gpg --dearmor > /etc/apt/keyrings/xtradeb.gpg
	
	# Detect OS codename, fallback to noble (Ubuntu 24.04 LTS) if the PPA doesn't support the current release yet
	CODENAME=$(lsb_release -sc 2>/dev/null || grep -oP '(?<=VERSION_CODENAME=)[a-z]+' /etc/os-release 2>/dev/null || echo "noble")
	if ! curl -sI "https://ppa.launchpadcontent.net/xtradeb/apps/ubuntu/dists/${CODENAME}/Release" | grep -q "200 OK"; then
		CODENAME="noble"
	fi
	
	echo "deb [signed-by=/etc/apt/keyrings/xtradeb.gpg] http://ppa.launchpad.net/xtradeb/apps/ubuntu ${CODENAME} main" > /etc/apt/sources.list.d/xtradeb.list
	
	apt-get update -y
	apt-get install -y chromium
	
	# Create shim to force --no-sandbox
	cat << 'EOF' > /usr/local/bin/chromium
#!/bin/sh
exec /usr/bin/chromium --no-sandbox "$@"
EOF
	chmod +x /usr/local/bin/chromium

	# Apply sandbox flags to desktop files if they exist
	if [ -f /usr/share/applications/chromium.desktop ]; then
		sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/chromium.desktop
	elif [ -f /usr/share/applications/chromium-browser.desktop ]; then
		sed -i 's/chromium-browser %U/chromium-browser --no-sandbox %U/g' /usr/share/applications/chromium-browser.desktop
	fi
	echo -e "${G} Chromium Installed Successfully\n${W}"
}
