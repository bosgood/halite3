#!/usr/bin/env bash

set -e

# Working directories
root=$(pwd)
dist="${root}/dist"
bundle="${dist}/packaged_$1.zip"
tmp="${root}/tmp"
build="${tmp}/$1"

cleanup() {
  if [ -e "${build}" ]; then
    rm -rf "${build}"
  fi
}

trap cleanup EXIT

# Workspace preparations
cleanup
mkdir -p "${dist}"
mkdir -p "${tmp}"
if [ -e "${bundle}" ]; then
  rm "${bundle}"
fi

# Packaging
echo "working from temp directory: ${build}"
cp -R "$1" "${build}"
cd "${build}"
echo "creating bundle ${bundle} with directory contents"
zip -r "${bundle}" *
cd "${root}"
echo "done"
