#!/usr/bin/env bash
if [[ -z "${USER:-}" ]]; then
  USER="$(id -un)"
  export USER
fi

[[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
