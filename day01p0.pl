#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;

my %n;
while (<>) {
   chomp;
   $n{$_}++;
}

$\="\n";
for my $n (keys %n) {
   my $x = 2020 - $n;
   print $n*$x if $n <= $x && $n{$x};
}
