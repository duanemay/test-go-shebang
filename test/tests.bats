#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}"/test_helper.bash

setup() {
  skipIfNot "$BATS_TEST_DESCRIPTION"
}

teardown() {
  rm -f "${BATS_TEST_DIRNAME}"/../hello
  if [ -z "$TEST_FUNCTION" ]; then
    if [ -d "$TEST_TEMP_DIR" ]; then
      temp_del "$TEST_TEMP_DIR"
    fi
  fi
}

####################################################################################################
# run from this dir
####################################################################################################

@test "run with go run" {
  run go run ./hello.go go

  assert_line --index 0 "Hello go"
  assert_line --index 1 "exit status 42"
  assert_failure 1
}

@test "run with shebang" {
  run ./hello.go shebang

  assert_output "Hello shebang"
  assert_failure 42
}

@test "run with go build" {
  go build -o hello hello.go
  run ./hello aliens

  assert_output "Hello aliens"
  assert_failure 42
}

####################################################################################################
# run from tempDir
####################################################################################################
@test "run from tempDir with go run" {
  TEST_TEMP_DIR="$(temp_make)"
  cd "${TEST_TEMP_DIR}" || exit
  run go run "${BATS_TEST_DIRNAME}/../hello.go" go

  assert_line --index 0 "Hello go"
  assert_line --index 1 "exit status 42"
  assert_failure 1
}

@test "run from tempDir with shebang" {
  TEST_TEMP_DIR="$(temp_make)"
  cd "${TEST_TEMP_DIR}" || exit

  run "${BATS_TEST_DIRNAME}/../hello.go" shebang

  assert_output "Hello shebang"
  assert_failure 42
}

@test "run from tempDir with go build" {
  TEST_TEMP_DIR="$(temp_make)"
  cd "${TEST_TEMP_DIR}" || exit

  go build -o "hello" "${BATS_TEST_DIRNAME}/../hello.go"
  assert_file_executable ./hello

  run "./hello" aliens

  assert_output "Hello aliens"
  assert_failure 42
}

####################################################################################################
# run with bash functions
####################################################################################################

@test "run with go-cmd in same dir with extension" {
  # shellcheck source=../golang-shell-functions.sh
  source "${BATS_TEST_DIRNAME}/../golang-shell-functions.sh"

  run go-cmd hello.go go-cmd

  assert_output "Hello go-cmd"
  assert_failure 42
}

@test "run with go-cmd in same dir without extension" {
  # shellcheck source=../golang-shell-functions.sh
  source "${BATS_TEST_DIRNAME}/../golang-shell-functions.sh"

  run go-cmd hello go-cmd

  assert_output "Hello go-cmd"
  assert_failure 42
}

@test "run from tempDir with go-cmd with extension" {
  # shellcheck source=../golang-shell-functions.sh
  source "${BATS_TEST_DIRNAME}/../golang-shell-functions.sh"

  TEST_TEMP_DIR="$(temp_make)"
  cd "${TEST_TEMP_DIR}" || exit
  run go-cmd "${BATS_TEST_DIRNAME}/../hello.go" go-cmd

  assert_output "Hello go-cmd"
  assert_failure 42
}

@test "run from tempDir with go-cmd without extension" {
  # shellcheck source=../golang-shell-functions.sh
  source "${BATS_TEST_DIRNAME}/../golang-shell-functions.sh"

  TEST_TEMP_DIR="$(temp_make)"
  cd "${TEST_TEMP_DIR}" || exit
  run go-cmd "${BATS_TEST_DIRNAME}/../hello" go-cmd

  assert_output "Hello go-cmd"
  assert_failure 42
}

@test "go-build-cmds on cmds dir" {
  # shellcheck source=../golang-shell-functions.sh
  source "${BATS_TEST_DIRNAME}/../golang-shell-functions.sh"

  TEST_TEMP_DIR="$(temp_make)"
  cd "${TEST_TEMP_DIR}" || exit
  mkdir -p cmd/hello
  cp "${BATS_TEST_DIRNAME}/../hello.go" cmd/hello
  cp "${BATS_TEST_DIRNAME}/../go.mod" .
  assert_file_exist cmd/hello/hello.go

  run go-build-cmds
  assert_file_executable ./hello
  assert_line --index 0 "Building hello"

  run ./hello go-build-cmds
  assert_line --index 0 "Hello go-build-cmds"
  assert_failure 42
}

@test "go-build-cmds in same dir" {
  # shellcheck source=../golang-shell-functions.sh
  source "${BATS_TEST_DIRNAME}/../golang-shell-functions.sh"

  TEST_TEMP_DIR="$(temp_make)"
  cd "${TEST_TEMP_DIR}" || exit
  mkdir -p cmd/hello
  cp "${BATS_TEST_DIRNAME}/../hello.go" .
  cp "${BATS_TEST_DIRNAME}/../go.mod" .
  assert_file_exist hello.go

  run go-build-cmds
  assert_file_exist hello
  assert_file_executable ./hello
  assert_line --index 0 "Building hello"

  run ./hello go-build-cmds
  assert_line --index 0 "Hello go-build-cmds"
  assert_failure 42
}