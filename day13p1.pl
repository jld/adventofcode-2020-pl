#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use bignum;

sub gcd {
   my ($a, $b) = @_;
   ($a, $b) = ($b, $a % $b) while $b;
   return $a;
}

chomp (my $t0 = <>);
chomp (my $buses = <>);
my @buses = split /,/,$buses;

my $t = 0;
++$t while $buses[$t] eq "x";
my $p = $buses[$t];

for my $u ($t+1..$#buses) {
   my $q = $buses[$u];
   next if $q eq "x";
   $t += $p until $t % $q == (-$u % $q);
   $p *= $q / gcd($p, $q);
}

print $t;
