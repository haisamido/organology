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
    $scale_length,
    $t1,$t2,$t3,$t4,$t5,$t6,$t7,$t8,
    $string_set,
    $string_order,
    $string_note,
    $string_designtation,
    $string_tension_category,
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

  $db->{manufacturers}->{$manufacturer}->{instrument_types}->{$instrument_type}->{part_id}->{$part_id} = {
    string_material     => $string_material,
    mass_per_length     => $mass_per_length,
    string_family       => $string_family,
    diameter            => $diameter,
    scale_length        => $scale_length,
    tensions            => \@tensions,
    string_set          => $string_set,
    string_order        => $string_order,
    string_note         => $string_note,
    string_designtation => $string_designtation,
    string_tension_category => $string_tension_category,
    source              => $source,
    helmholtz_range     => \@helmholtz_range,
    ipn_range           => \@ipn_range
  };
  #print $_;
}

#print Dumper $db;

foreach my $manufacturer ( keys %{$db->{manufacturers}} ) {
  foreach my $instrument_type ( keys %{$db->{manufacturers}->{$manufacturer}->{instrument_types}} ) {
    foreach my $part_id ( sort keys %{$db->{manufacturers}->{$manufacturer}->{instrument_types}->{$instrument_type}->{part_id}} ) {
      my $part = $db->{manufacturers}->{$manufacturer}->{instrument_types}->{$instrument_type}->{part_id}->{$part_id};

      my @tensions = @{$part->{tensions}};
      my $tension_maximum = $tensions[0];
      my $tension_minimum = $tensions[$#tensions];

      my $SQL = << "SQL_END";

INSERT INTO strings(
  manufacturer_id,
  part_id,
  string_family,
  instrument_id,
  string_note,
  string_order,
  string_diameter,
  string_tension_category,
  string_material,
  mass_per_length,  
  scale_length,
  tension_maximum,
  tension_at_note,
  tension_minimum,
  description
) VALUES (
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='$manufacturer' AND manufacturer_type='strings'),
  '$part_id',
  '$part->{string_family}',
  (SELECT id FROM instruments WHERE type='stringed' AND category='classical' AND name='guitar'),
  '$part->{string_note}',
  $part->{string_order},
  $part->{diameter}*25.4,
  '$part->{string_tension_category}',
  '$part->{string_material}',
  $part->{mass_per_length}*453.592292/2.54,
  $part->{scale_length}*25.4,
  $tension_maximum*453.592292/1000,
  11.2*453.592292/1000,
  $tension_minimum*453.592292/1000,
  'ABC'
);

SQL_END

$SQL =~ s/\n//g;
$SQL =~ s/\s+/ /g;

print "$SQL\n";

    }
  }
}
# select (
# 	100*( 0.00002065 - 
# 	(SELECT music.derive_mass_per_length(
# 		tension      => 9.5*453.592292*980.665,
# 		frequency    => music.frequency_by_notation('C4'),
# 		scale_length => 25.5*2.54)/178.579673) )/0.00002065
# );
