#!/usr/bin/env bash
set -eu

here="$(cd -- "$(dirname -- ${BASH_SOURCE})" && pwd -P)"
baut run "$@" "$here"
exit $?
