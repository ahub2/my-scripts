#!/bin/sh
#
#install required programs
sudo pacman -S apparmor

#enable apparmor service
sudo systemctl enable apparmor.service
sudo systemctl start  apparmor.service


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
