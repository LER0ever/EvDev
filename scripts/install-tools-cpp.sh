#!/bin/bash

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
# public LLVM PPA, development version of LLVM
RUN echo "deb http://apt.llvm.org/cosmic/ llvm-toolchain-cosmic main" > /etc/apt/sources.list.d/llvm.list
RUN apt-get update && apt-get install -y clang-tools-9
RUN ln -s /usr/bin/clangd-9 /usr/bin/clangd