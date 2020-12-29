#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

sub isect {
   my $prior = shift;
   my %isect;
   for my $k (@_) {
      $isect{$k} = 1 unless defined $prior and not defined $prior->{$k};
   }
   return \%isect;
}

my %atoi;
my %ingr;
while (<>) {
   my ($singr, $sall) = /^([a-z ]+) \(contains ([a-z, ]+)\)$/;
   die "bad input syntax" unless defined $sall;
   my @ingr = split / /, $singr;
   my @all = split /, /, $sall;
   for my $all (@all) {
      $atoi{$all} = isect($atoi{$all}, @ingr);
   }
   @ingr{@ingr} = map { 1 } @ingr;
}

my %itoa;
while (%itoa < %atoi) {
   for my $all (keys %atoi) {
      my @is = grep { not defined $itoa{$_} } keys %{$atoi{$all}};
      next unless @is == 1;
      $itoa{$is[0]} = $all;
   }
}

for my $ingr (keys %itoa) {
   print "$ingr contains $itoa{$ingr}";
}
print;
print join(",", sort { $itoa{$a} cmp $itoa{$b} } keys %itoa);
