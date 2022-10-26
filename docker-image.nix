{ name ? "ghcr.io/zombiezen/codespaces-nix"
, tag ? "latest"
, bashInteractive
, buildEnv
, callPackage
, coreutils-full
, curl
, dockerTools
, findutils
, gnugrep
, gnutar
, gzip
, less
, man
, nix
, runtimeShell
, sudo
, tzdata
, vim
, wget
, which
, writeScript
, writeTextDir
, zsh
}:

let
  wrapperDir = "/sbin";
  securityWrapper = callPackage ./security-wrapper {
    parentWrapperDir = "/";
  };

  wheelNopasswd = writeTextDir "etc/sudoers.d/wheel" ''
    %wheel ALL=(ALL:ALL) NOPASSWD: ALL
  '';

  entrypoint = writeScript "entrypoint" ''
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

    sudoIf chown vscode:vscode /nix/store /nix/store/*
    sudoIf chmod 777 /nix/store

    if [[ ! -e /nix/var ]]; then
      sudoIf mkdir -p /nix/var/nix/profiles/per-user/vscode
      sudoIf chown -R vscode:vscode /nix/var
    fi

    set +e
    exec "$@"
  '';
in

dockerTools.streamLayeredImage {
  inherit name tag;

  copyToRoot = buildEnv {
    name = "codespaces-nix";
    paths = [
      bashInteractive
      coreutils-full
      curl
      dockerTools.usrBinEnv
      dockerTools.binSh
      dockerTools.caCertificates
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
      wheelNopasswd
      which
      vim
      zsh
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

  runAsRoot = ''
    #!${runtimeShell}
    ${dockerTools.shadowSetup}
    groupadd --system --gid 1 wheel
    groupadd --gid 1000 vscode
    useradd \
      --uid 1000 \
      --gid 1000 --groups wheel \
      --create-home --home-dir /home/vscode \
      vscode

    mkdir -p /var

    mkdir -p ${wrapperDir}
    cp ${securityWrapper}/bin/security-wrapper ${wrapperDir}/sudo
    echo -n ${sudo}/bin/sudo > ${wrapperDir}/sudo.real
    chown root:root ${wrapperDir}/sudo
    chmod u+s,g-s,u+rx,g+x,o+x ${wrapperDir}/sudo
  '';

  config = {
    Entrypoint = [ entrypoint ];
    Cmd = [ "/bin/bash" ];
    User = "vscode";
    Volumes."/tmp" = {};
    Volumes."/run" = {};
    Labels = {
      "org.opencontainers.image.source" = "https://github.com/zombiezen/codespaces-nix";
      "devcontainer.metadata" = builtins.toJSON {
        remoteUser = "vscode";
        mounts = [
          { type = "tmpfs"; target = "/tmp"; }
          { type = "tmpfs"; target = "/run"; }
        ];
      };
    };
  };
}
