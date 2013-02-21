#!/bin/bash

name0="cmass_dr10_north_ir4"
nameend=".v5.1.wght.txt"
randname="cmass_dr10_north_randoms_ir4_combined.v5.1.wght.txt"
sscale=4800.0
FFT="FFT"
power="power_"

for P0 in 0 10000 20000 30000 40000
do
    for i in {1..1}
    do
        echo $i
        echo $P0
        if [ $i -lt 10 ] 
        then 
            FFTname[$i]=$FFT$name0"00"$i$nameend"P0"$P0
            powername[$i]=$power$name0"00"$i$nameend"P0"$P0
        elif [ $i -lt 100 ]
        then 
            FFTname[$i]=$FFT$name0"0"$i$nameend"P0"$P0
            powername[$i]=$power$name0"0"$i$nameend"P0"$P0
        else 
            FFTname[$i]=$FFT$name0$i$nameend"P0"$P0
            powername[$i]=$power$name0$i$nameend"P0"$P0
        fi 
        ./power-fkp-mock.exe $FFT$randname"P0"$P0 ${FFTname[$i]} ${powername[$i]} $sscale
    done
done
