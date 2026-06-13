#!/bin/bash
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"

[[ $(command -v snap) ]] && snap remove firefox

# Ensure gpg and curl are installed
apt-get install -y gnupg2 curl

# Clean up previous PPA configurations
rm -f /etc/apt/sources.list.d/mozillateam.list
rm -f /etc/apt/preferences.d/mozilla-firefox
rm -f /etc/apt/trusted.gpg.d/firefox.gpg

# Create keyring directory
install -d -m 0755 /etc/apt/keyrings

# Download official Mozilla signing key
curl -sS https://packages.mozilla.org/apt/repo-signing-key.gpg | gpg --dearmor > /etc/apt/keyrings/packages.mozilla.org.gpg

# Add the official repository
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list

# Create the apt preference pin to bypass the transitional snap packages
PREFFILE="/etc/apt/preferences.d/mozilla"
mkdir -p /etc/apt/preferences.d/
cat > "$PREFFILE" <<EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

# Update and install
apt-get update
apt-get install -y firefox --no-install-recommends

# Create shim to force --no-sandbox
cat << 'EOF' > /usr/local/bin/firefox
#!/bin/sh
exec /usr/bin/firefox --no-sandbox "$@"
EOF
chmod +x /usr/local/bin/firefox
