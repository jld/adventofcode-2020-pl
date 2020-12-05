#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

while (<>) {
   chomp;
   y/FBLR/0101/;
   print oct "0b$_";
}
