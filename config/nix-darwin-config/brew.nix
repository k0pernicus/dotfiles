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
      "crossover"
      "discord"
      "firefox"
      "mullvad-vpn"
      "signal"
      # "steam" - installed through crossover
      "thunderbird"
      "visual-studio-code"
    ];
    
    # Mac App Store apps
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Brother iPrint&Scan" = 1193539993;
      "Instapaper" = 288545208;
      "LocalSend" = 1661733229;
      "Magnet" = 441258766;
    };
  };
}
