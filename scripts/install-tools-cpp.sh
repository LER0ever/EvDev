#!/bin/bash

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
# public LLVM PPA, development version of LLVM
echo "deb http://apt.llvm.org/eoan/ llvm-toolchain-eoan-10 main" > /etc/apt/sources.list.d/llvm.list
apt-get update && apt-get install -y clang-tools-10
ln -s /usr/bin/clangd-10 /usr/bin/clangd
