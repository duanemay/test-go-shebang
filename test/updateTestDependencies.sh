#!/usr/bin/env zsh
# shellcheck shell=bash

# These are the dependency directory name and git url, required for this project.
typeset -A DEPENDENCIES
k='bats-shellmock' DEPENDENCIES[$k]=git@github.com:duanemay/bats-shellmock.git
k='bats-support' DEPENDENCIES[$k]=https://github.com/bats-core/bats-support.git
k='bats-assert' DEPENDENCIES[$k]=https://github.com/bats-core/bats-assert.git
k='bats-file' DEPENDENCIES[$k]=https://github.com/bats-core/bats-file.git

for dependency in ${(@k)DEPENDENCIES}; do
  GIT_URL=${DEPENDENCIES[${dependency}]}
  if [[ -d test/libs/"${dependency}" ]]; then
    rm -rf test/libs/"${dependency}"
  fi
  git clone "${GIT_URL}" test/libs/"${dependency}"
  rm -rf test/libs/"${dependency}"/.git
done