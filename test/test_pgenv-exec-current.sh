#!/usr/bin/env bash

#: @BeforeAll
function setup_all() {
  test_version=10.0
  mkdir -p "$TEST_VERSIONS_DIR/$test_version"
  # pgenv global $test_version
  ln -sf "$PGENV_TEST_DIR/$test_version" "$TEST_DEFAULT_LINK"
}

#: @AfterAll
function after_all() {
  if [ -e "$TEST_VERSIONS_DIR/$test_version" ]; then
    rm -rf "$TEST_VERSIONS_DIR/$test_version"
  fi
}

test_current() {
  run pgenv current
  [ "$result" = "10.0" ]
}
