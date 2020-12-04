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

sub yearp {
   my ($lb,$ub) = @_;
   return sub {
      length == 4 && $lb <= $_ && $_ <= $ub
   }
}

my %valid =
  (byr => yearp(1920, 2002),
   iyr => yearp(2010, 2020),
   eyr => yearp(2020, 2030),
   hgt => sub {
      ((/^(\d+)cm$/ && 150 <= $1 && $1 <= 193) ||
       (/^(\d+)in$/ && 59 <= $1 && $1 <= 76))
   },
   hcl => sub { /^#[0-9a-f]{6}$/ },
   ecl => sub { /^(amb|blu|brn|gry|grn|hzl|oth)$/ },
   pid => sub { /^[0-9]{9}$/ },
  );

sub validp {
   my $pp = shift;
   for my $k (keys %valid) {
      $_ = $pp->{$k};
      return "" unless defined && $valid{$k}();
   }
   return 1;
}

my $good = 0;
for my $pp (@ppp) {
   ++$good if validp($pp);
}
print $good;
