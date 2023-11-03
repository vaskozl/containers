#!/usr/bin/perl -pi
# Build for any Arch
s/^arch=.*/arch=('any')/;
# Increase yarn install timeout
s/yarn\s+install\s+.*(?<!--network-timeout)/$& --network-timeout 1200000/;
