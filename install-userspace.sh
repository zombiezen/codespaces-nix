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
    sudo --non-interactive --preserve-env=NIX_REMOTE -- "$@"
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
run_as_root bash -c 'sh <(curl -fsSL https://releases.nixos.org/nix/nix-2.11.0/install) --daemon --no-modify-profile'
run_as_root mkdir -p /etc/nix
echo "extra-trusted-users = $username" | run_as_root tee -a /etc/nix/nix.conf > /dev/null

system_profile=/nix/var/nix/profiles/default
nix_bin="$system_profile/bin"

echo "Starting Nix daemon..." 1>&2
run_as_root "$nix_bin/nix-daemon" &
nix_daemon_pid="$(jobs -p %%)"
trap 'echo "Stopping Nix daemon..." 1>&2 ; run_as_root kill "$nix_daemon_pid" ; wait' EXIT
export NIX_REMOTE=daemon

# Install system-wide packages into /opt/sw
nix_file="$script_dir/userspace.nix"
echo "Building /opt/sw..." 1>&2
run_as_root "$nix_bin/nix-env" \
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
