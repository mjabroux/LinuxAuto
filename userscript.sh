#After image User script by Mikhael Jabroux 10/2017
#!/bin/bash
echo "-------------------------------"
echo "Running Post Install Script - Device will reboot at the end"
echo "-------------------------------"
sleep 5
echo "-------------------------------"
echo "Changing default drive encryption password. Have final user pick it (PLEASE ASK HIM TO REMEMBER THIS)"
echo "-------------------------------"
sudo cryptsetup luksAddKey /dev/nvme0n1p5
echo "-------------------------------"
echo "Setting up AD"
echo "-------------------------------"
sleep 5
#Comment out default NTP pool servers and add Domain Controllers.
sudo sed -e '/pool.ntp.org/s/^/#/g' -i /etc/ntp.conf
sudo echo -e "server time.gopro.lcl\tiburst\tprefer" >> /etc/ntp.conf
echo "-------------------------------"
echo "Replacing krb5.conf"
echo "-------------------------------"
sudo wget http://***********/ub16.04/goprosecurity/krb5.conf -O /etc/krb5.conf
sleep 2
echo "-------------------------------"
echo "Joining machine to domain"
echo "-------------------------------"
sleep 2
echo "please enter an adm- account"
read adminuser
sudo realm --verbose join --user=$adminuser gopro.lcl --install=/
sudo realm list
sleep 5
echo "-------------------------------"
echo "Replacing sssd.conf"
echo "-------------------------------"
sudo wget http://***********/ub16.04/goprosecurity/sssd.conf -O /etc/sssd/sssd.conf
sudo chown root:root /etc/sssd/sssd.conf
sudo chmod 600 /etc/sssd/sssd.conf
sudo service sssd restart
sudo echo -e "session optional pam_mkhomedir.so skel=/etc/skel umask=0077" >> /etc/pam.d/common-session
echo "-------------------------------"
echo "Updating login manager"
echo "-------------------------------"
sudo sh -c "echo 'allow-guest=false' >> /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf"
sudo sh -c "echo 'greeter-show-manual-login=true' >> /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf"
#sudo sh -c "echo 'session [success=ok default=ignore] pam_lsass.so' >> /etc/pam.d/common-session"
sleep 3
echo "-------------------------------"
echo "Building Openconnect from GIT"
echo "-------------------------------"
git clone https://github.com/dlenski/openconnect.git
cd openconnect
git checkout globalprotect
sudo ./autogen.sh
sudo ./configure
sudo make
sudo make install
echo "-------------------------------"
echo "Installing Sentinel One"
echo "-------------------------------"
sudo /home/goproadmin/PostInstall/./SentinelOne.bsx
echo "-------------------------------"
echo "Rebooting now...Please log back in with your user@gopro.lcl"
echo "-------------------------------"
sleep 10
sudo reboot now