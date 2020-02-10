#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install rustc Rust

require curl

goto_tempdir

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
