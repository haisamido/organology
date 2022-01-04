#!/usr/bin/env perl -w

use strict;
use warnings;
use Data::Dumper;
use open ':std', ':encoding(UTF-8)';
use List::MoreUtils qw(first_index);
use Scalar::Util qw(looks_like_number);

$Data::Dumper::Indent = 1;

my $units = {
  g0 =>{ 
    value => 9.
  },
  tension => {
    lb2kg => 453.592292/1000,
    comment => "actually this is in mass an not force"
  }
};

my $db={};

while(<>) {

  s/\R/\n/g;
  s/^\x{FEFF}//;

  next if( /^\s*\#|^\s*$/);

  chomp;
  my $line = $_;
 
  my (
    $manufacturer,
    $instrument_category,
    $instrument_name,
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

  $db->{manufacturers}->{$manufacturer}->{part_id}->{$part_id} = {
    instrument_category => $instrument_category,
    instrument_name     => $instrument_name,
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

}

#print Dumper $db;

foreach my $manufacturer ( keys %{$db->{manufacturers}} ) {

  foreach my $part_id ( sort keys %{$db->{manufacturers}->{$manufacturer}->{part_id}} ) {

    my $part        = $db->{manufacturers}->{$manufacturer}->{part_id}->{$part_id};
    my $m = $manufacturer;
    $m =~ s/\'/\'\'/g;
    my @tensions    = @{$part->{tensions}};
    my @note_ranges = @{$part->{ipn_range}};
    # Get the index in @note_ranges that the note appears in and use that to get the tension at note
    my $tension_index = first_index { $_ eq "$part->{string_note}" } @note_ranges;

    my $tension_maximum = $tensions[0];

    my $i=0;
    # determine the maximum tension for when the tension is set to not a number
    foreach my $tension ( @tensions ) {
      if( looks_like_number($tension) ) {
        $tension_maximum = $tensions[$i];
        last;
      } else {
        $i++;
      }
    }

    my $tension_at_note = $tensions[$tension_index];
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
  (SELECT manufacturer_id FROM manufacturers WHERE manufacturer_name='$m' AND manufacturer_type='strings'),
  '$part_id',
  '$part->{string_family}',
  (SELECT id FROM instruments WHERE type='stringed' AND category='$part->{instrument_category}' AND name='$part->{instrument_name}'),
  '$part->{string_note}',
  $part->{string_order},
  1.0$part->{diameter}*25.4,
  '$part->{string_tension_category}',
  '$part->{string_material}',
  $part->{mass_per_length}*453.592292/2.54,
  $part->{scale_length}*25.4,
  $tension_maximum*453.592292/1000,
  $tension_at_note*453.592292/1000,
  $tension_minimum*453.592292/1000,
  'ABC'
);

SQL_END

$SQL =~ s/\n//g;
$SQL =~ s/\s+/ /g;

print "$SQL\n";

  }
}

# select (
# 	100*( 0.00002065 - 
# 	(SELECT music.derive_mass_per_length(
# 		tension      => 9.5*453.592292*980.665,
# 		frequency    => music.frequency_by_notation('C4'),
# 		scale_length => 25.5*2.54)/178.579673) )/0.00002065
# );
