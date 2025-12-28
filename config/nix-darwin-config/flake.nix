{
  description = "nix-darwin system flake - deimos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager";
    mac-app-util.url = "github:hraban/mac-app-util";

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, mac-app-util }:
  let
    user = "antonin";
    userHome = "/Users/${user}"; 
    dotfilesPath = "${userHome}/Devel/dotfiles";
    configuration = { pkgs, ... }: {
           # Usage of determinate - avoid conflicts with self-nix of nix-darwin
      nix.enable = false;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.gnupg
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;  # default shell on macOS

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
     
      system.primaryUser = "${user}"; 
      system.defaults = {
        trackpad.Clicking = true;

        dock.autohide = true;
        dock.tilesize = 48;
        
        finder.AppleShowAllExtensions = true;
        
        loginwindow.LoginwindowText = "beware.";
        
        screencapture.location = "~/Pictures/screenshots";
        
        screensaver.askForPasswordDelay = 10;
      };

      # Unlock via fingerprint
      security.pam.services.sudo_local.touchIdAuth = true;

      # Needed for home-manager
      users.users.antonin.home = "${userHome}";

      fonts.packages = with pkgs; [
        source-code-pro
        jetbrains-mono
        nerd-fonts.jetbrains-mono
      ];

      # The platform the configuration will be used on.
      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfree = true;
      };

      # Ensure Rosetta 2 is installed on Apple Silicon
      # Then enable x86-64 emulation
      system.activationScripts.extraActivation.text = ''
        softwareupdate --install-rosetta --agree-to-license
      '';
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#deimos
    darwinConfigurations."deimos" = nix-darwin.lib.darwinSystem {
      # Pass those informations to the submodules
      specialArgs = { inherit user userHome dotfilesPath; };
      modules = [ 
        configuration
        ./dev.nix
        ./brew.nix
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit user userHome dotfilesPath; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [
            mac-app-util.homeManagerModules.default
          ];
          home-manager.users.${user} = import ./home.nix;
        }
      ];
    };
  };
}
