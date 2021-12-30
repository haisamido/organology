#!/usr/local/bin/bash

# UTF-8: /U+1D133 quarter-tone flat
# UTF-8: /U+1D132 quarter-tone sharp

octaves=$(seq -1 10)
steps=( ♭ '/U+1D133' ':' '/U+1D132' ♯ )

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

for note in ${notes[@]}
do
  for step in ${steps[@]}
  do
    for octave in ${octaves[@]}
    do
      ipn="${note}${step}${octave}"
      echo "INSERT INTO music.international_pitch_notations (notation,note,octave_number) VALUES ('$ipn','$note${step}',$octave);" | sed 's/://g'
    done
  done
done
