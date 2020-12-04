#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my %n;
while (<>) {
   chomp;
   $n{$_}++;
}

my %s;
for my $n (keys %n) {
   for my $m (keys %n) {
      $s{$n+$m} = $n*$m;
   }
}

for my $n (keys %n) {
   my $x = 2020-$n;
   print $n*$s{$x} if $s{$x};
}
