#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my $bored = shift;
my $all = $bored < 0;
$bored = abs($bored);

while (<>) {
   my $t = 0;
   my ($last, %last);

   my $speak = sub {
      $last{$last} = $t++ if defined $last;
      $last = shift;
      print $last if $all;
   };

   chomp;
   for my $start (split /,/) {
      $speak->($start);
   }

   while ($t+1 < $bored) {
      my $next = defined $last{$last} ? $t - $last{$last} : 0;
      $speak->($next);
   }

   print $last unless $all;
}
