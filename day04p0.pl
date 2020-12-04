#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @ppp = ({});
while (<>) {
   chomp;
   my @kvs = split /\s+/;
   if (@kvs) {
      for my $kv (@kvs) {
         my ($k, $v) = split /:/, $kv, 2;
         $ppp[-1]{$k} = $v;
      }
   } else {
      push @ppp, {};
   }
}

sub validp {
   my $pp = shift;
   for my $k (qw/byr iyr eyr hgt hcl ecl pid/) {
      return "" unless defined $pp->{$k};
   }
   return 1;
}

my $good = 0;
for my $pp (@ppp) {
   ++$good if validp($pp);
}
print $good;
