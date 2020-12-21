#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my $bored = shift;

while (<>) {
   chomp;
   my @log = split /,/;
   my %when = map { $log[$_] => [$_] } 0..$#log;
   while (@log < $bored) {
      my $n = $log[-1];
      my $when = $when{$n};
      my $m = $#$when ? $when->[-1] - $when->[-2] : 0;
      push @{$when{$m}}, scalar @log;
      push @log, $m;
   }
   print $bored < 50 ? join(",",@log) : $log[-1];
}
