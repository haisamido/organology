#!/usr/local/bin/bash

# PURPOSE: generate insert statements for notes and international pitch notations

p=$(basename $PWD)
notes_sql=../db/insert_music.notes.sql
ipn_sql=../db/insert_music.international_pitch_notations.sql

# Octaves in the international pitch notation
octaves=$(seq -1 10)

# Chromatic notes
notes=(C 'C#' D 'D#' E F 'F#' G 'G#' A 'A#' B)

# Lookup Solfege for lettered note
declare -A notes2solfege
notes2solfege['C']='Do'
notes2solfege['C#']='Do#'
notes2solfege['D']='Re'
notes2solfege['D#']='Re#'
notes2solfege['E']='Mi'
notes2solfege['F']='Fa'
notes2solfege['F#']='Fa#'
notes2solfege['G']='Sol'
notes2solfege['G#']='Sol#'
notes2solfege['A']='La'
notes2solfege['A#']='La#'
notes2solfege['B']='Si'

# Lookup semitones fomr A4 in order to calculate frequency
declare -A semitones_from_A4
semitones_from_A4['C']=-9
semitones_from_A4['C#']=-8
semitones_from_A4['D']=-7
semitones_from_A4['D#']=-6
semitones_from_A4['E']=-5
semitones_from_A4['F']=-4
semitones_from_A4['F#']=-3
semitones_from_A4['G']=-2
semitones_from_A4['G#']=-1
semitones_from_A4['A']=0
semitones_from_A4['A#']=1
semitones_from_A4['B']=2

# Lookup alternative names for B and Si
declare -A aka
aka['B']='H'
aka['Si']='Ti'

echo writing notes to $notes_sql
echo "-- auto generated by ./$p/$0" > $notes_sql
( 
  for note in ${notes[@]}
  do
    solfege=${notes2solfege[$note]}
    echo "INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as,semitones_from_A4) VALUES ('$note','${aka[$note]}','${notes2solfege[$note]}','${aka[$solfege]}',${semitones_from_A4[$note]});"
  done 
) >> $notes_sql

echo writing international pitch notations to $ipn_sql
echo "-- auto generated by ./$p/$0" > $ipn_sql
(
for octave in ${octaves[@]}
do
  for note in ${notes[@]}
  do
    ipn="${note}${octave}"
    echo "INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('$ipn','$note',$octave);"
  done
done
) >> $ipn_sql
