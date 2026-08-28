#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
B="$(printf '\033[1;34m')"
C="$(printf '\033[1;36m')"
W="$(printf '\033[1;37m')"

CURR_DIR=$(realpath "$(dirname "$BASH_SOURCE")")
if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]]; then
	UBUNTU_DIR="$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
else
	UBUNTU_DIR="$PREFIX/var/lib/proot-distro/containers/ubuntu/rootfs"
fi

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "                 \033[33mVersion : \033[32m2.0\033[0m\n\n"
}

package() {
	if [[ `command -v pulseaudio` && `command -v proot-distro` ]]; then
		echo ""
		echo -e "\n${R} [${W}-${R}]${G} Packages already installed."${W}
		sleep 1.5
	else
		packs=(pulseaudio proot-distro)
		for x in "${packs[@]}"; do
			type -p "$x" &>/dev/null || {
				echo -e "\n${R} [${W}-${R}]${G} Installing package: ${Y}$x${C}"${W}
				yes | pkg install "$x"
			}
		done
	fi
}

distro() {
	if [[ -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]] || [[ -d "$PREFIX/var/lib/proot-distro/containers/ubuntu" ]]; then
		echo ""
		echo -e "\n${R} [${W}-${R}]${G} Distro already installed."${W}
		sleep 1.5
		exit 0
	else
		echo -e "\n${R} [${W}-${R}]${C} Installing Ubuntu rootfs..."${W}
		proot-distro install ubuntu:26.04
		termux-reload-settings
		echo -e "\n${R} [${W}-${R}]${G} Ubuntu image successfully installed!"${W}
		sleep 2
	fi
}

sound() {
	echo -e "\n${R} [${W}-${R}]${C} Fixing Sound Problem..."${W}
	cat <<EOF > "$HOME/.sound"
pacmd load-module module-aaudio-sink
pulseaudio --start --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
EOF
	sleep 1.5
}

downloader(){
	path="$1"
	[ -e "$path" ] && rm -rf "$path"
	echo "Downloading $(basename "$1")..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
}

setup_vnc() {
	if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstart" ]]; then
		cp -f "$CURR_DIR/distro/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
	else
		downloader "$CURR_DIR/vncstart" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstart"
		mv -f "$CURR_DIR/vncstart" "$UBUNTU_DIR/usr/local/bin/vncstart"
	fi

	if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/vncstop" ]]; then
		cp -f "$CURR_DIR/distro/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
	else
		downloader "$CURR_DIR/vncstop" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vncstop"
		mv -f "$CURR_DIR/vncstop" "$UBUNTU_DIR/usr/local/bin/vncstop"
	fi
	chmod +x "$UBUNTU_DIR/usr/local/bin/vncstart"
	chmod +x "$UBUNTU_DIR/usr/local/bin/vncstop"
}

permission() {
	echo -e "\n${R} [${W}-${R}]${C} Preparing user environment..."${W}
	echo -e "\n${R} [${W}-${R}]${G} This process can take up to 2-5 Minutes"${W}
	echo -e "\n${R} [${W}-${R}]${G} Depending on your internet speed"${W}
	sleep 2

	if [[ -d "$CURR_DIR/distro" ]] && [[ -e "$CURR_DIR/distro/user.sh" ]]; then
		cp -f "$CURR_DIR/distro/user.sh" "$UBUNTU_DIR/root/user.sh"
	else
		downloader "$CURR_DIR/user.sh" "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/user.sh"
		mv -f "$CURR_DIR/user.sh" "$UBUNTU_DIR/root/user.sh"
	fi
	chmod +x "$UBUNTU_DIR/root/user.sh"

	setup_vnc
	[ -f /etc/timezone ] && cp -f /etc/timezone "$UBUNTU_DIR/etc/timezone" || true
	echo "#!$PREFIX/bin/sh" > $PREFIX/bin/ubuntu
	echo "exec proot-distro login ubuntu" >> $PREFIX/bin/ubuntu
	chmod +x "$PREFIX/bin/ubuntu"
	termux-reload-settings

	echo -e "\n${R} [${W}-${R}]${C} Running user configuration script (user.sh)..."${W}
	sleep 2

	# Automatically run user.sh inside container
	proot-distro login ubuntu --shared-tmp -- /bin/bash /root/user.sh

	# Print completion messages AFTER user.sh finishes
	sleep 1.5
	echo -e "\n${R} [${W}-${R}]${G} Setup Successfully Completed!"${W}
	sleep 1
	echo -e "\n${R} [${W}-${R}]${G} Restart your Termux & Type ${C}ubuntu"${W}
	echo -e "\n${R} [${W}-${R}]${G} Then Type ${C}sudo bash gui.sh "${W}\n
}

banner
package
distro
sound
permission
