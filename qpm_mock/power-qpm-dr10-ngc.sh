#!/bin/bash

name0="a0.6452_"
nameend=".dr10_ngc.rdzw"
randname="a0.6452_rand100x.dr10_ngc.rdzw"
nbarfname="nbar-qpm-dr10v5-N-Anderson.dat"
sscale=4000.0
Rbox=2000.0
box="4000"
FFT="FFT-"
power="power-"
grid="360"

ifort -O3 -o FFT-fkp-qpm-mock-weight.exe FFT-fkp-qpm-mock-weight.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
nbardir="/mount/riachuelo1/hahn/data/qpm_mock/"
datadir="/mount/riachuelo1/mcbride/QPM/dr10_ngc/"
randdir="/mount/riachuelo1/mcbride/QPM/randoms/"
FFTdir="/mount/riachuelo1/hahn/FFT/qpm_mock/"
powerdir="/mount/riachuelo1/hahn/power/qpm_mock/"

for P0 in 20000 
do
    for i in {500..600}
    do
        echo $i
        echo $P0
        if [ $i -lt 10 ]
        then
            fname[$i]=$datadir$name0"000"$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0"000"$i$nameend".grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            fname[$i]=$datadir$name0"00"$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0"00"$i$nameend".grid"$grid".p0"$p0".box"$box
        elif [ $i -lt 1000 ]
        then
            fname[$i]=$datadir$name0"0"$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0"0"$i$nameend".grid"$grid".p0"$p0".box"$box
        else
            fname[$i]=$datadir$name0$i$nameend
            FFTname[$i]=$FFTdir$FFT$name0$i$nameend".grid"$grid".P0"$P0".box"$box
        fi
        echo ${fname[$i]}
        echo ${FFTname[$i]}

        ./FFT-fkp-qpm-mock-weight.exe $Rbox 0 $P0 $nbardir$nbarfname ${fname[$i]} ${FFTname[$i]}
    done    

    FFTrandname=$FFTdir$FFT$randname".grid"$grid".P0"$P0".box"$box
    if [ -a $FFTrandname ]
    then
        echo $FFTrandname" exists"
    else
        echo $FFTrandname" did not exist"
        ./FFT-fkp-qpm-mock-weight.exe $Rbox 1 $P0 $nbardir$nbarfname $randdir$randname $FFTrandname
    fi


    ifort -O3 -o power-fkp-qpm-mock-weight.exe power-fkp-qpm-mock-weight.f

    for i in {500..600}
    do
        if [ $i -lt 10 ]
        then
            powername=$powerdir$power$name0"000"$i$nameend"_weight.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            powername=$powerdir$power$name0"00"$i$nameend"_weight.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 1000 ]
        then
            powername=$powerdir$power$name0"0"$i$nameend"_weight.grid"$grid".P0"$P0".box"$box
        else
            powername=$powerdir$power$name0$i$nameend"_weight.grid"$grid".P0"$P0".box"$box
        fi
        ./power-fkp-qpm-mock-weight.exe ${FFTname[$i]} $FFTrandname $powername $sscale
        echo $powername
    done    
done

