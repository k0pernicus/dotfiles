{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    uv
    odin
    
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
