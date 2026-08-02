#!/bin/bash
set -e

echo "Installing Xtradeb first"
if wget -qO- https://raw.githubusercontent.com/superchavo/modded-ubuntu-patching/refs/heads/test-ubuntu-26.04/distro/setup_xtradeb.sh | bash; then
    echo "✓ XtraDeb repository setup completed"
else
    echo "✗ Failed to setup XtraDeb repository"
    exit 1
fi

echo ""
echo "Now installing chromium"
apt update
if apt install -y chromium; then
    echo "✓ Chromium installed successfully"
else
    echo "✗ Failed to install Chromium"
    exit 1
fi

# Create shim to force --no-sandbox (required for PRoot/Termux)
echo "Setting up chromium sandbox shim..."
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

echo ""
echo "✓ Chromium setup completed successfully!"
echo "Setup details saved to /tmp/xtradeb_install.log"
