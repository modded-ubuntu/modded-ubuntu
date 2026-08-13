#!/bin/bash

# Logging
LOG_FILE="/var/log/tools_installation.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "[+] Logging to $LOG_FILE"

# Color Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Error Handling
handle_error() {
  echo -e "${RED}[-] Error: $1${NC}"
  exit 1
}

display_banner() {
  echo -e "${GREEN}=============================================${NC}"
  echo -e "${CYAN}  Linux Tools Installation Script            ${NC}"
  echo -e "${MAGENTA}        Coded by LIONMAD                    ${NC}"
  echo -e "${MAGENTA}         Credit to BDhackers009                ${NC}"
  echo -e "${GREEN}=============================================${NC}"
  echo ""
  echo -e "${YELLOW}[+] Welcome to the Interactive Tool Installation Script${NC}"
  echo -e "${YELLOW}[+] This script will help you install various security and utility tools.${NC}"
  echo -e "${YELLOW}[+] Please follow the prompts to select the tools you want to install.${NC}"
  echo ""
}

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}[-] This script must be run as root.${NC}"
  exec sudo "$0" "$@"
  exit 1
fi

# Detect Linux Distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    echo "$DISTRIB_ID"
  elif [ -f /etc/debian_version ]; then
    echo "debian"
  elif [ -f /etc/redhat-release ]; then
    echo "rhel"
  elif [ -f /etc/arch-release ]; then
    echo "arch"
  else
    echo "unknown"
  fi
}

# Detect Package Manager Based on Distro
detect_package_manager() {
  local distro=$1
  case $distro in
    ubuntu | debian | kali)
      echo "apt"
      ;;
    arch | manjaro)
      echo "pacman"
      ;;
    fedora | centos | rhel | rocky | alma)
      if command -v dnf &>/dev/null; then
        echo "dnf"
      else
        echo "yum"
      fi
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

DISTRO=$(detect_distro)
PACKAGE_MANAGER=$(detect_package_manager "$DISTRO")

if [ "$PACKAGE_MANAGER" == "unknown" ]; then
  handle_error "Unsupported Linux distribution. Exiting..."
fi

echo -e "${GREEN}[+] Detected Distribution: $DISTRO${NC}"
echo -e "${GREEN}[+] Using Package Manager: $PACKAGE_MANAGER${NC}"

# Update system packages
update_system() {
  echo -e "${YELLOW}[+] Updating system packages...${NC}"
  case $PACKAGE_MANAGER in
    apt)
      apt update && apt upgrade -y || handle_error "Failed to update system packages."
      ;;
    pacman)
      pacman -Syu --noconfirm || handle_error "Failed to update system packages."
      ;;
    yum)
      yum update -y || handle_error "Failed to update system packages."
      ;;
    dnf)
      dnf update -y || handle_error "Failed to update system packages."
      ;;
  esac
  echo -e "${GREEN}[+] System packages updated successfully.${NC}"
}

# Install a package with the detected package manager
install_package() {
  local package=$1
  echo -n "[+] Installing $package..."
  case $PACKAGE_MANAGER in
    apt)
      if apt install -y "$package"; then
        echo -e "${GREEN} Done.${NC}"
      else
        echo -e "${RED} Failed.${NC}"
        return 1
      fi
      ;;
    pacman)
      if pacman -S --noconfirm "$package"; then
        echo -e "${GREEN} Done.${NC}"
      else
        echo -e "${RED} Failed.${NC}"
        return 1
      fi
      ;;
    yum)
      if yum install -y "$package"; then
        echo -e "${GREEN} Done.${NC}"
      else
        echo -e "${RED} Failed.${NC}"
        return 1
      fi
      ;;
    dnf)
      if dnf install -y "$package"; then
        echo -e "${GREEN} Done.${NC}"
      else
        echo -e "${RED} Failed.${NC}"
        return 1
      fi
      ;;
  esac
}

# Interactive Mode
interactive_mode() {
  display_banner

  # Update system
  read -p "Do you want to update the system packages? (y/n): " update_system_choice
  if [[ "$update_system_choice" == "y" ]]; then
    update_system
  else
    echo -e "${YELLOW}[+] Skipping system update.${NC}"
  fi

  # Essential Dependencies
  read -p "Do you want to install Essential Dependencies? (y/n): " install_essential
  if [[ "$install_essential" == "y" ]]; then
    ESSENTIAL_PACKAGES="build-essential python3-pip python3-dev git curl wget"
    for pkg in $ESSENTIAL_PACKAGES; do
      install_package "$pkg"
    done
  fi

  # Network Tools
  read -p "Do you want to install Network Tools? (y/n): " install_network
  if [[ "$install_network" == "y" ]]; then
    NETWORK_TOOLS="nmap ncat ndiff zenmap wireshark tshark tcpdump netcat-traditional ettercap-common arpwatch"
    for tool in $NETWORK_TOOLS; do
      install_package "$tool"
    done
  fi

  # Web Application Testing Tools
  read -p "Do you want to install Web Application Testing Tools? (y/n): " install_web
  if [[ "$install_web" == "y" ]]; then
    WEB_TOOLS="gobuster ffuf wpscan nikto"
    for tool in $WEB_TOOLS; do
      install_package "$tool"
    done
  fi

  # Penetration Testing Tools
  read -p "Do you want to install Penetration Testing Tools? (y/n): " install_pen_test
  if [[ "$install_pen_test" == "y" ]]; then
    PEN_TEST_TOOLS="metasploit-framework aircrack-ng bettercap beef-xss"
    for tool in $PEN_TEST_TOOLS; do
      install_package "$tool"
    done
  fi

  # Vulnerability Analysis Tools
  read -p "Do you want to install Vulnerability Analysis Tools? (y/n): " install_vuln
  if [[ "$install_vuln" == "y" ]]; then
    VULN_TOOLS="hydra sqlmap rkhunter chkrootkit lynis"
    for tool in $VULN_TOOLS; do
      install_package "$tool"
    done
  fi

  # Information Gathering Tools
  read -p "Do you want to install Information Gathering Tools? (y/n): " install_info
  if [[ "$install_info" == "y" ]]; then
    INFO_TOOLS="theharvester cewl dnsrecon dnsenum amass subfinder"
    for tool in $INFO_TOOLS; do
      install_package "$tool"
    done
  fi

  # Password Cracking Tools
  read -p "Do you want to install Password Cracking Tools? (y/n): " install_password
  if [[ "$install_password" == "y" ]]; then
    PASSWORD_TOOLS="john hashcat crunch"
    for tool in $PASSWORD_TOOLS; do
      install_package "$tool"
    done
  fi

  # Exploitation Tools
  read -p "Do you want to install Exploitation Tools? (y/n): " install_exploit
  if [[ "$install_exploit" == "y" ]]; then
    EXPLOIT_TOOLS="responder evil-winrm mimikatz powershell-empire"
    for tool in $EXPLOIT_TOOLS; do
      install_package "$tool"
    done
  fi

  # Miscellaneous Tools
  read -p "Do you want to install Miscellaneous Tools? (y/n): " install_misc
  if [[ "$install_misc" == "y" ]]; then
    MISC_TOOLS="burpsuite yara fcrackzip dirbuster spiderfoot masscan"
    for tool in $MISC_TOOLS; do
      install_package "$tool"
    done
  fi

  # Additional Tools
  read -p "Do you want to install Additional Tools? (y/n): " install_additional
  if [[ "$install_additional" == "y" ]]; then
    ADDITIONAL_TOOLS="recon-ng maltego sublist3r massdns dirsearch scapy feroxbuster wfuzz"
    for tool in $ADDITIONAL_TOOLS; do
      install_package "$tool"
    done
  fi

  # Install Metasploit Framework
  read -p "Do you want to install Metasploit Framework? (y/n): " install_metasploit
  if [[ "$install_metasploit" == "y" ]]; then
    if command -v curl &>/dev/null; then
      echo "[+] Installing Metasploit Framework..."
      curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
      chmod 755 msfinstall && ./msfinstall || handle_error "Failed to install Metasploit Framework."
    else
      echo "[-] curl is not installed. Skipping Metasploit installation."
    fi
  fi

  # Cleanup unnecessary packages
  read -p "Do you want to clean up unnecessary packages? (y/n): " cleanup_choice
  if [[ "$cleanup_choice" == "y" ]]; then
    echo "[+] Cleaning up unnecessary packages..."
    case $PACKAGE_MANAGER in
      apt)
        apt autoremove -y || handle_error "Failed to clean up unnecessary packages."
        ;;
      pacman)
        pacman -Rns $(pacman -Qdtq) --noconfirm || handle_error "Failed to clean up unnecessary packages."
        ;;
      yum | dnf)
        echo "[+] Skipping cleanup for $PACKAGE_MANAGER as it doesn't require additional commands."
        ;;
    esac
    echo -e "${GREEN}[+] Cleanup complete.${NC}"
  else
    echo -e "${YELLOW}[+] Skipping cleanup.${NC}"
  fi

  # Final message
  echo -e "${GREEN}[+] Installation complete! All selected tools are installed successfully.${NC}"
  echo -e "${GREEN}[+] You may want to restart your system for all changes to take effect.${NC}"
}

# Main Script Logic
interactive_mode
