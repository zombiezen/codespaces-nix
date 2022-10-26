# Copied from https://github.com/NixOS/nixpkgs/blob/95aeaf83c247b8f5aa561684317ecd860476fcd6/nixos/modules/system/build.nix

{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {

    system.build = mkOption {
      default = {};
      description = lib.mdDoc ''
        Attribute set of derivations used to set up the system.
      '';
      type = types.submoduleWith {
        modules = [{
          freeformType = with types; lazyAttrsOf (uniq unspecified);
        }];
      };
    };

  };
}
