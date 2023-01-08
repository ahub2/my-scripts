#!/bin/sh

yay -S greetd greetd-tuigreet

GREETD_CONFIG="[terminal]
vt = 1

[default_session]
command = \"tuigreet --time --cmd sway\"
user = \"greeter\""

sudo mkdir -p /etc/greetd/
sudo sh -c "echo $GREETD_CONFIG > /etc/greetd/config.toml"

sudo systemctl enable greetd.service
