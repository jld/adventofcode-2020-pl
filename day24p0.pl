#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my %dirs =
  (e => [2, 0],
   se => [1, -1],
   sw => [-1, -1],
   w => [-2, 0],
   nw => [-1, 1],
   ne => [1, 1]);

my %tiles;
while (<>) {
   my ($x,$y) = (0,0);
   while (/([sn]?[ew])/g) {
      my ($dx,$dy) = @{$dirs{$1}};
      $x += $dx;
      $y += $dy;
   }
   $tiles{$x,$y} ^= 1;
}

my $count;
$count += $_ for values %tiles;
print $count;
