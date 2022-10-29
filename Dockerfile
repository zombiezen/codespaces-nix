# https://github.com/devcontainers/images/tree/main/src/base-debian/history
FROM mcr.microsoft.com/vscode/devcontainers/base:0.202.8-debian-11

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    acl \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*
RUN setfacl -k /tmp
RUN su - vscode -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon'

COPY nix.sh /tmp/nix.sh
RUN install --mode 644 /tmp/nix.sh /etc/profile.d/nix.sh && rm /tmp/nix.sh

VOLUME ["/tmp", "/run"]
LABEL org.opencontainers.image.source="https://github.com/zombiezen/codespaces-nix"
LABEL devcontainer.metadata="{ \
  \"remoteUser\": \"vscode\", \
  \"mounts\": [ \
    {\"type\": \"tmpfs\", \"target\": \"/tmp\"}, \
    {\"type\": \"tmpfs\", \"target\": \"/run\"}, \
  ] \
}"
