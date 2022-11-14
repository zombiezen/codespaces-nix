#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

if [[ -z "${USER:-}" ]]; then
  USER="$(id -un)"
  export USER
fi
if [[ -z "${XDG_RUNTIME_DIR:-}" ]]; then
  XDG_RUNTIME_DIR="/run/user/$(id -u)"
  if [[ -d "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi
fi
