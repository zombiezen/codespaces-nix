#!/usr/bin/env bash
# SPDX-License-Identifier: Unlicense

if [[ -z "$PATH" ]]; then
  PATH=/opt/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
elif ! echo "$PATH" | grep '/opt/sw/bin:' > /dev/null ; then
  PATH="/opt/sw/bin:$PATH"
fi
export PATH
