#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my $good = 0;
while (<>) {
   my ($l,$u,$ch,$pwd) = /^(\d+)-(\d+) (\S): (\S*)$/;
   my $n = 0;
   ++$n while $pwd =~ /$ch/g;
   ++$good if $l <= $n && $n <= $u;
}
print $good;
