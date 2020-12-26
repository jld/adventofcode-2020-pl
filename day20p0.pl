#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my (%tiles, %index);
while (<>) {
   die "bad tile header" unless /^Tile (\d+):$/;
   my $tile = $1;
   die "ambiguous tile $tile" if defined $tiles{$tile};
   my @rows;
   while (<>) {
      last unless /./;
      chomp;
      push @rows, $_;
   }
   my $last = not defined $_; # Sigh.
   my $t = $rows[0];
   my $r = join "", map { substr $_,-1,1 } @rows;
   my $b = reverse $rows[-1];
   my $l = join "", reverse map { substr $_,0,1 } @rows;
   $tiles{$tile} = [$t, $r, $b, $l];
   my @edges = ($t, $r, $b, $l);
   for my $edge (@edges, map { scalar reverse } @edges) {
      push @{$index{$edge}}, $tile;
   }
   last if $last;
}

# Every interior edge must appear at least twice, but the problem
# statement guarantees the inverse: the outside edges are unique.
#
# Also, the given inputs use each edge either once or twice, so the
# entire grid can be laid out without backtracking.
#
# But for the first part, we don't need to lay out the whole thing;
# just the corners: the only tiles with two unique edges.

my @corn;
for my $tile (keys %tiles) {
   my @outer = grep { @{$index{$_}} == 1 } @{$tiles{$tile}};
   push @corn, $tile if @outer == 2;
}

use bignum;
my $prod = 1;
$prod *= $_ for @corn;
print $prod;
