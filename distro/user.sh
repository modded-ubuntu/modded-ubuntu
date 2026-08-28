#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
export DEBIAN_FRONTEND=noninteractive

banner() {
    clear
    printf "\033[33m    _  _ ___  _  _ _  _ ___ _  _    _  _ ____ ___  \033[0m\n"
    printf "\033[36m    |  | |__] |  | |\ |  |  |  |    |\/| |  | |  \ \033[0m\n"
    printf "\033[32m    |__| |__] |__| | \|  |  |__|    |  | |__| |__/ \033[0m\n"
    printf "\033[0m\n"
    printf "     \033[32mA modded gui version of ubuntu for Termux\033[0m\n"
    printf "                 \033[33mVersion : \033[32m2.0\033[0m\n\n"
}

sudo_install() {
    export DEBIAN_FRONTEND=noninteractive
    echo -e "\n${R} [${W}-${R}]${C} Installing Sudo...${W}"
    # wait, WHY DO I NEED SUDO
    apt-get update -y
    apt-get install -y sudo wget apt-utils locales-all dialog tzdata
    if [ -f /etc/timezone ]; then
        ln -fs /usr/share/zoneinfo/$(cat /etc/timezone) /etc/localtime
    fi
    echo -e "\n${R} [${W}-${R}]${G} Sudo Successfully Installed !${W}"
}

login() {
    banner

    # Prompt for username and password (safer reads)
    read -r -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m' user
    echo
    read -r -s -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m' pass
    echo -e "${W}"

    # Basic validation
    if [ -z "${user}" ] || [ -z "${pass}" ]; then
        echo -e "${R} [${W}-${R}]${C} Username and password must not be empty. Exiting.${W}"
        exit 1
    fi

    # Find a valid shell; fall back to /bin/sh if bash not found
    SHELL_PATH="$(command -v bash || command -v sh || true)"
    if [ -z "${SHELL_PATH}" ]; then
        echo -e "${R} [${W}-${R}]${C} No usable shell found (bash/sh). Exiting.${W}"
        # wait, if theres no shell, then how did you execute this........
        exit 1
    fi

    useradd -m -s "${SHELL_PATH}" "${user}" || true
    usermod -aG sudo "${user}" || true

    # Set password (using chpasswd); guard against special chars
    printf '%s:%s\n' "${user}" "${pass}" | chpasswd

    # Grant passwordless sudo via sudoers.d
    printf '%s ALL=(ALL:ALL) NOPASSWD:ALL\n' "${user}" > /etc/sudoers.d/90-modded-ubuntu
    chmod 0440 /etc/sudoers.d/90-modded-ubuntu

    # Create Termux wrapper if Termux path exists
    TERMUX_BIN_DIR="/data/data/com.termux/files/usr/bin"
    if [ -d "${TERMUX_BIN_DIR}" ]; then
        mkdir -p "${TERMUX_BIN_DIR}"
        cat <<EOF > "${TERMUX_BIN_DIR}/ubuntu"
#!/data/data/com.termux/files/usr/bin/sh
exec proot-distro login --user "${user}" ubuntu --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports
EOF
        chmod +x "${TERMUX_BIN_DIR}/ubuntu"
    else
        echo -e "${Y} [!] Termux bin path ${TERMUX_BIN_DIR} not found; skipping wrapper creation.${W}"
    fi

    # Prepare user's home softwares and copy or download helper scripts
    mkdir -p "/home/${user}/softwares"
    if [[ -d '/data/data/com.termux/files/home/modded-ubuntu/distro' ]]; then
        cp /data/data/com.termux/files/home/modded-ubuntu/distro/gui.sh /home/"${user}"/gui.sh
        chmod +x /home/"${user}"/gui.sh
        cp -f /data/data/com.termux/files/home/modded-ubuntu/distro/firefox.sh /home/"${user}"/softwares/
        cp -f /data/data/com.termux/files/home/modded-ubuntu/distro/chromium.sh /home/"${user}"/softwares/
        cp -f /data/data/com.termux/files/home/modded-ubuntu/distro/vscode.sh /home/"${user}"/softwares/
        cp -f /data/data/com.termux/files/home/modded-ubuntu/distro/sublime.sh /home/"${user}"/softwares/
        chmod +x /home/"${user}"/softwares/*.sh || true
    else
        wget -q --show-progress https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/gui.sh -O /home/"${user}"/gui.sh
        chmod +x /home/"${user}"/gui.sh || true

        wget -q -P /home/"${user}"/softwares/ https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/firefox.sh
        wget -q -P /home/"${user}"/softwares/ https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/chromium.sh
        wget -q -P /home/"${user}"/softwares/ https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/vscode.sh
        wget -q -P /home/"${user}"/softwares/ https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/sublime.sh
        chmod +x /home/"${user}"/softwares/*.sh || true
    fi

    clear
    echo
    echo -e "\n${R} [${W}-${R}]${G} Restart your Termux & Type ${C}ubuntu${W}"
    echo -e "\n${R} [${W}-${R}]${G} Then Type ${C}sudo bash gui.sh ${W}"
    echo
}

# if you found this, you have too much free time
# also down is somethings that idk
banner
sudo_install
login
