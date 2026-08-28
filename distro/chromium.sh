#!/bin/bash
set -e

echo "Installing Xtradeb first"
if wget -qO- https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/master/distro/setup_xtradeb.sh | sudo bash; then
    echo "✓ XtraDeb repository setup completed"
else
    echo "✗ Failed to setup XtraDeb repository"
    exit 1
fi

echo ""
echo "Now installing chromium"
sudo apt update
if sudo apt install -y chromium; then
    echo "✓ Chromium installed successfully"
else
    echo "✗ Failed to install Chromium"
    exit 1
fi

# Create shim to force --no-sandbox (required for PRoot/Termux)
echo "Setting up chromium sandbox shim..."
sudo tee /usr/local/bin/chromium > /dev/null << 'EOF'
#!/bin/sh
exec /usr/bin/chromium --no-sandbox "$@"
EOF

sudo chmod +x /usr/local/bin/chromium

# Apply sandbox flags to desktop files if they exist
for df in /usr/share/applications/*chromium*.desktop; do
    if [ -f "$df" ]; then
        sudo sed -i 's/chromium %U/chromium --no-sandbox %U/g' "$df"
        sudo sed -i 's/chromium-browser %U/chromium-browser --no-sandbox %U/g' "$df"
    fi
done

echo ""
echo "✓ Chromium setup completed successfully!"
echo "Setup details saved to /tmp/xtradeb_install.log"
