#!/bin/bash

name0="cmass-dr11v2-"
nameend="-Anderson-nzw-zlim"
ext=".dat"
ranext=".ran.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
fftext="-ngalsys-"$box"lbox-960grid.dat"
fftranext="-ngalsys-"$box"lbox-960grid.ran.dat"
pwrext="-ngalsys-"$box"lbox-960grid-480bin.dat"
FFT="FFT-"
power="power-"

ifort -O3 -o FFT-fkp-nzw-ngalsys-960grid.exe FFT-fkp-nzw-ngalsys-960grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

datadir="/global/data/scr/chh327/powercode/data/"
FFTdir="/mount/riachuelo1/hahn/FFT/"
powerdir="/mount/riachuelo1/hahn/power/"

for P0 in 20000
do
    for field in full N S
    do
        fname=$datadir$name0$field$nameend$ext
        FFTname=$FFTdir$FFT$name0$field$nameend$fftext
        echo $fname
        echo $FFTname
        ./FFT-fkp-nzw-ngalsys-960grid.exe $Rbox 0 $P0 $fname $FFTname

        randfname=$datadir$name0$field$nameend$ranext
        FFTrandname=$FFTdir$FFT$name0$field$nameend$fftranext
        if [ -a $FFTrandname ] 
        then
            echo $FFTrandname" exists"
        else 
            echo $FFTrandname" does not exist"
            ./FFT-fkp-nzw-ngalsys-960grid.exe $Rbox 1 $P0 $randfname $FFTrandname
            echo "now it does"
        fi

        ifort -O3 -o power-fkp-ngalwsys-960grid-480bin.exe power-fkp-ngalwsys-960grid-480bin.f
        powername=$powerdir$power$name0$field$nameend$pwrext
        
        ./power-fkp-ngalwsys-960grid-480bin.exe $FFTrandname $FFTname $powername $sscale
        echo $powername
    done
done
