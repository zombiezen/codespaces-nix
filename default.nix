{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/95aeaf83c247b8f5aa561684317ecd860476fcd6.tar.gz") {}
}:

let
  linux_x86_64 = pkgs: if pkgs.targetPlatform.isLinux && pkgs.targetPlatform.isx86_64
    then pkgs
    else pkgs.pkgsCross.gnu64;

  inherit (pkgs.lib) mkIf;
in

{
  inherit pkgs;
  mkDockerImage = { name ? null, tag ? null }:
    let
      argsModule = {
        dockerImage.name = mkIf (!builtins.isNull name) name;
        dockerImage.tag = mkIf (!builtins.isNull tag) tag;
      };

      module = (linux_x86_64 pkgs).lib.evalModules {
        modules = [
          ./modules/docker-image.nix
          argsModule
          { _module.args = { inherit pkgs; }; }
        ];
        specialArgs = {
          modulesPath = ./modules;
        };
      };
    in
      module.config.system.build.dockerImage;
}
