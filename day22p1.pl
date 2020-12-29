#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

sub get_line () {
   $_ = <>;
   die "unexpected EOF" unless defined;
   chomp;
}

sub expect_str ($) {
   get_line;
   die "unexpected line \"$_\" (expected \"$_[0]\")" unless $_ eq $_[0];
}

sub get_deck () {
   my @deck;
   while (<>) {
      last unless /./;
      chomp;
      push @deck, $_;
   }
   return @deck;
}

my $gctr;
sub play {
   my $gn = ++$gctr;
   my $rn;
   my %seen;
   my ($ad, $bd) = @_;
   my @ad = @$ad;
   my @bd = @$bd;
   print STDERR "Game $gn: @{[scalar @ad]} vs. @{[scalar @bd]}";
   while (@ad && @bd) {
      ++$rn;
      my $ak = join ",", @ad;
      my $bk = join ",", @bd;
      return ([], 1) if defined $seen{$ak,$bk};
      $seen{$ak,$bk} = 1;

      my $ac = shift @ad;
      my $bc = shift @bd;
      print STDERR "Game $gn round $rn: $ac vs. $bc (@{[join',',@ad]} vs. @{[join',',@bd]})";
      if ($ac <= @ad && $bc <= @bd ? play([@ad[0..$ac-1]], [@bd[0..$bc-1]]) : $ac > $bc) {
         push @ad, $ac, $bc;
      } else {
         push @bd, $bc, $ac;
      }
   }
   my $aw = @ad > 0;
   print STDERR "Game $gn: P@{[2-$aw]}";
   return ([$aw ? @ad : @bd], $aw);
}

expect_str "Player 1:";
my @ad = get_deck();
expect_str "Player 2:";
my @bd = get_deck();

my ($wd) = play(\@ad, \@bd);

my $score;
for my $i (1..@$wd) {
   $score += $i * $$wd[-$i];
}
print $score;
