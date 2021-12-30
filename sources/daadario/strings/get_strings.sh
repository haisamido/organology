
no=($(seq 900 1161))

# 1566 Titanium T4501

# for n in "${no[@]}"
# do
#   echo -n $n 
# #  wget -q -O - https://www.daddario.com/products/guitar/single-strings/classical-basses/pro-arte-basses/item/daddario-$n | egrep '<span id="product-code">|<span id="product-subtitle-text">' | tr '\n' ' '
#   wget https://www.daddario.com/products/guitar/single-strings/classical-basses/pro-arte-basses/item/daddario-$n &
#   echo
# done

exit

for n in "${no[@]}"
do
  file="daddario-${n}"
  echo -n "$n|"
  cat ./$file | egrep '<span id="product-code">|<span id="product-subtitle-text">|{"event":"productDetails","ecommerce":{"currencyCode":'\
    | perl -ne 's/\n|\R/\|/g;print $_;' \
    | perl -ne 's/\s+\<span/\<span/g;print $_;' \
    | perl -ne 's/\s+/ /g;print $_;' \
    | perl -ne 's/\)\;//g;print $_;' \
    | perl -ne 's/\<span id\=\"product-subtitle-text\"\>//g;print $_;' \
    | perl -ne 's/\<\/span\>//g;print $_;' \
    | perl -ne 's/\<span id\=\"product-code\"\>//g;print $_;'
  echo
done

