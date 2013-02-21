#!/bin/bash
dir="/mount/chichipio2/hahn/data/manera_mock/"
name0=$dir"cmass_dr10_north_ir4"
nameend=".v5.1.wght.txt"
nbarfname=$dir"nbar-dr10v5-N-Anderson.dat"
tmp=$dir"tmp.tmp"
Rbox=1200.0

for i in {302..600}
do
    echo $i
    if [ $i -lt 10 ]
    then
        fname[$i]=$name0"00"$i$nameend
    elif [ $i -lt 100 ]
    then 
        fname[$i]=$name0"0"$i$nameend
    else 
        fname[$i]=$name0$i$nameend
    fi

    tail -n +6 ${fname[$i]} > $tmp
    mv $tmp ${fname[$i]}
done
