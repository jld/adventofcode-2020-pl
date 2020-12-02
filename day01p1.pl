#!/usr/bin/perl
use strict;
$\="\n";

my %n;
while (<>) {
   chomp;
   $n{$_}++;
}

my %s;
for my $n (keys %n) {
   for my $m (keys %n) {
      $s{$n+$m} = $n*$m;
   }
}

for my $n (keys %n) {
   for my $s (keys %s) {
      print $n*$s{$s} if $n + $s == 2020;
   }
}
