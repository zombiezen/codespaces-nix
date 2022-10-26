{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/95aeaf83c247b8f5aa561684317ecd860476fcd6.tar.gz") {}
}:

let
  linux_x86_64 = pkgs: if pkgs.targetPlatform.isLinux && pkgs.targetPlatform.isx86_64
    then pkgs
    else pkgs.pkgsCross.gnu64;

  inherit (pkgs.lib) optionalAttrs;
in

{
  inherit pkgs;
  mkDockerImage = { name ? null, tag ? null }:
    let
      args = optionalAttrs (!builtins.isNull name) { inherit name; } //
        optionalAttrs (!builtins.isNull tag) { inherit tag; };
    in
      (linux_x86_64 pkgs).callPackage ./docker-image.nix args;
}
