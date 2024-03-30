#!/bin/bash

folder=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

# $folder/clang main.c -O1 -S -emit-llvm --analyze
# $folder/llc main.ll
clang main.c -O1 -S -emit-llvm --analyze
clang main.c

v=$[ $RANDOM % 256 ]
for i in {0..20}
do
  ./a.out $v
  sleep 0.1
done
