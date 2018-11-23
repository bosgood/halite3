#!/usr/bin/env bash

# Working directories
root=$(pwd)
dist="${root}/dist"
tmp="${root}/tmp"
build="${tmp}/$1"

# Workspace preparations
rm -rf "${build}"
mkdir -p "${dist}"
rm "${dist}/packaged_$1.zip"

# Packaging
(
  cp -R "$1" "${build}"
  cd "${build}"
  cp "${root}/Cargo.toml" .
  zip -r "${dist}/packaged_$1.zip" *
)
