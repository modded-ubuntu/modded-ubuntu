echo "Installing Xtradeb first"
wget -qO- https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/refs/heads/test-ubuntu-26.04/distro/setup_xtradeb.sh | bash
echo "Setup details saved to /tmp/xtradeb_install.log"
echo "now installing chromium"
apt update
apt install chromium
cat << 'EOF' > /usr/local/bin/chromium
#!/bin/sh
exec /usr/bin/chromium --no-sandbox "$@"
EOF
chmod +x /usr/local/bin/chromium
echo "Ready!! now lets return to the main installation"

