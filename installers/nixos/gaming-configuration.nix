{ config, pkgs, lib, ... }: {

  #enable nonfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      lutris
      radeontop
  ];

  #add 32bit support for graphics
  hardware.opengl.driSupport32Bit = true;

  #nixpkgs.config.packageOverrides = pkgs: {
  #  steam = pkgs.steam.override {
  #    extraPkgs = pkgs: with pkgs; [
  #      libgdiplus
  #      libpng
  #    ];
  #  };
  #};

   programs.steam = {
    enable = false;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

}
