#!/bin/bash

# DO NOT REMOVE THIS LINE
# It makes the ducks happy

# ima add some color in here
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
arch=$(uname -m)
if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
	username="$SUDO_USER"
else
	username=$(ls /home | grep -Ev 'ubuntu|lost\+found' | head -n 1)
	username=${username:-ubuntu}
fi

# bad things happen if u run things with root but u can trust this one
check_root(){
	if [ "$(id -u)" -ne 0 ]; then
		echo -ne " ${R}Run this program as root!\n\n"${W}
		echo -ne "  Run ${G}'sudo bash gui.sh'${W}\n\n"
		echo -ne "\n Note: you don't need to have an actual rooted device or a custom rom.\n\n"${W}
		# oh why did i just execute the thing without sudo, welp lol
		exit 1
	fi
}

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
	apt update
	apt --fix-broken install
	dpkg --configure -a
	apt-mark hold udisks2
	
	packs=(sudo gnupg2 curl nano git xz-utils at-spi2-core xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc tigervnc-tools)
	for hulu in "${packs[@]}"; do
		type -p "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Installing package: ${Y}$hulu${W}"
			apt-get install "$hulu" -y --no-install-recommends
		}
	done
	
	echo -e "\n${R} [${W}-${R}]${C} Package Install Completed!\n"${W}
	}

install_apt() {
	for apt in "$@"; do
		[[ `command -v "$apt"` ]] && echo "${Y}${apt} is already Installed!${W}" || {
			echo -e "${G}Installing ${Y}${apt}${W}"
			apt install -y "${apt}"
		}
	done
}

run_script() {
	script_name="$1"
	if [[ -f "/home/$username/softwares/$script_name" ]]; then
		bash "/home/$username/softwares/$script_name"
	else
		bash <(curl -fsSL "https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/$script_name")
	fi
}

install_softwares() {
	cat <<- EOF
		${Y} ---${G} Select Browser ${Y}---

		${C} [${W}1${C}] Firefox (Default)
		${C} [${W}2${C}] Chromium
		${C} [${W}3${C}] Both (Firefox + Chromium)
		${C} [${W}4${C}] Skip!

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" BROWSER_OPTION
	banner

	[[ ("$arch" != 'armhf') && ("$arch" != *'armv7'*) ]] && {
		cat <<- EOF
			${Y} ---${G} Select IDE ${Y}---

			${C} [${W}1${C}] Sublime Text
			${C} [${W}2${C}] Visual Studio Code
			${C} [${W}3${C}] Both (Sublime + VSCode)
			${C} [${W}4${C}] Skip!

		EOF
		read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" IDE_OPTION
		banner
	}

	cat <<- EOF
		${Y} ---${G} Select Media Player ${Y}---

		${C} [${W}1${C}] VLC
		${C} [${W}2${C}] MPV
		${C} [${W}3${C}] Both (VLC + MPV)
		${C} [${W}4${C}] Skip!

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} Select an Option: ${G}" PLAYER_OPTION
	{ banner; sleep 1; }

	if [[ ${BROWSER_OPTION} == 1 ]] || [[ -z ${BROWSER_OPTION} ]]; then
		run_script "firefox.sh"
	elif [[ ${BROWSER_OPTION} == 2 ]]; then
		run_script "chromium.sh"
	elif [[ ${BROWSER_OPTION} == 3 ]]; then
		run_script "firefox.sh"
		run_script "chromium.sh"
	else
		echo -e "${Y} [!] Skipping Browser Installation\n"
		sleep 1
	fi

	[[ ("$arch" != 'armhf') && ("$arch" != *'armv7'*) ]] && {
		if [[ ${IDE_OPTION} == 1 ]]; then
			run_script "sublime.sh"
		elif [[ ${IDE_OPTION} == 2 ]]; then
			run_script "vscode.sh"
		elif [[ ${IDE_OPTION} == 3 ]]; then
			run_script "sublime.sh"
			run_script "vscode.sh"
		else
			echo -e "${Y} [!] Skipping IDE Installation\n"
			sleep 1
		fi
	}

	if [[ ${PLAYER_OPTION} == 1 ]]; then
		install_apt vlc
	elif [[ ${PLAYER_OPTION} == 2 ]]; then
		install_apt mpv
	elif [[ ${PLAYER_OPTION} == 3 ]]; then
		install_apt vlc mpv
	else
		echo -e "${Y} [!] Skipping Media Player Installation\n"
		sleep 1
	fi
}

note() {
	cat <<- EOF

		${R} [${W}-${R}]${G} IMPORTANT NOTICE !

		${Y} -> ${C}If You have Problem with display then use
			 ${R} [${W}-${R}]${G} Vncserver Resolution 1080x700 and other lower resolutions
			 ${R} [${W}-${R}]${G} 1080x1080 or 1080x700 (recommended)

		${Y} -> ${C}And if your keyboard doesn't appears in vnc then download
			 Hacker's keyboard apk from this link:
			 ${Y}https://github.com/klausw/hackerskeyboard/releases

		${Y} -> ${C}If your storage isn't visible then execute this command in termux
			 ${R} [${W}-${R}]${G} termux-setup-storage

		${Y} -> ${C}If this gui script issue is already solved in our new update then execute this
			 ${R} [${W}-${R}]${G} cd ~/modded-ubuntu && git pull
			 ${R} [${W}-${R}]${G} sudo bash gui.sh
	${W}
	EOF
}

downloader(){
	path="$1"
	[[ -e "$path" ]] && rm -rf "$path"
	echo "Downloading $(basename "$1")..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
}

sound_fix() {
	cat <<EOF > /data/data/com.termux/files/usr/bin/ubuntu
#!/data/data/com.termux/files/usr/bin/sh
# Never gonna give you up
# Never gonna let you down
bash ~/.sound
exec proot-distro login --user $username ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports
EOF
	grep -q "export DISPLAY=" /etc/profile || echo 'export DISPLAY=":1"' >> /etc/profile
	grep -q "export PULSE_SERVER=" /etc/profile || echo 'export PULSE_SERVER=127.0.0.1' >> /etc/profile
	source /etc/profile
}

bwrap_fix() {
	echo -e "\n${R} [${W}-${R}]${C} Applying Bubblewrap Sandbox Fix..."${W}
	# i hate bubblewarp in proot, its not letting the apps do anything!
	mkdir -p /usr/local/bin
cat << 'EOF' > /usr/local/bin/bwrap
#!/bin/sh
# oh look, someone is viewing the code! welp, heres a easter egg: Ten feet twenty, the Flower Man
# Is waiting for the touch of his hand
# Straightening petals out without a plan
# Like the every daily
# Wish that bothers the Flower Man
# Could I do something to make him laugh?
# Inside my little chamber made of glass
# So he lived the
# [Chorus]
# Flower Man, Flower Man
# his heart in the sand
# So he stands
# To watch the whole wide world
# .... thats it
# Shim to bypass sandboxing for Termux proot environments
# This ignores all sandbox-related flags and executes the target directly.

while [ $# -gt 0 ]; do
    case "$1" in
        --unshare-all|--die-with-parent|--clearenv|--new-session|--sandbox|--disable-write)
            shift ;;
        --chdir|--dev|--tmpfs|--seccomp|--proc|--dev-bind)
            shift 2 ;;
        --ro-bind|--ro-bind-try|--setenv|--symlink|--bind-try|--bind)
            shift 3 ;;
        *)
            # If we hit a non-flag argument, it's the command to execute
            break ;;
    esac
done

# Execute the actual application command
if [ $# -gt 0 ]; then
    exec "$@"
else
    echo "Error: No command specified" >&2
    exit 1
fi
EOF
	chmod +x /usr/local/bin/bwrap
}

# NOOOO MY THEMES, NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
rem_theme() {
	theme=(Bright Daloa Emacs Moheli Retro Smoke)
	for rmi in "${theme[@]}"; do
		[[ -d "/usr/share/themes/$rmi" ]] && {
			echo "Removing theme: $rmi"
			rm -rf "/usr/share/themes/$rmi"
		}
	done
}

# hicolor? yeah i like hicolor NOOOOO NOT HICOLOR
rem_icon() {
	fonts=(hicolor LoginIcons ubuntu-mono-light)
	for rmf in "${fonts[@]}"; do
		[[ -d "/usr/share/icons/$rmf" ]] && {
			echo "Removing icon: $rmf"
			rm -rf "/usr/share/icons/$rmf"
		}
	done
}

config() {
	banner
	sound_fix
	bwrap_fix

    # ima look up how to add a key to ubuntu.....
	curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3B4FE6ACC0B21F32" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/modded-ubuntu.gpg > /dev/null
	yes | apt upgrade
	yes | apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin
	# hmmmm i might need to move some wallpapers....
	mv -vf /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfceverticals-packaged-one.png
	# wait, why are you still reading all of this?
	if [ ! -f /var/lib/modded-ubuntu-config-done ]; then
		temp_folder=$(mktemp -d -p "$HOME")
		{ banner; sleep 1; cd $temp_folder; }

		echo -e "${R} [${W}-${R}]${C} Downloading Required Files..\n"${W}
		# this might take like 9 minutes lol
		downloader "fonts.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/fonts.tar.gz"
		downloader "icons.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/icons.tar.gz"
		downloader "wallpaper.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
		downloader "gtk-themes.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/gtk-themes.tar.gz"
		downloader "ubuntu-settings.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/ubuntu-settings.tar.gz"

		echo -e "${R} [${W}-${R}]${C} Unpacking Files..\n"${W}
		tar -xvzf fonts.tar.gz -C "/usr/local/share/fonts/"
		tar -xvzf icons.tar.gz -C "/usr/share/icons/"
		tar -xvzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/"
		tar -xvzf gtk-themes.tar.gz -C "/usr/share/themes/"
		tar -xvzf ubuntu-settings.tar.gz -C "/home/$username/"
		rm -fr $temp_folder

		touch /var/lib/modded-ubuntu-config-done
	else
		echo -e "\n${R} [${W}-${R}]${G} Fonts and Themes are already set up. Skipping download..."${W}
		# We are not responsible for any dragons that may appear
		sleep 1
	fi

	echo -e "${R} [${W}-${R}]${C} Purging Unnecessary Files.."${W}
	# oh look, i found trash files
	rem_theme
	rem_icon

	echo -e "${R} [${W}-${R}]${C} Rebuilding Font Cache..\n"${W}
	# If this breaks, blame the cat.
	fc-cache -fv

	echo -e "${R} [${W}-${R}]${C} Upgrading the System..\n"${W}
	# ima update this system bc it might break if theres a mismatch...
	apt update
	yes | apt upgrade
	apt clean
	banner
}

# ----------------------------
# turip, ip ip, turip ip ip ip, turip ip ip ip
check_root
package
install_softwares
config
note
