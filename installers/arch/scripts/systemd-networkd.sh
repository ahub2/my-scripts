#!/bin/sh

echo "copying default systemd-networkd config files located in: "
echo "    ../files/systemd/network/basic/   to: /etc/systemd/network/"
echo "  modify these files if there is no internet connectivity."
echo "  see available network devices (Name=*) with: ls /sys/class/net/"

sudo cp ../files/systemd/network/basic/* /etc/systemd/network/


sudo systemctl enable --now systemd-networkd.service
sudo systemctl enable --now systemd-resolved.service


#setup system to default to systemd-resolved config
sudo ln -rsf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
