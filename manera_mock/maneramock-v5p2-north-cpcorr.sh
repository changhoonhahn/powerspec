#!/bin/bash

name0="cmass_dr10_north_ir4"
nameend=".v5.1.wght.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
randname="cmass_dr10_north_randoms_ir4_combined_wboss.v5.1.wght.txt"
cpnbarfname="cp-redshift-nbar-dr10v5-N-Anderson.dat"
Rbox=1800.0
box="3600"
FFT="FFT-"
grid="360"

nbardir="/mount/chichipio2/hahn/data/manera_mock/"
datadir="/mount/chichipio2/hahn/data/manera_mock/v5p2/"
FFTdir="/mount/riachuelo1/hahn/data/manera_mock/v5p2/"



#Need to implement dr10v8 nbar and cpnbar
#Need to be run for v5p2 manera mocks

ifort -O3 -o FFT-fkp-mock-cp.exe FFT-fkp-mock-cp.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

for P0 in 20000
do
    for i in {1..10}
    do
        echo $i
        if [ $i -lt 10 ]
        then
            fname=$name0"00"$i$nameend
            FFTname[$i]=$FFT$name0"00"$i$nameend"_cp.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            fname=$name0"0"$i$nameend
            FFTname[$i]=$FFT$name0"0"$i$nameend"_cp.grid"$grid".P0"$P0".box"$box
        else
            fname=$name0$i$nameend
            FFTname[$i]=$FFT$name0$i$nameend"_cp.grid"$grid".P0"$P0".box"$box
        fi
        echo $fname
        echo ${FFTname[$i]}
        ./FFT-fkp-mock-cp.exe $Rbox 0 $P0 $nbardir$nbarfname $nbardir$cpnbarfname $datadir$fname ${FFTname[$i]}
    done
done

ifort -O3 -o power-fkp-mock.exe power-fkp-mock.f

for P0 in 0 10000 20000 30000 40000
do
    for i in {1..10}
    do
        echo $i
        if [ $i -lt 10 ]
        then
            FFTname[$i]=$FFT$name0"00"$i$nameend"_cp.grid"$grid".P0"$P0".box"$box
            powername=$power$name0"00"$i$nameend"_wboss_cp.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            FFTname[$i]=$FFT$name0"0"$i$nameend"_cp.grid"$grid".P0"$P0".box"$box
            powername=$power$name0"0"$i$nameend"_wboss_cp.grid"$grid".P0"$P0".box"$box
        else
            FFTname[$i]=$FFT$name0$i$nameend"_cp.grid"$grid".P0"$P0".box"$box
            powername=$power$name0$i$nameend"_wboss_cp.grid"$grid".P0"$P0".box"$box
        fi
        ./power-fkp-mock.exe $FFT$randname".grid"$grid".P0"$P0".box"$box ${FFTname[$i]} $powername $sscale
        echo $powername
    done
done

