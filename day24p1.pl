#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use List::Util qw/min max/;

my %dirs =
  (e => [2, 0],
   se => [1, -1],
   sw => [-1, -1],
   w => [-2, 0],
   nw => [-1, 1],
   ne => [1, 1]);

my %tiles;
while (<>) {
   my ($x,$y) = (0,0);
   while (/([sn]?[ew])/g) {
      my ($dx,$dy) = @{$dirs{$1}};
      $x += $dx;
      $y += $dy;
   }
   $tiles{$x,$y} ^= 1;
}

sub count {
   my $count;
   $count += $_ for values %tiles;
   return $count;
}

sub display {
   my ($thing, $aux) = @_;
   $aux //= {};
   my @xs = map { (split /$;/)[0] } keys %$thing;
   my @ys = map { (split /$;/)[1] } keys %$thing;
   @xs = (min @xs)..(max @xs);
   @ys = (min @ys)..(max @ys);
   for my $y (@ys) {
      my $line;
      for my $x (@xs) {
         my $v = $thing->{$x,$y} // " ";
         $line .= $aux->{$x,$y} ? "\033[1m$v\033[0m" : $v;
      }
      print $line;
   }
   print "-- ";
}

my $verb = !!$ENV{TILE_VERBOSE};
sub vdisp {
   display(@_) if $verb;
}

sub step {
   my %neigh;
   for my $tile (keys %tiles) {
      next unless $tiles{$tile};
      my ($x, $y) = split /$;/, $tile;
      for my $dir (values %dirs) {
         my ($dx, $dy) = @$dir;
         ++$neigh{$x+$dx, $y+$dy};
      }
   }
   vdisp(\%neigh, \%tiles);
   my %next;
   for my $tile (keys %neigh) {
      $next{$tile} = 1 if $neigh{$tile} == 2 || $tiles{$tile} && $neigh{$tile} == 1;
   }
   %tiles = %next;
}

for my $t (1..100) {
   step();
   vdisp(\%tiles);
   print "Day $t: ".count() if $t < 10 || ($t % 10) == 0;
   print "-- " if $verb;
}
