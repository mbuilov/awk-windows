#!/bin/sh
find gawk-5.0.1/test \( -name "*.awk" -o -name "*.ok" -o -name "*.in" -o -name "*.bat" \) -printf "diff -Naur orig/%h/%f %h/%f\n" | sh
