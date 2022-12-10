{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [
  	wayland
  	sway
	alacritty
	swaylock
	swayidle
	grim
	slurp
	wl-clipboard
	mako
	swaybg
	waybar
	xwayland
	gammastep
	rofi-wayland
	imv
  ];

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

}
