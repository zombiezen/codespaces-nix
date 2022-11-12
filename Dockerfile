# SPDX-License-Identifier: Unlicense

ARG DEBIAN=debian:bullseye-20221024-slim

FROM $DEBIAN

# As of 2022-11-12, VSCode requires
# ca-certificates, libc6, libstdc++6, python-minimal, and tar.
# https://code.visualstudio.com/docs/remote/linux#_remote-host-container-wsl-linux-prerequisites
#
# curl and xz-utils are needed for Nix installation.
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    dirmngr \
    gnupg \
    less \
    libc6 \
    libssl1.1 \
    libstdc++6 \
    locales \
    netbase \
    python2-minimal \
    sudo \
    tar \
    xz-utils \
    zsh \
  && rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

# Add non-root user.
RUN groupadd --gid 1000 vscode && \
  useradd \
    --shell /bin/bash \
    --uid 1000 \
    --gid 1000 \
    --create-home \
    vscode && \
  echo 'vscode ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/vscode && \
  chmod 0440 /etc/sudoers.d/vscode

# Install Nix and set up userspace.
RUN su - vscode -c 'sh <(curl -fsSL https://releases.nixos.org/nix/nix-2.11.1/install) --no-daemon'
COPY userspace.nix /tmp/userspace.nix
RUN su - vscode -c 'nix-env --file /tmp/userspace.nix --install --attr defaultPackages' \
  && rm /tmp/userspace.nix

# Customize environment variables.
COPY profile.d /tmp/profile.d
RUN install --mode 644 /tmp/profile.d/* /etc/profile.d/ && \
  rm -rf /tmp/profile.d && \
  echo 'source /etc/profile.d/00-user.sh' >> /etc/zsh/zshenv && \
  echo 'source /etc/profile.d/nix.sh' >> /etc/zsh/zprofile

# Set up tmpfs volumes.
VOLUME ["/tmp", "/run"]

ARG REVISION
LABEL org.opencontainers.image.source="https://github.com/zombiezen/codespaces-nix"
LABEL org.opencontainers.image.revision=$REVISION
LABEL org.opencontainers.image.base.name=$DEBIAN
LABEL devcontainer.metadata="{ \
  \"remoteUser\": \"vscode\", \
  \"mounts\": [ \
    {\"type\": \"tmpfs\", \"target\": \"/tmp\"}, \
    {\"type\": \"tmpfs\", \"target\": \"/run\"}, \
  ] \
}"
