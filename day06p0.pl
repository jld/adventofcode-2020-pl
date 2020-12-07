#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @stuff = ({});
while (<>) {
   chomp;
   unless (length) {
      push @stuff, {};
      next;
   }
   $stuff[-1]{$1}++ while /(.)/g;
}

my $sum = 0;
for my $grp (@stuff) {
   $sum += scalar %$grp;
}
print $sum;
