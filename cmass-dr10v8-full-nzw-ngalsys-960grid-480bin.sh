#!/bin/bash

name0="cmass-dr10v8-"
nameend="-Anderson-nzw-zlim"
ext=".dat"
ranext=".ran.dat"
fftext="-960grid.dat"
fftranext="-960grid.ran.dat"
pwrext="-960bin-480bin.dat"
sscale=4800.0
Rbox=2400.0
box="4800"
FFT="FFT-"
power="power-"

ifort -O3 -o FFT-fkp-nzw-ngalsys-960grid.exe FFT-fkp-nzw-ngalsys-960grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

datadir="/global/data/scr/chh327/powercode/data/"
FFTdir="/mount/riachuelo1/hahn/FFT/"
powerdir="/mount/riachuelo1/hahn/power/"

for P0 in 20000
do
    for field in full #N S
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
