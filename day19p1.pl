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

sub match {
   my ($off, $what) = @_;
   my $r = $rules[$what];
   return ref $r ? match_alt($off, $r) : match_lit($off, $r);
}

sub match_lit {
   my ($off, $what) = @_;
   return ($what eq substr $_, $off, 1) ? { $off + 1, 1 } : { };
}

sub match_alt {
   my ($off, $what) = @_;
   my %acc;
   for my $alt (@$what) {
      my $ms = match_seq($off, $alt);
      @acc{keys %$ms} = values %$ms;
   }
   return \%acc;
}

sub match_seq {
   my ($off0, $what) = @_;
   my %last = ( $off0, 1 );
   for my $atom (@$what) {
      my %acc;
      for my $off (keys %last) {
         my $ms = match($off, $atom);
         @acc{keys %$ms} = values %$ms;
      }
      %last = %acc;
   }
   return \%last;
}

$rules[8] = [[42], [42, 8]];
$rules[11] = [[42, 31], [42, 11, 31]];

my $n = 0;
while (<>) {
   chomp;
   ++$n if defined ${match(0,0)}{(length)};
}
print $n;
