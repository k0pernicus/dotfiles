{ config, pkgs, ... }:

let
  hackers-plymouth = pkgs.stdenv.mkDerivation {
    pname = "hackers-plymouth";
    version = "master";

    src = pkgs.fetchFromGitHub {
      owner = "k0pernicus";
      repo = "Hackers-Plymouth";
      rev = "main";
      hash = "sha256-JvpRzu725U64kWDpK5kKDX2kgkj/v4yjxVN6GvGJBp0=";
    };

    installPhase = ''
      mkdir -p $out/share/plymouth/themes/
      cp -r crashoverride acidburn lordnikon cerealkiller $out/share/plymouth/themes/
      find $out/share/plymouth/themes -type f \( -name "*.plymouth" -o -name "*.script" \) -exec sed -i "s@/usr/share/plymouth/themes@$out/share/plymouth/themes@g" {} \;
    '';
  };
in
{
  # All the actual settings go here
  boot.plymouth = {
    enable = true;
    themePackages = [ hackers-plymouth ];
    theme = "crashoverride"; 
  };
}
