# Adapted from https://github.com/NixOS/nixpkgs/blob/95aeaf83c247b8f5aa561684317ecd860476fcd6/nixos/modules/security/wrappers/default.nix

{ pkgs, lib, config, ... }:

let
  inherit (config.security) wrapperDir;
  parentWrapperDir = builtins.dirOf wrapperDir;
  securityWrapper = callPackage ./wrapper.nix {
    inherit parentWrapperDir;
  };

  inherit (lib) mkOption;
in

{
  options = {
    security.wrapperDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/sbin";
      internal    = true;
      description = lib.mdDoc ''
        This option defines the path to the wrapper programs. It
        should not be overriden.
      '';
    };
  };
}
