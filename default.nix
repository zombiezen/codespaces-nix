{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/3933d8bb9120573c0d8d49dc5e890cb211681490.tar.gz") {}
}:

{
  inherit pkgs;
 
  system = pkgs.nixos {
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
  };
}
