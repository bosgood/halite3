#!/usr/bin/env bash

set -e

cargo build
./halite --replay-directory replays/ -vvv --width 32 --height 32 "RUST_BACKTRACE=1 ../target/debug/sample_bot" "RUST_BACKTRACE=1 ../target/debug/sample_bot"
