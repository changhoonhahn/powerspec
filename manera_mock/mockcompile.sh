#!/bin/bash

name0="cmass_dr10_north_ir4"
nameend=".v5.1.wght.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
Rbox=2400.0
FFT="FFT"

for P0 in 0 10000 20000 30000 40000
do 
    for i in {1..1}
    do
        echo $i
        if [ $i -lt 10 ]
        then
            fname[$i]=$name0"00"$i$nameend
            FFTname[$i]=$FFT$name0"00"$i$nameend"P0"$P0
        elif [ $i -lt 100 ]
        then 
            fname[$i]=$name0"0"$i$nameend
            FFTname[$i]=$FFT$name0"0"$i$nameend"P0"$P0
        else 
            fname[$i]=$name0$i$nameend
            FFTname[$i]=$FFT$name0$i$nameend"P0"$P0
        fi
        echo ${fname[$i]}
        echo ${FFTname[$i]}
        ./FFT-fkp-mock.exe $Rbox 0 $P0 $nbarfname ${fname[$i]} ${FFTname[$i]}
    done
done 
