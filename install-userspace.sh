#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

set -euo pipefail
script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
username="${1:-vscode}"
out_link="${2:-/opt/sw}"

run_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  else
    sudo -- "$@"
  fi
}

run_as_user() {
  if [[ "$(id -un)" = "$username" ]]; then
    USER="$username" LOGNAME="$username" "$@"
  else
    runuser -u "$username" -- "$@"
  fi
}

# Install Nix. Should be the same version as in userspace.nix.
echo "Installing Nix..." 1>&2
run_as_user bash -c 'sh <(curl -fsSL https://releases.nixos.org/nix/nix-2.11.0/install) --no-daemon'
nix_bin="/nix/var/nix/profiles/per-user/$username/profile/bin"

# Install system-wide packages into /opt/sw
nix_file="$script_dir/userspace.nix"
system_profile=/nix/var/nix/profiles/default
echo "Building /opt/sw..." 1>&2
run_as_user "$nix_bin/nix-env" \
  --profile "$system_profile" \
  --file "$nix_file" \
  --install \
  --attr systemPackages
run_as_root mkdir -p "$(dirname "$out_link")"
run_as_root ln -s "$system_profile" "$out_link"

# Install default packages into user profile.
echo "Building $username user environment..." 1>&2
run_as_user "$nix_bin/nix-env" \
  --file "$nix_file" \
  --install \
  --attr userPackages

# Clean up any intermediate derivations.
run_as_user "$nix_bin/nix-store" --gc
