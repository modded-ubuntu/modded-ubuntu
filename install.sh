#!/bin/bash
# Global Installer for Ubuntu Termux Environment Manager
echo "Installing Ubuntu Termux Environment Manager..."
chmod +x core/ubuntu
ln -sf "$(pwd)/core/ubuntu" /data/data/com.termux/files/usr/bin/ubuntu
echo "1.0.0" > VERSION
echo "Installation complete. Run 'ubuntu --help' to get started."
