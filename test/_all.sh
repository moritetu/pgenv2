#!/usr/bin/env bash

#
# Called once before all tests run.
#
function _setup() {
  export PGENV_TEST_DIR="$(__DIR__)"/out
  # Make workspace directories and files.
  export TEST_VERSIONS_DIR=$PGENV_TEST_DIR/versions
  export TEST_ARCHIVE_DIR=$PGENV_TEST_DIR/archive
  export TEST_SOURCE_DIR=$PGENV_TEST_DIR/sources
  export TEST_DEFAULT_LINK=$PGENV_TEST_DIR/default

  if [ -e "$PGENV_TEST_DIR" ]; then
    rm -rf "$PGENV_TEST_DIR"
  fi

  mkdir -p "$TEST_VERSIONS_DIR" \
        "$TEST_VERSIONS_DIR" \
        "$TEST_ARCHIVE_DIR" \
        "$TEST_SOURCE_DIR" \
        "$PGENV_TEST_DIR/samples"

  export PGENV_ROOT="$PGENV_TEST_DIR"
  ln -sf "../../libexec" "$PGENV_TEST_DIR/libexec"
  ln -sf "../../bin" "$PGENV_TEST_DIR/bin"
}


#
# Called once after all tests have done.
#
function _cleanup() {
  :
}
