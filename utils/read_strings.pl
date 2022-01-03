#!/usr/bin/env perl -w

use strict;
use warnings;

my $db={};

while(<>) {
  next if( /^\s*#|^\s*$/);

  my $line = $_;
 
  my @line = split(',',$line);

#  $db->{guitar type} = 
  print $_;
}