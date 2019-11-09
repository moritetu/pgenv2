#!/usr/bin/env bash
#
# Fook for env
#
# arguments:
#   $1: tag
#

local tag="$1"; shift
case "$tag" in
  # Called after writing environment
  write)
    : # do something
    ;;
  # Called before printing environment
  print)
    : # do something
    ;;
  *)
    : # always do
    ;;
esac
