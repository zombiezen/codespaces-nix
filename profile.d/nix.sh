#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

if [[ -z "${LOCALE_ARCHIVE:-}" ]]; then
  export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
fi
[[ ! -z "$HOME" && -e "$HOME/.nix-profile/etc/profile.d/nix-daemon.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix-daemon.sh"
if [[ ! -v NIX_REMOTE ]]; then
  export NIX_REMOTE=daemon
fi
