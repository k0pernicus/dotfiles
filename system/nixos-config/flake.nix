{
  description = "NixOS flake configuration for Zephyrus G14 2022 (AMD)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-pinned.url = "github:NixOS/nixpkgs/687f05a9184cad4eaf905c48b63649e3a86f5433";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-pinned,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations.phobos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs-pinned nixpkgs-unstable; };
        modules = [
          nixos-hardware.nixosModules.asus-zephyrus-ga402
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit nixpkgs-pinned nixpkgs-unstable; };
            home-manager.users.antonin = import ./home.nix;
          }
        ];
      };
    };
}
