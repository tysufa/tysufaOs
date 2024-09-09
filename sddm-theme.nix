{ pkgs } :

pkgs.stdenv.mkDerivation {
  name = "catppuccin-mocha";
  src = pkgs.fetchurl {
    url = "https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip";
    sha256 = "1yh4f9xdm81bp8qy2yl5nw35haicfczks958zqr5c68kzr6h6hsa";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    mkdir ./temp
    ${pkgs.unzip}/bin/unzip $src -d ./temp
    cp -R ./temp/catppuccin-mocha/* $out/
    rm $out/metadata.desktop
    echo "
      [SddmGreeterTheme]
      Name=Catppuccin mocha
      Description=Soothing pastel theme for SDDM
      Type=sddm-theme
      Version=2.1
      Website=https://github.com/catppuccin/sddm
      Screenshot=preview.png
      MainScript=Main.qml
      ConfigFile=theme.conf
      TranslationsDirectory=translations
      Theme-Id=Catppuccin
      Theme-API=2.0
      License=MIT
      QtVersion=5" > $out/metadata.desktop
    '';

}

# pkgs.stdenv.mkDerivation {
#   name = "sddm-theme";
#   src = pkgs.fetchFromGitHub {
#     owner = "catppuccin";
#     repo = "sddm";
#     rev = "743511205d235f4727295943846978b4bdb9ce55";
#     sha256 = "1km85adim11aha06b9aw29y8w725dca02yxi1m93w79jldac9rlr";
#   };
#   installPhase = ''
#     mkdir -p $out
#     cp -R ./* $out
#   '';
# }


# pkgs.stdenv.mkDerivation {
#   name = "sddm-theme";
#   src = pkgs.fetchFromGitHub {
#     owner = "MarianArlt";
#     repo = "sddm-sugar-dark";
#     rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
#     sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
#   };
#   installPhase = ''
#     mkdir -p $out/share/sddm/themes
#     cp -R ./* $out/share/sddm/themes
#   '';
# }
