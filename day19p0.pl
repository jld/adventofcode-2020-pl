#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @rules;
while (<>) {
   last unless /./;
   my ($lhs, $rhs) = /^(\d+): ("."|[\d |]*)$/;
   die "rule syntax error" unless defined $rhs;
   die "ambiguous rule for $lhs" if defined $rules[$lhs];
   if ($rhs =~ /^"(.)"$/) {
      $rules[$lhs] = $1;
   } else {
      $rules[$lhs] = [map { [split / /] } split / \| /,$rhs];
   }
}

# To check if this idea was going to work:
my @rsize;
sub rsize {
   my ($r) = @_;
   return $rsize[$r] if defined $rsize[$r];
   return ($rsize[$r] = 1) unless ref $rules[$r];
   my $tl = 0;
   for my $term (@{$rules[$r]}) {
      for my $factor (@$term) {
         $tl += rsize($factor);
      }
   }
   return ($rsize[$r] = $tl);
}

# The idea:
my @comp;
sub comp {
   my ($a) = @_;
   return $comp[$a] if defined $comp[$a];
   my $r = $rules[$a];
   return ($comp[$a] = ref $r ? comp_sum($r) : qr/$r/);
}

sub comp_sum {
   my ($ts) = @_;
   die "no terms?" unless @$ts;
   my $acc = comp_prod($$ts[0]);
   for my $t (@$ts[1..$#$ts]) {
      my $tre = comp_prod($t);
      $acc = qr/$acc|$tre/;
   }
   return $acc;
}

sub comp_prod {
   my ($fs) = @_;
   die "no factors?" unless @$fs;
   my $acc = comp($$fs[0]);
   for my $f (@$fs[1..$#$fs]) {
      my $fre = comp($f);
      $acc = qr/$acc$fre/;
   }
   return $acc;
}

my $re = comp(0);
my $n = 0;
while (<>) {
   ++$n if /^$re$/;
}
print $n;
