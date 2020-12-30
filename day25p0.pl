#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

# Up to this point, I've been using `bignum` whenever numbers wouldn't
# fit in a 32-bit int, even though I'm on 64-bit, because portability
# is good, right?
#
# History time: when I learned Perl, the latest version was 5.005,
# where that would have been a problem.  Soon after, 5.6 was released
# with optional 64-bit support, including using double-precision ints
# for scalars.  But it was considered "experimental"; e.g., Debian
# appears to have not enabled it until 5.12.  However, we're now at
# 5.32 and it might be more or less safe to assume?
#
# But more importantly, `use bignum` increases the running time of this
# script from ~1 second to over 12 minutes.  So let's not do that.

my $mod = 20201227;
my $g = 7;

sub mexp {
   my ($b, $e) = @_;
   return 1 if $e == 0;
   return $b if $e == 1;
   my $acc = mexp($b, int($e/2));
   $acc = ($acc * $acc) % $mod;
   $acc = ($acc * $b) % $mod if $e % 2;
   return $acc;
}

sub dlog {
   my $pk = shift;
   my $n = 1;
   my $e = 0;
   while ($n != $pk) {
      ++$e;
      $n = ($n * $g) % $mod;
   }
   return $e;
}

my $pc = <>;
my $pd = <>;
my $qc = dlog($pc);
my $qd = dlog($pd);
print mexp($pc, $qd);
print mexp($pd, $qc);
