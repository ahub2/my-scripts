#!/bin/sh

yay -S greetd greetd-tuigreet

GREETD_CONFIG="[terminal]
vt = 1

[default_session]
command = \"tuigreet --time --cmd sway\"
user = \"greeter\""

sudo mkdir -p /etc/greetd/

#TODO may be better way to do this
echo "$GREETD_CONFIG" > ./.config.toml.tmp
sudo cp ./.config.toml.tmp /etc/greetd/config.toml
rm ./.config.toml.tmp

sudo systemctl enable greetd.service
