#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @bps;
while (<>) {
   chomp;
   y/FBLR/0101/;
   push @bps, oct "0b$_";
}
@bps = sort @bps;

print "Highest: $bps[-1]";

for my $i (1..$#bps) {
  print "Gap: $bps[$i-1] $bps[$i]" if $bps[$i] == $bps[$i-1]+2;
}
