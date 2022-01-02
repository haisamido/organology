SELECT music.frequency_by_interval(f0=>440.0,intervals=>12, n=>0);
SELECT music.frequency_by_interval(f0=>440.0, n=>1);
SELECT music.frequency_by_interval(440.0,12,1);

-- Item#,Unit Weight,g',f',e',d',c',b,a,g
-- PL009,.00001794,18.6,14.7,** 13.1 **,10.4,8.3,7.4,5.8,4.6
-- tension   = 13.1 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), FROM F=ma
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against PL009 spec by Daadario
SELECT music.derive_mass_per_length(tension=>13.1*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,g',f',e',d',c',b,a,g
-- PL0095,.00001999,20.7,16.4,** 14.6 **,11.6,9.2,8.2,6.5,5.2
-- tension   = 14.6 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), FROM F=ma
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against PL0095 spec by Daadario
SELECT music.derive_mass_per_length(tension=>14.6*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4301,.00002024,16.6,** 14.8 **,11.8,9.3,8.3,6.6,5.2,4.2
-- tension   = 14.8 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), FROM F=ma, 444822.16152605
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.derive_mass_per_length(tension=>14.8*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4503/EXP,.00004679,38.4,** 34.2 **,27.2,21.6,19.2,15.2,12.1,9.6
-- tension   = 34.2 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), FROM F=ma, 444822.16152605
-- frequency = 329.63 Hz, i.e. E4 (e')
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.derive_mass_per_length(tension=>34.2*453.59237*980.665,frequency=>329.63,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4503/EXP,.00004679,38.4,34.2,27.2,21.6,** 19.2 **,15.2,12.1,9.6
-- tension   = 19.2 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), FROM F=ma, 444822.16152605
-- frequency = 246.9 Hz, i.e. B3 (b)
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.derive_mass_per_length(tension=>19.2*453.59237*980.665,frequency=>246.9,scale_length => 25.5*2.54)/178.58;

-- Item#,Unit Weight,g',f',e',d',c',b,a,g
-- PL009,.00001794,18.6,14.7,** 13.1 **,10.4,8.3,7.4,5.8,4.6
-- tension   = 13.1 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), FROM F=ma
-- frequency = 329.63 Hz, i.e. E4 (e') [RETURNS THIS]
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against PL009 spec by Daadario
SELECT music.frequency_FROM_mass_per_length(tension=>13.1*453.59237*980.665,mass_per_length=>0.00001794*178.58,scale_length=>25.5*2.54);
  
-- Item#,Unit Weight,f',e',d',c',b,a,g,f
-- J4503/EXP,.00004679,38.4,34.2,27.2,21.6,** 19.2 **,15.2,12.1,9.6
-- tension   = 19.2 lb mass * 453.59237*980.665 to convert to ~Newtons (g*cm/s**2), FROM F=ma, 444822.16152605
-- frequency = 246.9 Hz, i.e. B3 (b) [RETURNS THIS]
-- length  = 25.5 inches * 2.54 to convert inches to cm
-- 178.58  = needed to convert g/m to lb/in to check results against J4301 spec by Daadario
SELECT music.frequency_FROM_mass_per_length(tension =>19.2*453.59237*980.665,mass_per_length=>.00004679*178.58,scale_length=>25.5*2.54);

-- return the number of intervals away FROM A4 which is needed to determine the frequency relative to A4
SELECT (
	(SELECT music.octave_difference('G3'))*12 + 
	(SELECT semitones_FROM_A4 FROM music.chromatic_scale WHERE note=(( SELECT note FROM music.international_pitch_notations WHERE notation='G3' ) ))
); 

-- return the number of intervals away FROM A4 which is needed to determine the frequency
SELECT music.frequency_by_interval(
	n=>(
		SELECT (
			(SELECT music.octave_difference('A0'))*12 + 
			(SELECT semitones_FROM_A4 FROM music.chromatic_scale WHERE note=(( SELECT note FROM music.international_pitch_notations WHERE notation='A0' ) ))
		)
	)
);

( SELECT (
	(SELECT octave_number FROM music.international_pitch_notations WHERE notation='G3')-
	(SELECT octave_number FROM music.international_pitch_notations WHERE notation='A4')
) ) ;

SELECT music.frequency_by_notation(n=>'E4', n0=>'A4', f0=>440.0 );
SELECT music.frequency_by_notation(n=>'E4');
SELECT music.frequency_by_notation('E4');


SELECT * FROM music.view_frequency_by_notation;

SELECT * FROM view_strings;

SELECT music.frequency_by_notation(n=>notation, n0=>'A4', f0=>440.0),* FROM music.international_pitch_notations;

SELECT music.string_frequency(scale_length=>25.625*2.54,density=>7.726,diameter=>0.00899*2.54,tension=>13.1*453.59237*980.655);
