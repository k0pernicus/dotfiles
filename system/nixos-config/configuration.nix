{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
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

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-667c2261-a769-44d9-8310-cdd1e6f421cd".device =
    "/dev/disk/by-uuid/667c2261-a769-44d9-8310-cdd1e6f421cd";
  networking.hostName = "phobos";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  services.xserver.enable = true;
  # plasma
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  console.keyMap = "fr";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  fonts.packages = with pkgs; [
    source-code-pro
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # for Plasma wayland
  };
  programs.gamemode.enable = true; # Automatically optimizes CPU / GPU when a game launches

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    asusctl
    curl
    gcc
    nixfmt-rfc-style # the official nix formatter
    powertop
    zip
    unzip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Specific laptop services
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  services.supergfxd.enable = true;

  # VPN settings
  services.mullvad-vpn.enable = true;

  # Security settings
  # Enable app sandboxing
  security.apparmor.enable = true;
  # Restrict sudo to 'wheel' members only
  security.sudo.execWheelOnly = true;
  # Enable the firewall
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 80 443 25565 ];
    # allowedUDPPorts = [ 25565 ];
  };

  # Enable virtualization for docker (rootless only)
  # Store the images in the current user home
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.docker.daemon.settings = {
    data-root = "$HOME/.docker/images";
  };

  system.stateVersion = "25.11";
}
