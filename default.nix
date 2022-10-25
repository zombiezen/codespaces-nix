{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/95aeaf83c247b8f5aa561684317ecd860476fcd6.tar.gz") {}
, pkgs_22_05 ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/3933d8bb9120573c0d8d49dc5e890cb211681490.tar.gz") {}
}:

let
  linux_x86_64 = pkgs: if pkgs.targetPlatform.isLinux && pkgs.targetPlatform.isx86_64
    then pkgs
    else pkgs.pkgsCross.gnu64;

  system = (linux_x86_64 pkgs_22_05).nixos ({ pkgs, ... }: {
    imports = [
      ./configuration.nix
    ];

    installer.cloneConfig = false;

    boot.postBootCommands =
      let
        configFile = pkgs.writeText "configuration.nix" (builtins.readFile ./configuration.nix);
      in ''
        if [ ! -e /etc/nixos/configuration.nix ]; then
          cp ${configFile} /etc/nixos/configuration.nix
        fi
      '';
  });

  mkDockerImage = { name ? "ghcr.io/zombiezen/codespaces-nixos", tag ? "22.05" }:
    (linux_x86_64 pkgs).dockerTools.buildImage {
      inherit name tag;

      copyToRoot = system.toplevel;

      config = {
        Entrypoint = ["/init"];
        Labels = {
          "org.opencontainers.image.source" = "https://github.com/zombiezen/codespaces-nixos";
          "org.opencontainers.image.version" = "22.05";
          "devcontainer.metadata" = builtins.toJSON {
            overrideCommand = false;
            runArgs = [ "--cap-add=SYS_ADMIN" "--security-opt=seccomp=unconfined" ];
            remoteUser = "vscode";
            updateRemoteUserUID = false;
          };
        };
      };
    };
in

{
  pkgs = pkgs_22_05;
  inherit system mkDockerImage;
}
