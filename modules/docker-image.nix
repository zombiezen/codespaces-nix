{ pkgs, lib, config, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.dockerImage;
  jsonFormat = pkgs.formats.json {};
in

{
  imports = [
    ./build.nix
  ];

  options = {
    environment.systemPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        bashInteractive
        coreutils-full
        curl
        findutils
        gnugrep
        gnutar
        gzip
        less
        man
        nix
        sudo
        tzdata
        wget
        which
        vim
        zsh
      ];
    };

    dockerImage.name = mkOption {
      type = types.str;
      default = "ghcr.io/zombiezen/codespaces-nix";
    };
    dockerImage.tag = mkOption {
      type = types.str;
      default = "latest";
    };
    dockerImage.entrypoint = mkOption {
      type = types.lines;
      default = "";
    };
    dockerImage.fakeRootCommands = mkOption {
      type = types.lines;
      default = "";
    };
    dockerImage.user = mkOption {
      type = types.str;
      default = "vscode";
    };
    dockerImage.devcontainer = mkOption {
      type = jsonFormat.type;
      default = {
        remoteUser = cfg.user;
      };
    };
  };

  config = {
    system.build.dockerImage =
      let
        entrypoint = pkgs.writeScript "entrypoint" ''
          #!/usr/bin/env bash
          set -e

          sudoIf()
          {
            if [ "$(id -u)" -ne 0 ]; then
              sudo "$@"
            else
              "$@"
            fi
          }

          ${cfg.entrypoint}

          set +e
          exec "$@"
        '';

        baseSystem = pkgs.buildEnv {
          name = "codespaces-nix";
          paths = config.environment.systemPackages ++ [
            pkgs.dockerTools.usrBinEnv
            pkgs.dockerTools.binSh
            pkgs.dockerTools.caCertificates
          ];
          pathsToLink = [
            "/bin"
            "/etc"
            "/include"
            "/lib"
            "/libexec"
            "/share"
            "/usr"
          ];
        };
      in
        pkgs.dockerTools.buildLayeredImageWithNixDb {
          inherit (cfg) name tag fakeRootCommands;

          contents = [ baseSystem ];

          config = {
            User = cfg.user;
            Labels = {
              "org.opencontainers.image.source" = "https://github.com/zombiezen/codespaces-nix";
              "devcontainer.metadata" = builtins.toJSON cfg.devcontainer;
            };
          };
        };
  };
}
