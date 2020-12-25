#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my (@fields, $mine, @theirs);

sub get_line () {
   $_ = <>;
   die "unexpected EOF" unless defined;
   chomp;
}

sub expect_str ($) {
   get_line;
   die "unexpected line \"$_\" (expected \"$_[0]\")" unless $_ eq $_[0];
}

while (<>) {
   last unless /./;
   my ($name, $stuff) = /^(.+?): ([-0-9 or]*)$/;
   die "bad field spec" unless defined $stuff;
   my $pred = [map { [split /-/] } split / or /, $stuff];
   push @fields, { name => $name, pred => $pred };
}

expect_str "your ticket:";
get_line;
$mine = [split /,/];
expect_str "";
expect_str "nearby tickets:";

while (<>) {
   chomp;
   push @theirs, [split /,/];
}

###

sub eval_pred {
   my ($pred, $n) = @_;
   for my $range (@$pred) {
      return 1 if $range->[0] <= $n && $n <= $range->[1];
   }
   return 0;
}

sub is_valid {
   my ($tk) = @_;
   N:
   for my $n (@$tk) {
      for my $field (@fields) {
         next N if eval_pred($field->{pred}, $n);
      }
      return 0;
   }
   return 1;
}

my @valid = grep { is_valid($_) } @theirs;

###

my @possible;
for my $i (0..$#fields) {
   FIELD:
   for my $field (@fields) {
      for my $tk (@valid) {
         next FIELD unless eval_pred($field->{pred}, $tk->[$i]);
      }
      push @{$possible[$i]}, $field->{name};
   }
}

my %found;
my $progress;
do {
   $progress = 0;
   for my $i (0..$#possible) {
      my @stuff = grep { not defined $found{$_} } @{$possible[$i]};
      next unless @stuff == 1;
      $found{$stuff[0]} = $i;
      $progress = 1;
   }
} while ($progress);

print "$_: $mine->[$found{$_}]" for sort keys %found;
print;

use bignum;
my $prod = 1;
$prod *= $mine->[$found{$_}] for grep { /^departure / } keys %found;
print $prod;
