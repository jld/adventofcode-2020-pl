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

my %where;
my %stuff;
my @stuff;
while (<>) {
   my ($singr, $sall) = /^([a-z ]+) \(contains ([a-z, ]+)\)$/;
   die "bad input syntax" unless defined $sall;
   my @ingr = split / /, $singr;
   my @all = split /, /, $sall;
   for my $all (@all) {
      $where{$all} = isect($where{$all}, @ingr);
   }
   @stuff{@ingr} = map { 1 } @ingr;
   push @stuff, @ingr;
}

my %sus;
for my $ohno (values %where) {
   @sus{keys %$ohno} = values %$ohno;
}

print scalar grep { not defined $sus{$_} } @stuff;
