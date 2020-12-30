#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @cups;

sub metric ($) {
   1 / ($_[0] - $cups[0])
}

use Data::Dumper;
sub crab () {
   # I'm sure I'm missing a way to make this array shuffling not hideous.
   my $n = scalar @cups;
   my @taken = @cups[1..3];
   @cups[1..$#cups] = @cups[4..$#cups];
   $#cups -= 3;
   my @stuff = sort { $$a[1] <=> $$b[1] } map { [$_, metric $cups[$_]] } 1..$#cups;
   my $target = $stuff[0][0];
   @cups[$target+4..$#cups+3] = @cups[$target+1..$#cups];
   @cups[$target+1..$target+3] = @taken;
   push @cups, shift @cups;
}

my ($n, $input) = @ARGV;
@cups = split //, $input;
for (1..$n) {
   crab;
   print join(" ", @cups);
}
print "-- ";
#for (1..($n % @cups)) {
#   unshift @cups, pop @cups;
#}
push @cups, shift @cups until $cups[0] == 1;
print join("", @cups[1..$#cups]);
