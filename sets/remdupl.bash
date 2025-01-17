for a in *txt ; do 
  b=${a//.txt/_b}; 
  echo $b; 
  grep set $a > $b;
  grep -v set $a > tme;
  grep ";" $a > semi
  grep -v ";" tme > tmb
  cat < tmb | sort -u >> $b ;
  cat semi >> $b
done
