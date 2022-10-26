# Copied from https://github.com/NixOS/nixpkgs/blob/95aeaf83c247b8f5aa561684317ecd860476fcd6/nixos/modules/security/wrappers/wrapper.nix

{ stdenv, linuxHeaders, parentWrapperDir, debug ? false }:
# For testing:
# $ nix-build -E 'with import <nixpkgs> {}; pkgs.callPackage ./wrapper.nix { parentWrapperDir = "/run/wrappers"; debug = true; }'
stdenv.mkDerivation {
  name = "security-wrapper";
  buildInputs = [ linuxHeaders ];
  dontUnpack = true;
  hardeningEnable = [ "pie" ];
  CFLAGS = [
    ''-DWRAPPER_DIR="${parentWrapperDir}"''
  ] ++ (if debug then [
    "-Werror" "-Og" "-g"
  ] else [
    "-Wall" "-O2"
  ]);
  dontStrip = debug;
  installPhase = ''
    mkdir -p $out/bin
    $CC $CFLAGS ${./wrapper.c} -o $out/bin/security-wrapper
  '';
}
