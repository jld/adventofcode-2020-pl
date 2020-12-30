#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my (@prev, @next, $last, $current, $lowest, $highest);

sub get_cup {
   my ($what) = @_;
   my $prev = $prev[$what];
   my $next = $next[$what];
#   die "oops" unless defined $prev and defined $what and defined $next;
   $next[$prev] = $next;
   $prev[$next] = $prev;
   $prev[$what] = $next[$what] = undef;
}

sub put_cup {
   my ($prev, $what) = @_;
   my $next = $next[$prev];
#   die "oops" unless defined $prev and defined $what and defined $next;
#   die "oops" if defined $next[$what] or defined $prev[$what];
   $next[$prev] = $what;
   $prev[$what] = $prev;
   $next[$what] = $next;
   $prev[$next] = $what;
}

sub new_cup {
   my ($what) = @_;
   if (defined $last) {
      put_cup($last, $what);
   } else {
#      die "oops" if defined $next[$what] or defined $prev[$what];
      $prev[$what] = $next[$what] = $current = $what;
   }
   $last = $what;
}

sub init_cups {
   my $pad = shift;
   my ($min, $max);
   for my $cup (@_) {
      $min = $cup if $min > $cup or not defined $min;
      $max = $cup if $max < $cup;
      new_cup($cup);
   }
   new_cup($_) for $max+1..$pad;
   $lowest = $min;
   $highest = $pad > $max ? $pad : $max;
}

sub crab {
   my @taken;
   for (1..3) {
      push @taken, $next[$current];
      get_cup($taken[-1]);
   }
   my $target = $current;
   do {
      $target = $target == $lowest ? $highest : $target - 1;
   } until defined $next[$target];
   while (@taken) {
      put_cup($target, pop @taken);
   }
   $current = $next[$current];
}

#####
# p0 args: NNNNNNNNN 0 100 8
# p1 args: NNNNNNNNN 1000000 10000000 2

my ($init, $pad, $turns, $print) = @ARGV;
init_cups($pad, split(//, $init));
crab() for 1..$turns;
my $cursor = 1;
for (1..$print) {
   $cursor = $next[$cursor];
   print $cursor;
}
