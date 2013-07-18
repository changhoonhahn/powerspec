#!/bin/bash
dir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
name0=$dir"cmass_dr11_south_ir4"
nameend=".v7.0.wghtv.txt"
tmp=$dir"tmp.tmp"

for i in {1..610}
do
    echo $i
    if [ $i -lt 10 ]
    then
       fname=$name0"00"$i$nameend
    elif [ $i -lt 100 ]
    then 
        fname=$name0"0"$i$nameend
    else 
        fname=$name0$i$nameend
    fi

    tail -n +6 $fname > $tmp
    mv $tmp $fname
done
