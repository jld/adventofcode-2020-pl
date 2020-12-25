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

my $sum = 0;
for my $tk (@theirs) {
   for my $n (@$tk) {
      my $valid;
      for my $field (@fields) {
         if (eval_pred($field->{pred}, $n)) {
            $valid = 1;
            last;
         }
      }
      $sum += $n unless $valid;
   }
}
print $sum;
