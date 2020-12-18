#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my ($x, $y) = (0, 0);
my ($dx, $dy) = (1, 0);

sub turn {
   my ($cxy, $cyx, $n) = @_;
   die "bad angle $n" if $n != int($n);
   ($dx, $dy) = ($dy * $cxy, $dx * $cyx) for 1..$n;
}

my %cmds =
  (N => sub { $y -= shift; },
   S => sub { $y += shift; },
   E => sub { $x += shift; },
   W => sub { $x -= shift; },
   L => sub { turn(1, -1, (shift) / 90); },
   R => sub { turn(-1, 1, (shift) / 90); },
   F => sub { my $d = shift; $x += $d*$dx; $y += $d*$dy; },
  );

while (<>) {
   my ($cmd, $n) = /^([NSEWLRF])(\d+)$/;
   die "bad ship command" unless defined $n;
   $cmds{$cmd}($n);
}

print abs($x)+abs($y);
