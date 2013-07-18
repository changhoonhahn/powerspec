#!/bin/bash

name0="cmass_dr11_north_ir4"
nameend=".v7.0.wghtv.txt"
randname="cmass_dr11_north_randoms_ir4_combined_wboss.v7.0.wghtv.txt"
nbarfname="nbar-cmass-dr11v0-N-Anderson.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
FFT="FFT"
power="power_"
grid="960"

ifort -O3 -o FFT-fkp-mock-dr11-v7p0-upweight_960grid.exe FFT-fkp-mock-dr11-v7p0-upweight_960grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

for P0 in 20000 
do
    for i in {2..100}
    do
        echo $i
        echo $P0
        if [ $i -lt 10 ]
        then
            fname=$datadir$name0"00"$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0"00"$i$nameend"_upweighted.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            fname=$datadir$name0"0"$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0"0"$i$nameend"_upweighted.grid"$grid".P0"$P0".box"$box
        else
            fname=$datadir$name0$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0$i$nameend"_upweighted.grid"$grid".P0"$P0".box"$box
        fi
        echo $fname
        echo ${FFTname[$i]}
        ./FFT-fkp-mock-dr11-v7p0-upweight_960grid.exe $Rbox 0 $P0 $datadir$nbarfname $fname ${FFTname[$i]}
    done    

    FFTrandname=$FFTdir$FFT$randname".grid"$grid".P0"$P0".box"$box
    if [ -a $FFTrandname ]
    then
        echo $FFTrandname" ALREADY EXISTS"
    else
        echo $FFTrandname" DOES NOT EXIST"
        ./FFT-fkp-mock-dr11-v7p0-upweight_960grid.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$randname $FFTrandname
    fi


    ifort -O3 -o power-fkp-mock-dr11-v7p0_960grid_480bin.exe power-fkp-mock-dr11-v7p0_960grid_480bin.f

    for i in {2..100}
    do
        if [ $i -lt 10 ]
        then
            powername=$powerdir$power$name0"00"$i$nameend"_upweighted.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            powername=$powerdir$power$name0"0"$i$nameend"_upweighted.grid"$grid".P0"$P0".box"$box
        else
            powername=$powerdir$power$name0$i$nameend"_upweighted.grid"$grid".P0"$P0".box"$box
        fi
        ./power-fkp-mock-dr11-v7p0_960grid_480bin.exe ${FFTname[$i]} $FFTrandname $powername $sscale
        echo $powername
    done    
done
