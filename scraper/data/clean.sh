rm -f all2010.csv
cat *2010.csv > all2010.csv
awk -F"," '{for(i=3;i<=17;i++) {printf "%s,%d,%s,%s\n", $1,i-2,$2, $i}}' all2010.csv > allClean2010.csv

rm -f all2011.csv
cat *2011.csv > all2011.csv
awk -F"," '{for(i=3;i<=17;i++) {printf "%s,%d,%s,%s\n", $1,i-2,$2, $i}}' all2011.csv > allClean2011.csv

rm -f all2012.csv
cat *2012.csv > all2012.csv
awk -F"," '{for(i=3;i<=17;i++) {printf "%s,%d,%s,%s\n", $1,i-2,$2, $i}}' all2012.csv > allClean2012.csv
