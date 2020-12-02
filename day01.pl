#!/usr/bin/perl
use strict;

my %n;
while (<>) {
   chomp;
   $n{$_}++;
}

$\="\n";
for my $n (keys %n) {
   my $x = 2020 - $n;
   print $n*$x if $n <= $x && $n{$x};
}
