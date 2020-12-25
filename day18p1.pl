#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use bignum;

sub flatcalc {
   local $_ = shift;
   1 while s/(\d+) \+ (\d+)/$1 + $2/e;
   1 while s/(\d+) \* (\d+)/$1 * $2/e;
   return $_;
}

my $sum = 0;
while (<>) {
   chomp;
   $_= "($_)";
   1 while s/\(([^()]+)\)/flatcalc($1)/e;
   print;
   $sum += $_;
}
print "-- ";
print $sum;
