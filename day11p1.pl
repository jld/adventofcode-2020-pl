#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

use Bit::Vector;

my @lines;
my ($w, $h);
while (<>) {
   chomp;
   push @lines, $_;
   $w = length if $w < length;
   ++$h;
}
$w += 2;
$h += 2;
my $area = $w*$h;

my @di = (-$w-1, -$w, -$w+1, -1, 1, $w-1, $w, $w+1);

my $seats = Bit::Vector->new($area);
my $real = $seats->Shadow();

for my $y (0..$#lines) {
   my @cs = split //, $lines[$y];
   for my $x (0..$#cs) {
      my $i = ($y+1) * $w + ($x+1);
      my $c = $cs[$x];
      die "unexpected char '$c'" if $c =~ /[^.L]/;
      $seats->Bit_On($i) if $c eq "L";
      $real->Bit_On($i);
   }
}

my $last;
my $taken = $seats->Clone();
do {
   $last = $taken->Clone();
   for my $i (0..$area-1) {
      next unless $seats->contains($i);
      my $neigh = 0;
      for my $di (@di) {
         for (my $j = $i + $di; $real->contains($j); $j+=$di) {
            ++$neigh if $last->contains($j);
            last if $seats->contains($j);
         }
      }
      if ($last->contains($i)) {
         $taken->Bit_Off($i) if $neigh >= 5;
      } else {
         $taken->Bit_On($i) if $neigh == 0;
      }
   }
} until $taken->equal($last);

print $taken->Norm();
