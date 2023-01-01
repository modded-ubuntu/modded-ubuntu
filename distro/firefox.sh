if [[ `command -v snap` ]]; then
	sudo snap remove firefox
else 
	echo ""
fi

echo "deb https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/mozillateam-ubuntu-ppa-jammy.list
#sudo add-apt-repository ppa:mozillateam/ppa
#expect -c 'spawn sudo add-apt-repository ppa:mozillateam/ppa; send "\r"; expect eof'
curl https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu/test/distro/firefox.key -o ./firefox.key
sudo apt-key add ./firefox.key

sleep 0.4

echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

sudo apt install firefox -y

sudo rm -rf ./firefox.key 