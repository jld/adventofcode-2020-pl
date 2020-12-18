#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my $window = shift;
my @log;
LINE: while (<>) {
   chomp;
   my @window = @log[-$window..-1];
   push @log, $_;
   next unless defined $window[0];

   for my $i (0..$#window) {
      for my $j (0..$i-1) {
         next LINE if $_ == $window[$i] + $window[$j];
     }
   }
   print;
}
