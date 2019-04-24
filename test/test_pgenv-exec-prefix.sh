#!/usr/bin/env bash

#: @BeforeAll
function setup_all() {
  test_version=10.0
  mkdir -p "$TEST_SOURCE_DIR/$test_version" \
        "$TEST_VERSIONS_DIR/$test_version"/{lib,bin,include,share,samples}

  # pgenv global $test_version
  ln -sf "$PGENV_TEST_DIR/$test_version" "$TEST_DEFAULT_LINK"
}

#: @AfterAll
function after_all() {
  if [ -e "$TEST_SOURCE_DIR/$test_version" ]; then
    rm -rf "$TEST_SOURCE_DIR/$test_version"
  fi
  if [ -e "$TEST_VERSIONS_DIR/$test_version" ]; then
    rm -rf "$TEST_VERSIONS_DIR/$test_version"
  fi
}

test_prefix() {
  run pgenv prefix
  [ "$result" = "$TEST_VERSIONS_DIR/$test_version" ]
}

test_options() {
  declare -A prefix_options=(
    [bin]=-b
    [lib]=-l
    [include]=-i
    [share]=-S
  )

  for opt in ${!prefix_options[@]}; do
    run pgenv prefix --$opt
    [ "$result" = "$TEST_VERSIONS_DIR/$test_version/$opt" ]
    run pgenv prefix ${prefix_options[$opt]}
    [ "$result" = "$TEST_VERSIONS_DIR/$test_version/$opt" ]
  done

  run pgenv prefix --source
  [ "$result" = "$TEST_SOURCE_DIR/$test_version" ]
  run pgenv prefix -s
  [ "$result" = "$TEST_SOURCE_DIR/$test_version" ]

  run pgenv prefix --root
  [ "$result" = "$PGENV_TEST_DIR" ]
  run pgenv prefix -r
  [ "$result" = "$PGENV_TEST_DIR" ]

  run pgenv prefix --samples
  [ "$result" = "$PGENV_TEST_DIR/samples" ]
  run pgenv prefix -e
  [ "$result" = "$PGENV_TEST_DIR/samples" ]
}

test_prefix_command() {
  run pgenv prefix pwd
  [ "$result" = "$TEST_VERSIONS_DIR/$test_version" ]

  run pgenv prefix --bin pwd
  [ "$result" = "$TEST_VERSIONS_DIR/$test_version/bin" ]
}
