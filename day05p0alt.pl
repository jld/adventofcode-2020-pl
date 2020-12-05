#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

open STDOUT, "| sort -n | tail -1" or die $!;
while (<>) {
   y/FBLR/0101/;
   print oct "0b$_";
}
close STDOUT;
