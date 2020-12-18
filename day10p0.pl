#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @bag = map { int } <>;
my @chain = sort { $a <=> $b } @bag;
unshift @chain, 0;
push @chain, $chain[-1]+3;

my $j1 = 0;
my $j3 = 0;
for my $i (1..$#chain) {
   my $d = $chain[$i] - $chain[$i-1];
   ++$j1 if $d == 1;
   ++$j3 if $d == 3;
}

print $j1 * $j3;
