#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

sub get_line () {
   $_ = <>;
   die "unexpected EOF" unless defined;
   chomp;
}

sub expect_str ($) {
   get_line;
   die "unexpected line \"$_\" (expected \"$_[0]\")" unless $_ eq $_[0];
}

sub get_deck () {
   my @deck;
   while (<>) {
      last unless /./;
      chomp;
      push @deck, $_;
   }
   return @deck;
}

expect_str "Player 1:";
my @ad = get_deck();
expect_str "Player 2:";
my @bd = get_deck();

while (@ad && @bd) {
   my $ac = shift @ad;
   my $bc = shift @bd;
   if ($ac > $bc) {
      push @ad, $ac, $bc;
   } else {
      push @bd, $bc, $ac;
   }
}

my @wd = @ad ? @ad : @bd;

my $score;
for my $i (1..@wd) {
   $score += $i * $wd[-$i];
}
print $score;
