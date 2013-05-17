#!/bin/bash

name0="cmass-dr10v8-"
nameend="-Anderson-nzw-zlim"
ext=".dat"
ranext=".ran.dat"
sscale=4800.0
Rbox=2400.0
box="4800"
FFT="FFT-"
power="power-"
grid="240"

ifort -O3 -o FFT-fkp-nzw-ngalsys-960grid.exe FFT-fkp-nzw-ngalsys-960grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

datadir="/global/data/scr/chh327/powercode/data/"
FFTdir="/mount/riachuelo1/hahn/FFT/"
powerdir=

for P0 in 20000
do
    for field in full #N S
    do
        fname=$datadir$name0$field$nameend$ext
        FFTname=$FFTdir$FFT$name0$field$nameend$ext
        echo $fname
        echo $FFTname
        ./FFT-fkp-nzw-ngalsys-960grid.exe $Rbox 0 $P0 $fname $FFTname
    done
done

dir="/mount/riachuelo1/hahn/FFT/manera_mock/v5p2/"
for P0 in 20000
do
    for field in full #N S
    do 
        fname=$datadir$name0$field$nameend$ranext
        FFTname=$FFTdir$FFT$name0$field$nameend$ranext
        echo $fname
        echo $FFTname

        ./FFT-fkp-nzw-ngalsys-960grid.exe $Rbox 1 $P0 $fname $FFTname
done


ifort -O3 -o power-fkp-mock-wboss-v5p2-south.exe power-fkp-mock-wboss-v5p2-south.f

for P0 in 20000
do
    for i in {1..1}
    do
        echo $i
        echo $P0
        if [ $i -lt 10 ]
        then
            FFTname[$i]=$FFT$name0"00"$i$nameend".grid"$grid".P0"$P0".box"$box
            powername[$i]=$power$name0"00"$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ]
        then
            FFTname[$i]=$FFT$name0"0"$i$nameend".grid"$grid".P0"$P0".box"$box
            powername[$i]=$power$name0"0"$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
        else
            FFTname[$i]=$FFT$name0$i$nameend".grid"$grid".P0"$P0".box"$box
            powername[$i]=$power$name0$i$nameend"_wboss.grid"$grid".P0"$P0".box"$box
        fi
        ./power-fkp-mock-wboss-v5p2-south.exe $FFT$randname".grid"$grid".P0"$P0".box"$box ${FFTname[$i]} ${powername[$i]} $sscale
        echo ${powername[$i]}
    done    
done

