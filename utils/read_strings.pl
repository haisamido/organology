#!/usr/bin/env perl -w

use strict;
use warnings;
use Data::Dumper;
use open ':std', ':encoding(UTF-8)';

$Data::Dumper::Indent = 1;

my $db={};

while(<>) {

  s/\R/\n/g;
  s/^\x{FEFF}//;

  next if( /^\s*\#|^\s*$/);

  chomp;
  my $line = $_;
 
  my (
    $manufacturer,
    $instrument_type,
    $string_family,
    $string_material,
    $part_id,
    $mass_per_length,
    $diameter,
    $t1,$t2,$t3,$t4,$t5,$t6,$t7,$t8,$tension_no,
    $string_set,
    $string_order,
    $string_ipn,
    $string_designtation,
    $tension_name,
    $source,
    $helmholtz,
    $ipn 
  ) = split(',',$line);

  my @tensions        = ($t1,$t2,$t3,$t4,$t5,$t6,$t7,$t8);
  my @helmholtz_range = split(/\|/, $helmholtz);
  my @ipn_range       = split(/\|/, $ipn);

#   for(my $i = 0; $i <= $#helmholtz_range; $i++){
#     print "$i $helmholtz_range[$i]\n";
# #    my $ipn->{};
#   }

#   exit;

  $db->{manufacturers}->{$manufacturer}->{instrument_types}->{$instrument_type}->{string_families}->{$string_family}->{part_id}->{$part_id} = {
    string_material     => $string_material,
    mass_per_length     => $mass_per_length,
    diameter            => $diameter,
    tensions            => \@tensions,
    tension_no          => $tension_no,
    string_set          => $string_set,
    string_order        => $string_order,
    string_ipn          => $string_ipn,
    string_designtation => $string_designtation,
    tension_name        => $tension_name,
    source              => $source,
    helmholtz_range     => \@helmholtz_range,
    ipn_range           => \@ipn_range
  };
  print $_;
}

print Dumper $db;