#!/bin/bash
# Global Installer for Ubuntu Termux Environment Manager
echo "Installing Ubuntu Termux Environment Manager..."
chmod +x core/ubuntu
ln -sf "$(pwd)/core/ubuntu" /data/data/com.termux/files/usr/bin/ubuntu
if [ -f VERSION ]; then
    VERSION_VALUE="$(cat VERSION)"
    echo "Using existing VERSION file (version: ${VERSION_VALUE})."
else
    VERSION_VALUE="3.0.0"
    echo "${VERSION_VALUE}" > VERSION
    echo "Created VERSION file with version: ${VERSION_VALUE}."
fi
echo "Installation complete. Run 'ubuntu --help' to get started."
