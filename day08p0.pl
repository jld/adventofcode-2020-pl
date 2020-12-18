#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @prog;
while (<>) {
   die "asm error" unless /^(acc|jmp|nop) ([-+]\d+)$/;
   push @prog, [$1, $2];
}

my $acc = 0;
my $pc = 0;
my %loop = ();

my %step =
  (acc => sub { $acc += shift; $pc++; },
   jmp => sub { $pc += shift; },
   nop => sub { $pc++ }
  );

until ($loop{$pc}) {
   $loop{$pc}++;
   my ($op, $arg) = @{$prog[$pc]};
   $step{$op}($arg);
}
print $acc;
