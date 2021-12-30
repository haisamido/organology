#!/usr/local/bin/bash

# UTF-8: /U+1D133 quarter-tone flat
# UTF-8: /U+1D132 quarter-tone sharp

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

    alternative1=$( [[ ${aka[$note]+Y} ]] && echo "${aka[$note]}$step" || echo '')
    solfege=${notes2solfege[$note]}
    alternative2=$( [[ ${aka[$solfege]} ]] && echo "${aka[$solfege]}$step" || echo '' )

    echo "INSERT INTO music.notes (note,note_also_known_as,solfege,solfege_also_known_as) VALUES ('$note$step','$alternative1','${notes2solfege[$note]}$step','$alternative2');" | sed 's/://g'
  done
done
