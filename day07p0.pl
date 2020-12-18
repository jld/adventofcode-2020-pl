#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my (%inner, %outer);
while (<>) {
   my ($outer, $cont) = /^([a-z ]+) bags contain (.+)\.$/;
   die "bad bag spec" unless defined $cont;
   next if $cont eq "no other bags";
   for (split /, /, $cont) {
      my ($inner) = /(?:\d+ )?([a-z ]+) bags?/;
      die "bad bag: $_" unless defined $inner;
      push @{$inner{$outer}}, $inner;
      push @{$outer{$inner}}, $outer;
   }
}

sub reachable {
   my ($map, $start) = @_;
   my %found = ( $start => 1 );
   my @looking = ( $start );
   while (@looking) {
      my $here = shift @looking;
      for my $there (@{$map->{$here}}) {
         next if $found{$there};
         $found{$there} = 1;
         push @looking, $there;
      }
   }
   return keys %found;
}

my @can_has_gold = reachable(\%outer, "shiny gold");
print $#can_has_gold;
