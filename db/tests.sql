SELECT (
	(SELECT music.octave_difference('G3'))*12 + 
	(SELECT semitones_from_A4 from music.chromatic_scale where note=(( SELECT note from music.international_pitch_notations where notation='G3' ) ))
); 

SELECT music.frequency_of_note(n=>'E4', n0=>'A4', f0=>440.0 );
SELECT music.frequency_of_note(n=>'E4');
SELECT music.frequency_of_note('E4');