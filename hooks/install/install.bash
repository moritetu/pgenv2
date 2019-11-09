#!/usr/bin/env bash
#
# Fook for install
#
# arguments:
#   $1: tag
#


local tag="$1" ; shift
case "$tag" in
  # Called before doing configure
  # arguments:
  #   $1: configure options ($configure_options, writable)
  before_configure)
    : # do something
    ;;

  # Called before doing make
  # arguments:
  #   $1: make command ($make_command, writable)
  before_make)
    : # do something
    ;;

  # Called after installing
  # arguments:
  #   $1: specified install directory if --install-dir option
  #   $2: default install directory
  finish)
    : # do something
    ;;

  *)
    : # always do
    ;;
esac
