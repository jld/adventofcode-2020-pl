#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use bignum;

my @bag = map { int } <>;
my @chain = sort { $a <=> $b } @bag;

my @ways = (1);
for my $adapt (0, @chain) {
   for my $jolt (1..3) {
      $ways[$adapt+$jolt] += $ways[$adapt];
   }
}
print $ways[-1];
