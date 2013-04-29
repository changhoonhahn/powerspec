#!/bin/bash
name0="cmass_dr10_north_ir4"
nameend=".v5.2.wghtv.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
randname="cmass_dr10_north_randoms_ir4_combined.v5.2.wghtv.txt"
sscale=4800.0
Rbox=2400.0
box="4800"
FFT="FFT"
power="power_"
grid="240"
dir="/mount/chichipio2/hahn/FFT/manera_mock/v5p2/"
for P0 in 0 10000 20000 30000 40000
do
    FFTname[$i]=$FFT$randname".grid"$grid".P0"$P0".box"$box
    if [ -a $dir${FFTname[$i]} ]
    then
        echo ${FFTname[$i]}
    else
        echo "no"
    fi
done

