{ pkgs, ... }: {

  home.packages = with pkgs; [
    # Compilers and tools
    emscripten
    go
    opam
    rustup
    uv
    zig
    zls

    # Build tools often needed for C/C++
    gnumake
    cmake
    ninja
    ffmpeg

    # dev
    podman
    lazygit

    # LSP and Debuggers
    lldb
  ];

}
