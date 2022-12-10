{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gaming-configuration.nix
      ./sway-configuration.nix
    ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;


# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bismarck"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.connman.enable = true; 
  networking.wireless.iwd.enable = true;
  services.connman.wifi.backend = "iwd";

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 67 68 53 ];
  networking.firewall.allowedTCPPortRanges = [
  { from = 56881; to = 56889; }
  { from = 27036; to = 27037; }
  ];

  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.allowedUDPPortRanges = [
  { from = 27000; to = 27036; }
  ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;



  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     #keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
   };

 #Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.alex = {
     isNormalUser = true;
     shell = pkgs.zsh;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
	librewolf
    	yt-dlp
    	zathura
	sfeed
    	chromium
     ];
   };

   security.sudo.extraRules = [{
    runAs = "root";
    groups = [ "wheel" ];
    commands = [{
      command = "/run/current-system/sw/bin/poweroff";
      options = [ "NOPASSWD" ];
    } {
      command = "/run/current-system/sw/bin/reboot";
      options = [ "NOPASSWD" ];
    }];
  }];

# Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;

  services.pcscd.enable = true;
   programs.gnupg.agent = {
     enable = true;
     pinentryFlavor = "curses";
     enableSSHSupport = true;
   };

  environment.systemPackages = with pkgs; [
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    zsh
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk-sans
    zip
    unzip
    p7zip
    pavucontrol
    pamixer
    pulsemixer
    imagemagick
    ffmpegthumbnailer
    file
    viu
    bat
    pavucontrol
    neovim
    pfetch
    htop-vim
    lf
    mpv
    mpd
    ncmpcpp
    libnotify
    lynx
    mutt-wizard
    pass
    neomutt
    notmuch
    isync
    pinentry-curses
    connman-gtk
    openssl
    git
    shellcheck
    jq
    monero-cli
    bc
    gnome.zenity
    cura
    udisks2
    udiskie
    python3
    python3.pkgs.pip
      ];

  #enable flatpak
  services.flatpak.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pipewire.wireplumber.enable = true;

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

}
