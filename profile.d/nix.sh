#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

if [[ -z "${LOCALE_ARCHIVE:-}" ]]; then
  export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
fi
[[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
