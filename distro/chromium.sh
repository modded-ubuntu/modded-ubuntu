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
	
	# Clean up previous PPA/Debian configurations
	rm -f /etc/apt/sources.list.d/xtradeb.list
	rm -f /etc/apt/sources.list.d/debian-chromium.list
	rm -f /etc/apt/trusted.gpg.d/xtradeb.gpg
	rm -f /etc/apt/keyrings/xtradeb.gpg
	rm -f /etc/apt/preferences.d/debian-chromium
	
	# Detect OS codename
	CODENAME=$(lsb_release -sc 2>/dev/null || grep -oP '(?<=VERSION_CODENAME=)[a-z]+' /etc/os-release 2>/dev/null || echo "noble")

	# If the OS is Resolute (Ubuntu 26.04) or newer, packages from xtradeb (built for Noble/24.04)
	# cannot be installed due to library name/abi mismatch (e.g. libflac12t64 vs libflac14, libopenh264-7 vs libopenh264-8).
	# To solve this, we add Debian Testing (Trixie) repository specifically pinned for Chromium.
	if [ "$CODENAME" = "resolute" ] || [ "$CODENAME" = "plucky" ]; then
		echo -e "${Y}Ubuntu 26.04+ (Resolute/Plucky) detected.${W}"
		echo -e "${Y}Setting up Debian Testing (Trixie) repository for native Chromium...${W}"
		
		# Create keyring directory
		install -d -m 0755 /etc/apt/keyrings
		
		# Import Debian Testing archive public keys via curl to avoid PRoot dirmngr/gpg keyserver issues
		rm -f /etc/apt/keyrings/debian-archive.gpg
		for key in 6ED0E7B82643E131 78DBA3BC47EF2265 762F67A0B2C39DE4; do
			curl -sS "https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search=0x${key}" | gpg --dearmor >> /etc/apt/keyrings/debian-archive.gpg
		done
		
		# Add Debian Testing repository
		echo "deb [signed-by=/etc/apt/keyrings/debian-archive.gpg] http://deb.debian.org/debian trixie main" > /etc/apt/sources.list.d/debian-chromium.list
		
		# Pin Chromium packages to Debian, and everything else to a low priority (100) to prevent upgrading Ubuntu base libraries
		cat << 'EOF' > /etc/apt/preferences.d/debian-chromium
Package: chromium chromium-common chromium-sandbox chromium-driver chromium-shell chromium-headless-shell
Pin: origin deb.debian.org
Pin-Priority: 900

Package: *
Pin: origin deb.debian.org
Pin-Priority: 100
EOF
	else
		# Create keyring directory
		install -d -m 0755 /etc/apt/keyrings
		
		# Add the xtradeb key
		curl -sS "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x82BB6851C64F6880" | gpg --dearmor > /etc/apt/keyrings/xtradeb.gpg
		
		# Use xtradeb PPA, fallback to noble if detected version is not supported yet
		if ! curl -sI "https://ppa.launchpadcontent.net/xtradeb/apps/ubuntu/dists/${CODENAME}/Release" | grep -q "200 OK"; then
			CODENAME="noble"
		fi
		echo "deb [signed-by=/etc/apt/keyrings/xtradeb.gpg] http://ppa.launchpad.net/xtradeb/apps/ubuntu ${CODENAME} main" > /etc/apt/sources.list.d/xtradeb.list
	fi
	
	apt-get update -y
	apt-get install -y chromium || {
		echo -e "${R} [!] Failed to install Chromium.${W}\n"
		exit 1
	}
	
	# Create shim to force --no-sandbox
	cat << 'EOF' > /usr/local/bin/chromium
#!/bin/sh
exec /usr/bin/chromium --no-sandbox "$@"
EOF
	chmod +x /usr/local/bin/chromium

	# Apply sandbox flags to desktop files if they exist
	for df in /usr/share/applications/*chromium*.desktop; do
		if [ -f "$df" ]; then
			sed -i 's/chromium %U/chromium --no-sandbox %U/g' "$df"
			sed -i 's/chromium-browser %U/chromium-browser --no-sandbox %U/g' "$df"
		fi
	done
	echo -e "${G} Chromium Installed Successfully\n${W}"
}
