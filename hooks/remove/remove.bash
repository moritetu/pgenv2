#!/usr/bin/env bash
#
# Fook for remove
#
# arguments:
#   $1: tag
#

local tag="$1" ; shift
case "$tag" in
  # Called after removing
  # arguments:
  #   $1: install directory
  #   $2: version directory
  #   $3: source directory
  #   $4: archive directory
  finish)
    : # do something
    ;;

  *)
    : # always do
    ;;
esac
