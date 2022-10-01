#!/bin/sh
#
#install required programs
sudo pacman -S apparmor firejail

#enable apparmor service
sudo systemctl enable apparmor.service
sudo systemctl start  apparmor.service

#configure apparmor to use firejail and configure firejail to automatically run for supported programs
sudo apparmor_parser -r /etc/apparmor.d/firejail-default
sudo firecfg

add user to /etc/firejail/firejail.users if it is not already in the file
if [ -z "$(grep "$USER" /etc/firejail/firejail.users)" ]; then
    sudo sh -c "echo '$USER' >> /etc/firejail/firejail.users"
fi

echo "============================================"
echo "     Applying Hardening Configuration"
echo "============================================"
echo ""
echo "append this to your kernel params file:"
echo "     lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
echo "   systemd-boot:  /boot/loader/entries/*.conf, append to end of line beginning with \"options\""
echo "           grub:  /etc/default/grub"
echo ""
echo "   run this script again after rebooting to ensure all settings are applied correctly."
echo "   press enter to continue."
read input

#add any firejail configuration here
    #fix mpv not being able to open some files, allows mmpv to play videos in the ~/media dir
sudo sh -c 'echo "whitelist $HOME/media" >> /etc/firejail/whitelist-player-common.local'
