#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @trees;
while (<>) {
   chomp;
   $trees[$.-1][$-[0]] = $1 ne "." while /(.)/g;
}

my $boop = 0;
for my $y (0..$#trees) {
   $boop += $trees[$y][($y * 3) % @{$trees[$y]}];
}
print $boop;
