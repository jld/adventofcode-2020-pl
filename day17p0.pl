#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my %init;
{
   my ($x,$y,$z) = (0,0,0);
   while (<>) {
      chomp;
      while (/(.)/g) {
         $init{$x, $y, $z} = 1 if $1 ne ".";
         ++$x;
      }
      ++$y;
      $x = 0;
   }
}

sub cycle {
   my ($prev) = @_;
   my %neigh;
   for my $k (keys %$prev) {
      my ($x, $y, $z) = split /$;/,$k;
      for my $dx (-1..1) {
         for my $dy (-1..1) {
            for my $dz (-1..1) {
               next unless $dx || $dy || $dz;
               ++$neigh{$x+$dx, $y+$dy, $z+$dz};
            }
         }
      }
   }

   my %next;
   for my $k (keys %neigh) {
      my $neigh = $neigh{$k};
      my ($x, $y, $z) = split /$;/,$k;
      $next{$x, $y, $z} = 1 if
        $neigh == 3 || $neigh == 2 && defined $prev->{$x, $y, $z};
   }
   return \%next;
}

my $state = \%init;
$state = cycle($state) for 1..6;
print scalar %$state;
