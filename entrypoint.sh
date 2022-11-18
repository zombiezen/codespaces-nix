#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

set -euo pipefail

uid="$(id -u)"
if [[ "$uid" -eq 0 ]]; then
  username="vscode"
  uid="$(id -u "$username")"
  run_as_root() {
    "$@"
  }
  run_as_user() {
    runuser -u "$username" -- "$@"
  }
else
  username="$(id -un)"
  run_as_root() {
    sudo --non-interactive --preserve-env=NIX_REMOTE -- "$@"
  }
  run_as_user() {
    USER="$username" LOGNAME="$username" "$@"
  }
fi

default_nix_profile=/nix/var/nix/profiles/default
if [[ -x "$default_nix_profile/bin/nix-daemon" ]]; then
  run_as_root "$default_nix_profile/bin/nix-daemon" >& /tmp/nix-daemon.log &
fi
if [[ -x "$default_nix_profile/bin/setfacl" ]]; then
  run_as_root "$default_nix_profile/bin/setfacl" --remove-default /tmp
fi

run_as_root mkdir -p "/run/user/$uid"
run_as_root chown "$username:$username" "/run/user/$uid"

user_profile="/nix/var/nix/profiles/per-user/$username/profile"
if [[ -x "$user_profile/bin/lorri" ]]; then
  XDG_RUNTIME_DIR="/run/user/$uid" NIX_REMOTE=daemon \
    run_as_user "$user_profile/bin/lorri" daemon >& "/run/user/$uid/lorri.log" &
fi

exec "$@"
