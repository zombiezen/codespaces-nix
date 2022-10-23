{ pkgs, modulesPath, ... }:

{
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
}
