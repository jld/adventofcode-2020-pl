#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 3; indent-tabs-mode: nil -*-
use strict;
$\="\n";

package Tile;

sub new { # id str* -> Self
   my ($class, $id, @rows) = @_;
   for my $i (1..$#rows) {
      die "width mismatch" if length $rows[$i] != length $rows[0];
   }
   return bless { id => $id, rows => [@rows] }, $class;
}

sub id { $_[0]{id} }
sub height { scalar @{$_[0]{rows}} }
sub width { length $_[0]{rows}[0] }

sub printout {
   my ($self, $fh) = @_;
   $fh //= \*STDOUT;
   local $_;
   print for @{$self->{rows}};
}

sub get {
   my ($self, $x, $y) = @_;
   return substr $self->{rows}[$y], $x, 1;
}

sub edge_t { $_[0]{rows}[0] }
sub edge_b { $_[0]{rows}[-1] }
sub edge_r { join "", map { substr $_,-1,1 } @{$_[0]{rows}} }
sub edge_l { join "", map { substr $_,0,1 } @{$_[0]{rows}} }

sub edges {
   my $self = shift;
   return ($self->edge_t(), $self->edge_b(), $self->edge_l(), $self->edge_r());
}

sub edges_sym {
   my $self = shift;
   my @es = $self->edges();
   return (@es, map { scalar reverse } @es);
}

sub flip_y {
   my $self = shift;
   Tile->new($self->id(), reverse @{$self->{rows}})
}

sub flip_x {
   my $self = shift;
   Tile->new($self->id(), map { scalar reverse } @{$self->{rows}})
}

sub flip_tr {
   my $self = shift;
   my ($w, $h) = ($self->width(), $self->height());
   return Tile->new($self->id(), map {
      my $y = $_;
      join "", map {
         my $x = $_;
         $self->get($y, $x)
      } 0..$w-1
   } 0..$h-1)
}

sub flips {
   my $self = shift;
   my @acc = ($self, $self->flip_y());
   @acc = (@acc, map { $_->flip_x() } @acc);
   return (@acc, map { $_->flip_tr() } @acc);
}

sub join_y {
   my ($self, $below) = @_;
   my ($sid, $bid) = ($self->id(), $below->id());
   Tile->new("${sid}/${bid}", @{$self->{rows}}, @{$below->{rows}})
}

sub join_x {
   my ($self, $right) = @_;
   my ($sid, $rid) = ($self->id(), $right->id());
   my $w = $self->height();
   die "height mismatch" if $w != $right->height();
   Tile->new("${sid}+${rid}", map { $self->{rows}[$_] . $right->{rows}[$_] } 0..$w-1)
}

sub trim {
   my $self = shift;
   my $sid = $self->id();
   my $rows = $self->{rows};
   Tile->new("[${sid}]", map { substr $_,1,-1 } @$rows[1..$#$rows-1])
}

package main;

my (%tiles, %index);

while (<>) {
   die "bad tile header" unless /^Tile (\d+):$/;
   my $tid = $1;
   die "ambiguous tile $tid" if defined $tiles{$tid};
   my @rows;
   while (<>) {
      last unless /./;
      chomp;
      push @rows, $_;
   }
   my $last = not defined $_; # Sigh.
   my $tile = Tile->new($tid, @rows);
   $tiles{$tid} = $tile;
   for my $edge ($tile->edges_sym()) {
      push @{$index{$edge}}, $tid;
   }

   last if $last;
}

# Every interior edge must appear at least twice, but the problem
# statement guarantees the inverse: the outside edges are unique.

sub hapax {
   my ($edge) = @_;
   @{$index{$edge}} == 1
}

sub outside {
   my ($tile) = @_;
   my @es = grep { hapax($_) } $tile->edges();
   return scalar @es;
}

# Conveniently, the given inputs use each edge either once or twice,
# so the entire grid can be laid out without backtracking.

my @layout;
my %used;

for my $tid (keys %tiles) {
   next unless outside($tiles{$tid}) == 2;
   $used{$tid} = 1;
   for my $tile ($tiles{$tid}->flips()) {
      next unless hapax($tile->edge_t) && hapax($tile->edge_l);
      $layout[0][0] = $tile;
      last;
   }
   last;
}

my $size = int(sqrt(%tiles));
die "not square?" unless %tiles == $size**2;

for my $y (0..$size-1) {
   for my $x (0..$size-1) {
      next unless $y || $x;
      my $tmpl = $y ? $layout[$y-1][$x]->edge_b() : $layout[$y][$x-1]->edge_r();
      for my $tid (@{$index{$tmpl}}) {
         next if defined $used{$tid};
         for my $tile ($tiles{$tid}->flips()) {
            next unless $tmpl eq ($y ? $tile->edge_t() : $tile->edge_l());
            $layout[$y][$x] = $tile;
            $used{$tile->id()} = 1;
            last;
         }
         last;
      }
      die "no match at ($x, $y)" unless defined $layout[$y][$x];
   }
}

###

for my $row (@layout) {
   print join(" ", map { $_->id() } @$row);
}
print;

my $image;
for my $y (0..$#layout) {
   my $band;
   for my $x (0..$#{$layout[$y]}) {
      my $tile = $layout[$y][$x]->trim();
      $band = $x ? $band->join_x($tile) : $tile;
   }
   $image = $y ? $image->join_y($band) : $band;
}
$image->printout();
