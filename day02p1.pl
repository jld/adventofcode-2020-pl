#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my $good = 0;
while (<>) {
   my ($a,$b,$ch,$pwd) = /^(\d+)-(\d+) (\S): (\S*)$/;
   my $n = 0;
   my $la = substr $pwd, $a-1, 1;
   my $lb = substr $pwd, $b-1, 1;
   ++$good if ($la eq $ch) != ($lb eq $ch);
}
print $good;
