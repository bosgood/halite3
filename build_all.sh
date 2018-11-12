#!/usr/bin/env bash
#set -x # echo
set -e # stop the presses

TOMLS=$(find . -name Cargo.toml -depth 2)
for t in $TOMLS; do
    cd $(dirname $t)
    # rustup run 1.20.0 cargo rustc --release -q -Awarnings
    # cargo +1.20.0 rustc --release -q -- -Awarnings
    # TODO: shooting from hip here
    # cargo rustc --release -q -- -Awarnings
    cargo rustc -q -- -Awarnings
    cd - > /dev/null  # quiet
done
