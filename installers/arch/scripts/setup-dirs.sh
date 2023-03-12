#!/bin/sh
FILES_DIR="$HOME/.files/"

ln -s "$HOME"/.files/dl "$HOME"/dl
ln -s "$HOME"/.files/docs "$HOME"/docs
ln -s "$HOME"/.files/media "$HOME"/media
ln -s "$HOME"/.files/.ssh "$HOME"/.ssh

ln -s "$HOME"/.files/.gitconfig "$HOME"/.gitconfig

mkdir -p ~/.var/app/
ln -s "$HOME"/.files/.var/app/io.gitlab.librewolf-community ~/.var/app/io.gitlab.librewolf-community 
