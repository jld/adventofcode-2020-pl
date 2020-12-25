#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use bignum;

my $sum = 0;
while (<>) {
   chomp;
   while (1) {
      1 while s/\((\d+)\)/$1/;
      last unless s/(\d+) ([+*]) (\d+)/$2 eq "+" ? $1 + $3 : $1 * $3/e;
   }
   print;
   $sum += $_;
}
print "-- ";
print $sum;
