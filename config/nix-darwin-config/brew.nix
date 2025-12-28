# brew.nix
{ ... }: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = false;
    onActivation.upgrade = true;

    # GUIs
    casks = [
      "alacritty"
      "anytype"
      "crossover"
      "discord"
      "docker-desktop"
      "firefox"
      "mullvad-vpn"
      "signal"
      "thunderbird"
      "transmission"
      "visual-studio-code"
      "vlc"
    ];
    
    # Mac App Store apps
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Brother iPrint&Scan" = 1193539993;
      "Instapaper" = 288545208;
      "LocalSend" = 1661733229;
      "Magnet" = 441258766;
      "Photomator" = 1444636541;
    };
  };
}
