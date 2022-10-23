{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/3933d8bb9120573c0d8d49dc5e890cb211681490.tar.gz") {}
}:

{
  inherit pkgs;
 
  system = pkgs.nixos ({ pkgs, modulesPath, ... }: {
    imports = [
      "${modulesPath}/virtualisation/docker-image.nix"
      "${modulesPath}/installer/cd-dvd/channel.nix"
    ];

    documentation.doc.enable = false;

    environment.systemPackages = with pkgs; [
      bashInteractive
      cacert
      nix
    ];

    system.stateVersion = "22.05";
  });
}
