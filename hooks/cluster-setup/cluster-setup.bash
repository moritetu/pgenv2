#!/usr/bin/env bash
#
# Fook for cluster-setup
#
# arguments:
#   $1: tag
#

local tag="$1"; shift
case "$tag" in
  # Called on set up primary server
  # arguments:
  #   $1: primary or standby server name
  #   $2: path of pgdata
  #   $3: port number
  #   $4: include file path
  #   $5: archive directory
  setup_primary)
    : # do something
    ;;

  # Called on set up standby server
  # arguments:
  #   $1: primary or standby server name
  #   $2: path of pgdata
  #   $3: port number
  #   $4: include file path
  #   $5: archive directory
  setup_standby)
    : # do something
    ;;

  *)
    : # always do
    ;;
esac
