#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

my $pid = open STDOUT, "|-";
die $! unless defined $pid;
unless ($pid) {
   open STDIN, "sort -n |" or die $!;
   my $last;
   while (<STDIN>) {
      print $last+1 if defined $last and $_ == $last+2;
      $last = $_;
   }
   close STDIN;
   exit 0;
}

while (<>) {
   y/FBLR/0101/;
   print oct "0b$_";
}
close STDOUT;
