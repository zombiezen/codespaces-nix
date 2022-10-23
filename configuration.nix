{ pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/docker-image.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

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
    vim
    which
  ];

  programs.zsh.enable = true;
  virtualisation.docker.enable = true;

  users.users.vscode = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };

  system.stateVersion = "22.05";
}
