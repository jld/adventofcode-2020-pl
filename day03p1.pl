#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @trees;
while (<>) {
   chomp;
   $trees[$.-1][$-[0]] = $1 ne "." while /(.)/g;
}

sub boop {
   my ($dx, $dy) = @_;
   my $boop = 0;
   for (my $t = 0; ; $t++) {
      my $row = $trees[$t*$dy];
      last unless $row;
      $boop += $row->[($t*$dx) % @$row];
   }
   return $boop;
}

my $prod = 1;
for my $slope ([1, 1], [3, 1], [5, 1], [7, 1], [1, 2]) {
   $prod *= boop(@$slope);
}
print $prod;
