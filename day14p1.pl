#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use bignum;

sub bin ($) { oct("0b$_[0]") }

sub stuff {
   my ($n) = @_;
   return (0) unless $n;
   my $lsb = $n & -$n;
   my @stuff = stuff($n & ~$lsb);
   return (@stuff, map { $_ | $lsb } @stuff);
}

my ($zero, $one, @ex, %mem);
while (<>) {
   if (/^mask = ([01X]*)$/) {
      my ($bzero, $bone, $bex) = ($1, $1, $1);
      $bzero =~ y/01X/100/;
      $bone =~ y/01X/010/;
      $bex =~ y/01X/001/;
      $zero = bin($bzero);
      $one = bin($bone);
      @ex = stuff(bin($bex));
   } elsif (/^mem\[(\d+)\] = (\d+)$/) {
      for my $float (@ex) {
         $mem{$1 & $zero | $one | $float} = $2;
      }
   } else {
      die "unknown command";
   }
}

my $sum;
for (values %mem) {
   $sum += $_;
}
print $sum;
