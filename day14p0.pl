#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use bignum;

sub bin ($) { oct("0b$_[0]") }

my ($img, $mask, %mem);
$mask = -1;
while (<>) {
   if (/^mask = ([01X]*)$/) {
      my ($bimg, $bmask) = ($1, $1);
      $bimg =~ y/01X/010/;
      $bmask =~ y/01X/001/;
      $img = bin($bimg);
      $mask = bin($bmask);
   } elsif (/^mem\[(\d+)\] = (\d+)$/) {
      $mem{$1} = ($2 & $mask) | $img;
   } else {
      die "unknown command";
   }
}

my $sum;
for (values %mem) {
   $sum += $_;
}
print $sum;
