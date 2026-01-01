{
  description = "nix-darwin system flake - deimos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Pinning Go 1.24.1 specifically
    nixpkgs-go.url = "github:NixOS/nixpkgs/de0fe301211c267807afd11b12613f5511ff7433";
    nixpkgs-odin.url = "github:NixOS/nixpkgs/351954accc0620184355b1eb318c03a5ef08c6ae";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    home-manager.url = "github:nix-community/home-manager";
    mac-app-util.url = "github:hraban/mac-app-util";

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-go, nixpkgs-odin, home-manager, mac-app-util }:
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
          pkgs.wget
          pkgs.gnupg
        ];

      networking.applicationFirewall.enable = true;
      networking.applicationFirewall.enableStealthMode = true;
      networking.applicationFirewall.allowSigned = true;
      networking.applicationFirewall.allowSignedApp = true; 
      networking.computerName = "deimos";

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;  # default shell on macOS

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
     
      system.primaryUser = "${user}";
      # https://nix-darwin.github.io/nix-darwin/manual/
      system.defaults = {

        CustomUserPreferences = {
          # Disable siri
          "com.apple.Siri" = {
            "UAProfileCheckingStatus" = 0;
            "siriEnabled" = 0;
          };
          # Disable personalized ads 
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
        };

        # Whether to automatically switch between light and dark mode
        NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
        # Whether to enable “Natural” scrolling direction 
        NSGlobalDomain."com.apple.swipescrolldirection" = true;
        # Whether to enable trackpad secondary click
        NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
        # Auto hide stage strip showing recent apps
        WindowManager.AutoHide = true;
        # Click to show desktop only in Stqge Manager
        WindowManager.EnableStandardClickToShowDesktop = false;
        # Do not allow Stage Manager by default
        WindowManager.GloballyEnabled = false;
        # Hide items in Stage Manager
        WindowManager.HideDesktop = true;
        # Hide widgets in Stage Manager
        WindowManager.StageManagerHideWidgets = true;
        # Hide items in Desktop mode 
        WindowManager.StandardHideDesktopIcons = true;
        # Hide widgets in Desktop mode
        WindowManager.StandardHideWidgets = true;
        
        # Show battery percentage in the menu bar
        controlcenter.BatteryShowPercentage = true;

        trackpad.Clicking = true;

        dock.autohide = true;
        dock.autohide-delay = 0.25;
        dock.largesize = 24;
        dock.magnification = true;
        dock.mineffect = "genie";
        dock.show-recents = false;
        dock.tilesize = 48;
        
        finder.AppleShowAllExtensions = true;
        finder.NewWindowTarget = "Home";
        finder.ShowPathbar = true;
        finder.ShowStatusBar = true;

        # Deactivates the emoji and symbols hiting the Fn key
        hitoolbox.AppleFnUsageType = "Do Nothing";

        loginwindow.DisableConsoleAccess = false;
        loginwindow.GuestEnabled = false;
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
      specialArgs = { inherit nixpkgs-go nixpkgs-odin user userHome dotfilesPath; };
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
