#!/usr/bin/env bash
#
# source install.sh or sh install.sh
#

function __install_pgenv() {
  local HERE="$(cd -P -- "$(dirname -- "${BASH_SOURCE:-$0}")" && pwd -P)"
  local BASH_PROFILE=~/.bash_profile
  local ident="$(/bin/date +%s)"
  local temporary_file="$BASH_PROFILE.$ident"
  sed -e '/### start pgenv/,/### end pgenv/d' "$BASH_PROFILE" > $temporary_file
  cat <<EOS >> "$temporary_file"
### start pgenv
source "$HERE/profile"
### end pgenv
EOS
  if [ $? -ne 0 ]; then
    echo "error: failed to write setting into '$temporary_file'" >&2
    exit 1
  fi
  mv "$temporary_file" "$BASH_PROFILE"
  if [ $? -ne 0 ]; then
    echo "error: failed to mv $temporary_file to $BASH_PROFILE'" >&2
    rm "$temporary_file"
    exit 1
  fi
  source "$BASH_PROFILE"
}

__install_pgenv
unset -f __install_pgenv
