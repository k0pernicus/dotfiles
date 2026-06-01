{ config, pkgs, nixpkgs-unstable, ... }:

let 
    unstable = nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./hardware-configuration.nix
    ./plymouth.nix
  ];

  # Collect and remove old generations automatically every week
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.tmp = {
    useTmpfs = true;
    cleanOnBoot = true;
  };
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.luks.devices."luks-c582ce98-d5a2-4c33-9ff5-4d8e6f1e50d4".device = "/dev/disk/by-uuid/c582ce98-d5a2-4c33-9ff5-4d8e6f1e50d4";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
      hostName = "phobos";
      networkmanager = {
        enable = true;
        wifi.powersave = false;
      };
  };

  time.timeZone = "Europe/Paris";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  # gnome
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.libinput.enable = true;
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
    
  systemd.services.accounts-daemon.restartIfChanged = false; # do not restart accounts-daemon at each update

  console.keyMap = "fr";


  programs.zsh.enable = true; # Enable zsh for everyone, but configure it per user (see home-manager)

  users.users.antonin = {
    isNormalUser = true;
    description = "antonin";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };
  users.groups.video.members = [ "antonin" ];
  users.groups.render.members = [ "antonin" ];

  fonts.packages = with pkgs; [
    source-code-pro
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true; # Automatically optimizes CPU / GPU when a game launches

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    asusctl
    curl
    gcc
    gnupg
    gnumake
    nixfmt-rfc-style # the official nix formatter
    powertop
    unzip
    zip

    gnome-tweaks
    papirus-icon-theme
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-photos
    gnome-tour
    gnome-weather
    showtime
    totem
    yelp
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable GSConnect and automatically open the necessary firewall ports
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Specific laptop services
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  services.supergfxd.enable = true;
  zramSwap.enable = true;

  # VPN settings
  services.mullvad-vpn.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Security settings
  # Enable app sandboxing
  security.apparmor.enable = true;
  # Restrict sudo to 'wheel' members only
  security.sudo.execWheelOnly = true;
  # Enable the firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 ]; # LocalSend
    allowedUDPPorts = [ 53317 ]; # LocalSend
    # allowedUDPPorts = [ 25565 ];
  };

  # Enable virtualization for docker (rootless only)
  # Store the images in the current user home
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  system.stateVersion = "25.11";
}
