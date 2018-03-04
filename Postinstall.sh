#!/bin/bash             
echo "-------------------------------"
echo "Running Post Install Script"
echo "-------------------------------"
echo "-------------------------------"
echo "Removing unwanted packages"
echo "-------------------------------"
#removing unwanted packages
rm /usr/share/applications/ubuntu-amazon-default.desktop
rm /usr/share/unity-webapps/userscripts/unity-webapps-amazon/Amazon.user.js
rm /usr/share/unity-webapps/userscripts/unity-webapps-amazon/manifest.json
apt-get remove -y transmission-cli transmission-common transmission-daemon
echo "-------------------------------"
echo "Getting Gopro packages"
echo "-------------------------------"
#creating local directory
mkdir /home/goproadmin/PostInstall/
#getting Sentinelone package
wget http://**.**.**.**/ub16.04/goprosecurity/SentinelOne_linux_v2_0_5_1124.bsx -O /home/goproadmin/PostInstall/SentinelOne.bsx
chmod +x /home/goproadmin/PostInstall/SentinelOne.bsx
#getting final install script
wget http://**.**.**.**/ub16.04/goprosecurity/userscriptnopbis.sh -O /home/goproadmin/PostInstall/userscriptnopbis.sh
chmod +x /home/goproadmin/PostInstall/userscriptnopbis.sh
echo "-------------------------------"
echo "Installing GFX drivers"
echo "-------------------------------"
ubuntu-drivers autoinstall
#install Salt Minion
curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh -A **.**.**.***
#Fix plymouth and kernel issues for 4.4.0-112
apt-get -y install --reinstall linux-image-4.4.0-112-generic
apt-get -y install plymouth plymouth-themes
plymouth-set-default-theme -R glow
update-initramfs -u