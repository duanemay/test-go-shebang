#!/usr/bin/env bash

CDPATH=
BASE_DIR=$(dirname ${BATS_TEST_DIRNAME})
export BASE_DIR

# These are the dependency directory names, required for this project.
for dependency in bats-shellmock bats-support bats-assert bats-file; do
  loadFile="${BATS_TEST_DIRNAME}/libs/${dependency}/load.bash"
  if [ -e "${loadFile}" ]; then
    load "${loadFile}"
  else
    echo Library ${dependency} not found, run updateTestDependencies.sh
    exit 255
  fi
done