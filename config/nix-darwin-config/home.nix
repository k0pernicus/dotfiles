{ config, pkgs, dotfilesPath, user, userHome, ... }: {
  
  home.stateVersion = "24.05";
  home.homeDirectory = "${userHome}";  

  # Packages to install
  home.packages = with pkgs; [
    # Developer - install zsh in another scope
    git
    tree-sitter
    zellij
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
      plugins = ["git" "docker"];
      theme = "xiong-chiamiov-plus";
    };

    # Custom aliases
    shellAliases = {
      nixswitch = "darwin-rebuild switch --flake ~/System/nix-darwin-config";
      nixclean = "nix-collect-garbage -d";
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
    "alacritty".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/alacritty";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/nvim";
    "zellij".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/zellij";
  };

  home.file = {
    # ssh
    ".ssh/".source = config.lib.file.mkOutOfStoreSymlink "${userHome}/System/sshkeys";
    # pgp
    ".gnupg/".source = config.lib.file.mkOutOfStoreSymlink "${userHome}/System/gnupgkeys";
    # git
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gitconfig";
    # configuration
    ".config/.gtc_comm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_comm";
    ".config/.gtc_func".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_func";
    ".config/.gtc_prog".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_prog";
    ".config/.gtc_tool".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_gtc_tool";
    ".zprofile".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dot/dot_zprofile";
    # vscode
    "Library/Application Support/Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/config/vscode/settings.json";
  };
}
