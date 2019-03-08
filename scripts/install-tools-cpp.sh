#!/bin/bash

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
# public LLVM PPA, development version of LLVM
echo "deb http://apt.llvm.org/cosmic/ llvm-toolchain-cosmic main" > /etc/apt/sources.list.d/llvm.list
apt-get update && apt-get install -y clang-tools-9
ln -s /usr/bin/clangd-9 /usr/bin/clangd
