#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my @prog;
while (<>) {
   die "asm error" unless /^(acc|jmp|nop) ([-+]\d+)$/;
   push @prog, [$1, $2];
}

sub loopfind {
   my ($prog) = @_;

   my $acc = 0;
   my $pc = 0;
   my %loop = ();

   my %step =
     (acc => sub { $acc += shift; $pc++; },
      jmp => sub { $pc += shift; },
      nop => sub { $pc++ }
     );

   until ($loop{$pc}) {
      return (0, $acc) if $pc > $#{$prog};
      $loop{$pc}++;
      my ($op, $arg) = @{$prog->[$pc]};
      $step{$op}($arg);
   }
   return (1, $acc);
}

print scalar loopfind(\@prog);

my %flip = ( nop => "jmp", jmp => "nop" );
for my $i (0..$#prog) {
   my $alt = $flip{$prog[$i][0]};
   next unless defined $alt;
   my @edit = @prog;
   $edit[$i] = [$alt, $prog[$i][1]];
   my ($loop, $acc) = loopfind(\@edit);
   next if $loop;
   print $acc;
}
