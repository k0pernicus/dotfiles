{ config, pkgs, ... }:

{
  home.username = "antonin";
  home.homeDirectory = "/home/antonin";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    # (dev) tools
    alacritty
    git
    tree-sitter
    zellij

    # dev
    go_1_25
    rustup

    # else
    anytype
    bitwarden-desktop
    discord
    firefox
    localsend
    mullvad-vpn
    signal-desktop
    thunderbird
    transmission_4-qt
    vlc
    vscodium
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      ripgrep
      fd
      lua-language-server
      stylua
    ];
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
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/config/alacritty";
    "nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/config/nvim";
    "zellij".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/config/zellij";
  };

  home.file = {
    # git
    ".gitconfig".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/dot/dot_gitconfig";
    # configuration
    ".config/.gtc_comm".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/dot/dot_gtc_comm";
    ".config/.gtc_func".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/dot/dot_gtc_func";
    ".config/.gtc_prog".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/dot/dot_gtc_prog";
    ".config/.gtc_tool".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/dot/dot_gtc_tool";
    ".zprofile".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/dot/dot_zprofile";
    # dev
    ".config/VSCodium/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Devel/dotfiles/config/vscode/settings.json";
  };

  programs.home-manager.enable = true;
}
