#!/bin/bash

name0="cmass_dr10_north_ir4"
nameend=".v5.2.wghtv.txt"
randname="cmass_dr10_north_randoms_ir4_combined_wboss.v5.2.wghtv.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
sscale=4800.0
Rbox=2400.0
box="4800"
FFT="FFT"
power="power_"
grid="240"

ifort -O3 -o FFT-fkp-mock-truered-rsdnbar-v5p2.exe FFT-fkp-mock-truered-rsdnbar-v5p2.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

for P0 in 0 10000 20000 30000 40000
do
    for i in {1..100}
    do
        echo $i
        if [ $i -lt 10 ]
        then
            fname[$i]=$name0"00"$i$nameend
            FFTname[$i]=$FFT$name0"00"$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            fname[$i]=$name0"0"$i$nameend
            FFTname[$i]=$FFT$name0"0"$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
        else
            fname[$i]=$name0$i$nameend
            FFTname[$i]=$FFT$name0$i$nameend"_truered_rsdnbar.grid"$grid".P0"$P0".box"$box
        fi
        echo ${fname[$i]}
        echo ${FFTname[$i]}
        ./FFT-fkp-mock-truered-rsdnbar-v5p2.exe $Rbox 0 $P0 $nbarfname ${fname[$i]} ${FFTname[$i]}
    done   
done

for P0 in 0 10000 20000 30000 40000
do
    for i in {1..100}
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
        ./power-fkp-mock-wboss-v5p2.exe $FFT$randname".grid"$grid".P0"$P0".box"$box ${FFTname[$i]} ${powername[$i]} $sscale
        echo ${powername[$i]}
    done
done


