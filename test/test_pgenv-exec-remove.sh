#!/usr/bin/env bash

#: @BeforeAll
function setup_all() {
  local version
  for version in {10,11,12,13}; do
    mkdir -p "$TEST_VERSIONS_DIR/$version" \
          "$TEST_SOURCE_DIR/$version"
    touch "$TEST_ARCHIVE_DIR/postgresql-$version.tar.gz"
  done



  # pgenv global $test_version
  ln -sf "$TEST_VERSIONS_DIR/10" "$TEST_DEFAULT_LINK"
}

#: @AfterAll
function after_all() {
  local version
  for version in {10,11,12,13}; do
    rm -rf "$TEST_VERSIONS_DIR/$version" \
       "$TEST_ARCHIVE_DIR/postgresql-$version.tar.gz" \
       "$TEST_SOURCE_DIR/$version" || :
  done
}

test_remove_binary() {
  [ -e "$TEST_VERSIONS_DIR/10" ]

  run pgenv remove -f 10
  [ ! -e "$TEST_VERSIONS_DIR/10" ]
}

test_remove_binary_and_archive() {
  [ -e "$TEST_VERSIONS_DIR/11" ]
  [ -e "$TEST_ARCHIVE_DIR/postgresql-11.tar.gz" ]

  run pgenv remove -f --archive 11
  [ ! -e "$TEST_VERSIONS_DIR/11" ]
  [ ! -e "$TEST_ARCHIVE_DIR/postgresql-11.tar.gz" ]
}

test_remove_binary_and_source() {
  [ -e "$TEST_VERSIONS_DIR/12" ]
  [ -e "$TEST_SOURCE_DIR/12" ]

  run pgenv remove -f --source 12
  [ ! -e "$TEST_VERSIONS_DIR/12" ]
  [ ! -e "TEST_SOURCE_DIR/12" ]
}

test_remove_all() {
  [ -e "$TEST_SOURCE_DIR/13" ]
  [ -e "$TEST_ARCHIVE_DIR/postgresql-13.tar.gz" ]
  [ -e "$TEST_VERSIONS_DIR/13" ]

  run pgenv remove -f --all 13
  [ ! -e "$TEST_SOURCE_DIR/13" ]
  [ ! -e "$TEST_ARCHIVE_DIR/postgresql-13.tar.gz" ]
  [ ! -e "$TEST_VERSIONS_DIR/13" ]
}
