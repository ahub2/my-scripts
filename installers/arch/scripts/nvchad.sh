#!/bin/sh

#sudo pacman -S npm cargo

rm -rf ~/.config/nvim/
rm -rf ~/.local/share/nvim/
mkdir ~/.config/nvim

git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

rm -rf ~/.config/nvim/lua/custom/
ln -s ~/.config/nvchad/custom/ ~/.config/nvim/lua/
