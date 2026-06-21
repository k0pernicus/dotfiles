{ config, pkgs, nixpkgs-pinned, nixpkgs-unstable, ... }:

let
  dotfilesPath = "${config.home.homeDirectory}/Devel/dotfiles";
  unstable = nixpkgs-unstable.legacyPackages.${pkgs.system};
  pinnedPkgs = nixpkgs-pinned.legacyPackages.${pkgs.system};
in
{
  home.username = "antonin";
  home.homeDirectory = "/home/antonin";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # stable tools
    jq
    tree-sitter
    zellij
    go_1_26
    rustup
    brave
    discord
    transmission_4-gtk
    vlc
    mullvad-vpn
    
    pinnedPkgs.bitwarden-desktop
    
    unstable.firefox
    unstable.localsend
    unstable.signal-desktop
    unstable.thunderbird
    unstable.alacritty
    unstable.git
    unstable.vscodium
  ];
    
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # Prevent Home Manager from generating an init.lua since you provide your own
    # dotfiles mapping the entire `.config/nvim` directory
    sideloadInitLua = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
      ];
      theme = "xiong-chiamiov-plus";
    };

    # Custom aliases
    shellAliases = {
      v = "nvim";
      vim = "nvim";
    };

    initContent = ''
      if [ -f "$HOME/.zprofile" ]; then
        source "$HOME/.zprofile"
      fi
    '';
  };

  # Symlink to my development folder
  xdg.configFile = {
    "alacritty".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/alacritty";
    "nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/nvim";
    "zellij".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/zellij";
  };

  home.file = {
    # git
    ".gitconfig".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gitconfig";
    # configuration
    ".config/.gtc_comm".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_comm";
    ".config/.gtc_func".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_func";
    ".config/.gtc_prog".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_prog";
    ".config/.gtc_tool".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_tool";
    ".zprofile".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_zprofile";
    # dev
    ".config/VSCodium/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/vscode/settings.json";
  };

  programs.home-manager.enable = true;
}
