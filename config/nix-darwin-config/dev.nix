{ nixpkgs-dev, pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      go = nixpkgs-dev.legacyPackages.${prev.system}.go_1_24;
      uv = nixpkgs-dev.legacyPackages.${prev.system}.uv;
      odin = nixpkgs-dev.legacyPackages.${prev.system}.odin;
      ols = nixpkgs-dev.legacyPackages.${prev.system}.ols;
    })
  ];

  environment.systemPackages = with pkgs; [
    uv
    odin
    go

    # Build tools often needed for Odin/C/C++
    gnumake
    cmake
    ninja
    
    # LSP and Debuggers
    ols             # Odin Language Server
    lldb            # Debugger that works well with Odin on macOS
  ];

  environment.variables = {
    # If you need to point Odin to specific paths
    ODIN_ROOT = "${pkgs.odin}/share"; 
  };
}
