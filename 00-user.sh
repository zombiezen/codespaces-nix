#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

if [[ -z "${USER:-}" ]]; then
  USER="$(id -un)"
  export USER
fi
