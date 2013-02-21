#!/bin/bash

randname="cmass_dr10_north_randoms_ir4_combined.v5.1.wght.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
Rbox=1200.0
FFT="FFT"

for P0 in 0 10000 20000 30000 40000
do
    FFTname[$i]=$FFT$randname"P0"$P0
    echo ${FFTname[$i]}
    
    ./FFT-fkp-mock.exe $Rbox 1 $P0 $nbarfname $randname ${FFTname[$i]}
done 
