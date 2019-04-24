#!/usr/bin/env bash

#: @BeforeAll
function setup_all() {
  local version
  rm -rf "$TEST_VERSIONS_DIR"/*
  for version in {10,11,12,13}; do
    mkdir -p "$TEST_VERSIONS_DIR/$version"
  done

  # pgenv global $test_version
  ln -sf "$TEST_VERSIONS_DIR/10" "$TEST_DEFAULT_LINK"
}

#: @AfterAll
function after_all() {
  local version
  for version in {10,11,12,13}; do
    rm -rf "$TEST_VERSIONS_DIR/$version"
  done
}

test_list() {
  run pgenv --no-color list
  local current_version_regexp="\* 10"
  [[ "$result" =~ $current_version_regexp ]]
  [[ "$result" =~ 11 ]]
  [[ "$result" =~ 12 ]]
  [[ "$result" =~ 13 ]]
}

test_verbose_list() {
  run pgenv --d0 --no-color list -v
  local current_version_regexp= version=
  for version in {10,11,12,13}; do
    current_version_regexp="-> $TEST_VERSIONS_DIR/$version"
    [[ "$result" =~ $current_version_regexp ]]
  done
}
