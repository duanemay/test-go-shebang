#!/bin/bash

go-cmd() {
  if [[ -z "${1}" ]]; then
    echo "Usage: go-cmd <command>"
    return 1
  fi
  local cmd="${1}"
  local originalCmd="${1}"
  if [[ "$cmd" =~ .*\.go$ ]]; then
    cmd="${cmd/.go/}"
  fi
  if [[ "$cmd" =~ .*\/.* ]]; then
    local dir
    dir=$(dirname "${cmd}")
    pushd "${dir}" >/dev/null || return 1
    cmd=$(basename "${cmd}")
  fi
  shift

  local file
  if [[ -f "${cmd}.go" ]]; then
    file="./${cmd}.go"
  elif [[ -f "cmd/${cmd}/main.go" ]]; then
    file="cmd/${cmd}/main.go"
  elif [[ -f "cmd/${cmd}/${cmd}.go" ]]; then
    file="cmd/${cmd}/${cmd}.go"
  elif [[ -d "cmd/${cmd}" ]]; then
    file="./cmd/${cmd}"
  else
    echo "Could not find file for command: ${cmd}"
    return 1
  fi

  go build -o "${cmd}" "./${file}"
  "./${cmd}" "$@"
  local result=$?

  if [[ "$originalCmd" =~ .*\/.* ]]; then
    popd >/dev/null || return 1
  fi
  return $result
}

go-build-cmds() {
  local cmd
  grep -l "func main(" -- *.go 2>/dev/null | while read -r cmd; do
    cmd=$(basename "${cmd}")
    cmd="${cmd/.go/}"
    echo "Building ${cmd}"
    go build -o "${cmd}" "${cmd}.go"
  done
  find cmd -type d -maxdepth 1 -mindepth 1 | while read -r cmd; do
    cmd=$(basename "${cmd}")
    echo "Building ${cmd}"
    go build -o "${cmd}" "./cmd/${cmd}"
  done
}