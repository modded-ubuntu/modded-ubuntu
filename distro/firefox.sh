sudo snap remove firefox
sudo apt install software-properties-common expect -y

#sudo add-apt-repository ppa:mozillateam/ppa
expect -c 'spawn sudo add-apt-repository ppa:mozillateam/ppa; send "\r"; expect eof'

echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

#sudo apt install firefox -y

