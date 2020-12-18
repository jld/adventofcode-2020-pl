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
      my ($n, $inner) = /(\d+) ([a-z ]+) bags?/;
      die "bad bag: $_" unless defined $inner;
      die "inconsistent: $outer -> $inner"
        if defined $inner{$outer}{$inner} or defined $outer{$inner}{$outer};
      $inner{$outer}{$inner} = $outer{$inner}{$outer} = $n;
   }
}

sub reachable {
   my ($map, $start) = @_;
   my %found = ( $start => 1 );
   my @looking = ( $start );
   while (@looking) {
      my $here = shift @looking;
      for my $there (keys %{$map->{$here}}) {
         next if $found{$there};
         $found{$there} = 1;
         push @looking, $there;
      }
   }
   return keys %found;
}

sub contents {
   my ($cache, $start) = @_;
   return $cache->{$start} if defined $cache->{$start};
   my $n = 0;
   for my $inner (keys %{$inner{$start}}) {
      $n += $inner{$start}{$inner} * (contents($cache, $inner) + 1);
   }
   return ($cache->{$start} = $n);
}

my @can_has_gold = reachable(\%outer, "shiny gold");
print $#can_has_gold;
print contents({}, "shiny gold");
