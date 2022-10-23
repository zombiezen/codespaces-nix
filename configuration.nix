{ pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/docker-image.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  documentation.dev.enable = true;

  environment.systemPackages = with pkgs; [
    bashInteractive
    cacert
    coreutils-full
    curl
    gnugrep
    gnutar
    gzip
    less
    man
    nix
    which
  ];

  programs.zsh.enable = true;

  system.stateVersion = "22.05";
}
