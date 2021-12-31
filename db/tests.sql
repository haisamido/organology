-- return the number of intervals away from A4 which is needed to determine the frequency
SELECT (
	(SELECT music.octave_difference('G3'))*12 + 
	(SELECT semitones_from_A4 from music.chromatic_scale where note=(( SELECT note from music.international_pitch_notations where notation='G3' ) ))
); 

-- return the number of intervals away from A4 which is needed to determine the frequency
SELECT music.frequency_by_interval(
	n=>(
		SELECT (
			(SELECT music.octave_difference('A0'))*12 + 
			(SELECT semitones_from_A4 from music.chromatic_scale where note=(( SELECT note from music.international_pitch_notations where notation='A0' ) ))
		)
	)
);

( select (
	(select octave_number from music.international_pitch_notations where notation='G3')-
	(select octave_number from music.international_pitch_notations where notation='A4')
) ) ;

SELECT music.frequency_by_notation(n=>'E4', n0=>'A4', f0=>440.0 );
SELECT music.frequency_by_notation(n=>'E4');
SELECT music.frequency_by_notation('E4');

select * from view_strings;