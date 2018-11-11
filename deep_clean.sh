#!/usr/bin/env bash -ex

TOMLS=$(fd Cargo.toml -d 2)
for t in $TOMLS; do
    cd $(dirname $t)
    cargo clean
    cd -
done
