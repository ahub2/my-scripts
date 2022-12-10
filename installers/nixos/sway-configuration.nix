{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [
  	wayland
  	sway
	waylock
	swayidle
	grim
	slurp
	wl-clipboard
	mako
	swaybg
	waybar
	xwayland
	gammastep
	bemenu
	imv
	foot
	autotiling
  ];

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

}
