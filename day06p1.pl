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
   $stuff[-1]{"__"}++;
   $stuff[-1]{$1}++ while /(.)/g;
}

my $sum = 0;
for my $grp (@stuff) {
   my $n = $grp->{"__"};
   for my $l (keys %$grp) {
      $sum++ if length $l == 1 and $grp->{$l} == $n;
   }
}
print $sum;
