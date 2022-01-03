#!/usr/local/bin/bash

# UTF-8: /U+1D133 quarter-tone flat
# UTF-8: /U+1D132 quarter-tone sharp

octaves=$(seq -1 10)
# steps=( ♭ '/U+1D133' ':' '/U+1D132' ♯ )
steps=( ':' '#')

declare -A notes2solfege
notes2solfege['C']='Do'
notes2solfege['D']='Re'
notes2solfege['E']='Mi'
notes2solfege['F']='Fa'
notes2solfege['G']='Sol'
notes2solfege['A']='La'
notes2solfege['B']='Si'

declare -A aka
aka['B']='H'
aka['Si']='Ti'

notes=(C D E F G A B)

echo writing notes to ../db/insert_music.notes.sql
(
for note in ${notes[@]}
do
  for step in ${steps[@]}
  do
    alternative1=$( [[ ${aka[$note]+Y} ]] && echo "${aka[$note]}$step" || echo '')
    solfege=${notes2solfege[$note]}
    alternative2=$( [[ ${aka[$solfege]} ]] && echo "${aka[$solfege]}$step" || echo '' )
    # skipping B# and E# since they are analogous to C and F
    echo "INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('$note$step','$alternative1','${notes2solfege[$note]}$step','$alternative2');" \
      | sed 's/://g' | egrep -v 'B#|E#'
  done
done
) > ../db/insert_music.notes.sql

echo writing international_pitch_notations to ../db/insert_music.international_pitch_notations.sql
(
for octave in ${octaves[@]}
do
  for note in ${notes[@]}
  do
    for step in ${steps[@]}
    do
      ipn="${note}${step}${octave}"
      # skipping B# and E# since they are analogous to C and F
      echo "INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('$ipn','$note${step}',$octave);" \
        | sed 's/://g' | egrep -v 'B#|E#'
    done
  done
done
) > ../db/insert_music.international_pitch_notations.sql
