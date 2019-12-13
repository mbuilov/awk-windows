#!/bin/sh
# use as:
# git diff gawk-5.0.1-windows-tests.patch | ./time-fix.sh | sh
sed -n 's/^-+++ \([_a-z0-9/.-]*\)[^0-9]*\([0-9-]* [0-9:.]*\).*/touch -d "\2" "\1"/p'
