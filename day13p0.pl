#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

chomp (my $t0 = <>);
chomp (my $buses = <>);
my @buses = grep { /^\d+$/} split /,/,$buses;

my ($soonest, $minwait);
for my $bus (@buses) {
   my $wait = (-$t0) % $bus;
   next if defined $minwait and $minwait < $wait;
   $soonest = $bus;
   $minwait = $wait;
}

print $soonest * $minwait;
