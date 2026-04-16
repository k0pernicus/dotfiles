{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    uv
    go

    # Build tools often needed for Odin/C/C++
    gnumake
    cmake
    ninja
    ffmpeg
    emscripten

    # LSP and Debuggers
    lldb            # Debugger that works well with Odin on macOS
  ];

}
