echo "Installing Xtradeb first"
wget -qO- https://raw.githubusercontent.com/Superchavo/modded-ubuntu-patching/refs/heads/test-ubuntu-26.04/distro/setup_xtradeb.sh | bash
echo "now installing chromium"
apt update
apt install chromium
echo "Ready!! now lets return to the main installation"

