#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

if [[ -z "${USER:-}" ]]; then
  USER="$(id -un)"
  export USER
fi

[[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
