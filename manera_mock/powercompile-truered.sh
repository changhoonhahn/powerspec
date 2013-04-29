#!/bin/bash

name0="cmass_dr10_north_ir4"
nameend=".v5.1.wght.txt"
randname="cmass_dr10_north_randoms_ir4_combined_wboss.v5.1.wght.txt"
sscale=4800.0
box="4800"
FFT="FFT"
power="power_"
grid="240"

ifort -O3 -o power-fkp-mock.exe power-fkp-mock.f 

for P0 in 0 10000 20000 30000 40000
do
    for i in {1..10}
    do
        echo $i
        echo $P0
        if [ $i -lt 10 ] 
        then 
            FFTname[$i]=$FFT$name0"00"$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
            powername[$i]=$power$name0"00"$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then 
            FFTname[$i]=$FFT$name0"0"$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
            powername[$i]=$power$name0"0"$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
        else 
            FFTname[$i]=$FFT$name0$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
            powername[$i]=$power$name0$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
        fi 
        ./power-fkp-mock.exe $FFT$randname".grid"$grid".P0"$P0".box"$box ${FFTname[$i]} ${powername[$i]} $sscale
        echo ${powername[$i]}
    done
done
