#!/bin/bash
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"

[[ $(command -v snap) ]] && snap remove firefox

# Add the key the classic way
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0AB215679C571D1C8325275B9BDB3D89CE49EC21

# Force the PPA to use jammy (most compatible with newer systems)
echo "deb http://ppa.launchpad.net/mozillateam/ppa/ubuntu jammy main" > /etc/apt/sources.list.d/mozillateam.list

# Create the apt preference pin to bypass the transitional snap packages
PREFFILE="/etc/apt/preferences.d/mozilla-firefox"
mkdir -p /etc/apt/preferences.d/
cat > "$PREFFILE" <<EOF
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
EOF

# Update and install
apt-get update
apt-get install -y firefox --no-install-recommends
