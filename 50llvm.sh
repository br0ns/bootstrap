#!/bin/bash
source "$(dirname "$0")/bs.sh"

prompt_install llvm-config LLVM

require gcc libc6-dev cmake

goto_tempdir

svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm

mkdir build
cd build
cmake ../llvm
cmake --build .
sudo cmake --build . --target install
