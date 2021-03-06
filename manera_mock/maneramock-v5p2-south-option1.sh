#!/bin/bash
#When changing the box size, grid size, or bin size the FFT and power code must each be manually adjusted.

name0="cmass_dr10_south_ir4"
nameend=".v5.2.wghtv.txt"
randname="cmass_dr10_south_randoms_ir4_combined_wboss.v5.2.wghtv.txt"
nbarfname="nbar-dr10v5-S-Anderson.dat"
P0=20000
sscale=3600.0
Rbox=1800.0
box="3600"
FFT="FFT"
power="power_"
grid="360"

ifort -O3 -o FFT-fkp-mock-wboss-v5p2-south.exe FFT-fkp-mock-wboss-v5p2-south.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

for i in {1..600}
do
    echo $i
    if [ $i -lt 10 ]
    then
        fname[$i]=$name0"00"$i$nameend
        FFTname[$i]=$FFT$name0"00"$i$nameend".grid"$grid".P0"$P0".box"$box
    elif [ $i -lt 100 ]
    then
        fname[$i]=$name0"0"$i$nameend
        FFTname[$i]=$FFT$name0"0"$i$nameend".grid"$grid".P0"$P0".box"$box
    else
        fname[$i]=$name0$i$nameend
        FFTname[$i]=$FFT$name0$i$nameend".grid"$grid".P0"$P0".box"$box
    fi
    echo ${fname[$i]}
    echo ${FFTname[$i]}
    ./FFT-fkp-mock-wboss-v5p2-south.exe $Rbox 0 $P0 $nbarfname ${fname[$i]} ${FFTname[$i]}
done 

dir="/mount/riachuelo1/hahn/FFT/manera_mock/v5p2/"
FFTrandname=$FFT$randname".grid"$grid".P0"$P0".box"$box
if [ -a $dir${FFTname[$i]} ]
then
    echo ${FFTname[$i]}" EXISTS"
else
    echo ${FFTname[$i]}" DOES NOT EXIST"
    ./FFT-fkp-mock-wboss-v5p2-south.exe $Rbox 1 $P0 $nbarfname $randname ${FFTname[$i]}
fi

ifort -O3 -o power-fkp-mock-wboss-v5p2-south.exe power-fkp-mock-wboss-v5p2-south.f

for i in {1..600}
do
    echo $i
    echo $P0
    if [ $i -lt 10 ]
    then
        powername=$power$name0"00"$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
    elif [ $i -lt 100 ]
    then
        powername=$power$name0"0"$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
    else
        powername=$power$name0$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
    fi
    ./power-fkp-mock-wboss-v5p2-south.exe $FFTrandname ${FFTname[$i]} $powername $sscale
    echo $powername
done    
