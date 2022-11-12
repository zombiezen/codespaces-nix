# SPDX-License-Identifier: Unlicense

{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/d8f2c4d846a2e65ad3f5a5e842b672f0b81588a2.tar.gz") {}
}:

{
  inherit pkgs;
  nixpkgs = pkgs;
  defaultPackages = [
    pkgs.bzip2
    pkgs.direnv
    pkgs.git
    pkgs.man
    pkgs.unzip
    pkgs.zip
  ];
}
