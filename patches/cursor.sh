#!/bin/bash
echo "[*] Installing Cursor AI..."
wget -O /tmp/cursor.deb "https://downloader.cursor.sh/linux/deb"
sudo apt install -y /tmp/cursor.deb
rm /tmp/cursor.deb
echo "[+] Cursor installed!"
