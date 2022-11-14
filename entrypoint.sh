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
    sudo -- "$@"
  }
  run_as_user() {
    "$@"
  }
fi

run_as_root mkdir -p "/run/user/$uid"
run_as_root chown "$username:$username" "/run/user/$uid"
lorri="/nix/var/nix/profiles/per-user/$username/profile/bin/lorri"
if [[ -x "$lorri" ]]; then
  XDG_RUNTIME_DIR="/run/user/$uid" run_as_user "$lorri" daemon &
fi

exec "$@"
