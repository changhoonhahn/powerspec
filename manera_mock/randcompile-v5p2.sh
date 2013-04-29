#!/bin/bash

randname="cmass_dr10_north_randoms_ir4_combined.v5.2.wghtv.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
Rbox=2400.0
box="4800"
FFT="FFT"
grid="240"

ifort -O3 -o FFT-fkp-mock.exe FFT-fkp-mock.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

for P0 in 0 10000 20000 30000 40000
do
    FFTname[$i]=$FFT$randname".grid"$grid".P0"$P0".box"$box
    echo ${FFTname[$i]}
    
    ./FFT-fkp-mock.exe $Rbox 1 $P0 $nbarfname $randname ${FFTname[$i]}
done 
