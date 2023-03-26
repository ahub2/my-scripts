#!/bin/sh
FILES_DIR="$HOME/.files"

#directories
ln -s "$FILES_DIR"/dl "$HOME"/dl
ln -s "$FILES_DIR"/docs "$HOME"/docs
ln -s "$FILES_DIR"/media "$HOME"/media
ln -s "$FILES_DIR"/.ssh "$HOME"/.ssh
ln -s "$FILES_DIR"/.local/share/password-store "$HOME"/.local/share/
ln -s "$FILES_DIR"/.local/share/gnupg "$HOME"/.local/share/
ln -s "$FILES_DIR"/dbhome "$HOME"/

#files
ln -s "$FILES_DIR"/.gitconfig "$HOME"/.gitconfig

mkdir -p ~/.var/app/
ln -s "$HOME"/.files/.var/app/io.gitlab.librewolf-community ~/.var/app/io.gitlab.librewolf-community 
