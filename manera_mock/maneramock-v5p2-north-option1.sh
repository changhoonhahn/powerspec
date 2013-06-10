#!/bin/bash

name0="cmass_dr10_north_ir4"
nameend=".v5.2.wghtv.txt"
randname="cmass_dr10_north_randoms_ir4_combined_wboss.v5.2.wghtv.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
FFT="FFT"
power="power_"
grid="360"

ifort -O3 -o FFT-fkp-mock-wboss-v5p2-north.exe FFT-fkp-mock-wboss-v5p2-north.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
datadir="/mount/chichipio2/hahn/data/manera_mock/v5p2/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/v5p2/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/v5p2/"

for P0 in 20000 
do
    for i in {1..2}
    do
        echo $i
        echo $P0
        if [ $i -lt 10 ]
        then
            fname[$i]=$datadir$name0"00"$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0"00"$i$nameend".grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            fname[$i]=$datadir$name0"0"$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0"0"$i$nameend".grid"$grid".P0"$P0".box"$box
        else
            fname[$i]=$datadir$name0$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0$i$nameend".grid"$grid".P0"$P0".box"$box
        fi
        echo ${fname[$i]}
        echo ${FFTname[$i]}
        ./FFT-fkp-mock-wboss-v5p2-north.exe $Rbox 0 $P0 $datadir$nbarfname ${fname[$i]} ${FFTname[$i]}
    done    

    FFTrandname=$FFTdir$FFT$randname".grid"$grid".P0"$P0".box"$box
    if [ -a $FFTrandname ]
    then
        echo $FFTrandname" exists"
    else
        echo $FFTrandname" did not exist"
        ./FFT-fkp-mock-wboss-v5p2-north.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$randname $FFTrandname
    fi


    ifort -O3 -o power-fkp-mock-wboss-v5p2-north.exe power-fkp-mock-wboss-v5p2-north.f

    for i in {1..2}
    do
        if [ $i -lt 10 ]
        then
            powername=$powerdir$power$name0"00"$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            powername=$powerdir$power$name0"0"$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
        else
            powername=$powerdir$power$name0$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
        fi
        ./power-fkp-mock-wboss-v5p2-north.exe ${FFTname[$i]} $FFTrandname $powername $sscale
        echo $powername
    done    
done

