#!/bin/bash

for i in {1..25}; do 
    echo $RANDOM
done

if [ -a "file.dat" ] 
then 
    echo "asdfadf"
else 
    echo "asdfasdfasdfasdf"
fi 

if [ -a "file.dat" -o ! -a "asdfasdf.dat" ]; then
   echo "asdfadf"; echo "asdasdfasdfasdf"; echo "1334124"
else 
    echo "asdfasdfasdfasdf"
fi 
n=0
for i in {1..25}; do 
    (( n += 1 ))
    echo $n
done
read n 
for j in $(seq 1 $n); do 
    echo $j 
done 

MODDATE=$(stat -c %y fibcoll_nbar_comp.pro)
MODDATE=${MODDATE%% *}
echo $MODDATE
file="fibcoll_nbar_comp.pro"
date -r $file +%F
