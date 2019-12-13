#!/bin/sh
LC_ALL=C diff -rql orig/gawk-5.0.1 gawk-5.0.1 | grep -v "Only" | grep -v "/test/" | sed 's/^Files /diff -Naur /;s/ and / /;s/ differ$//' | sh
