#!/bin/bash

name0="cmass-dr10v8-"
nameend="-Anderson-nzw-zlim"
ext=".dat"
ranext=".ran.dat"
fftext="-I22g-alpha-360grid.dat"
fftranext="I22g-alpha-360grid.ran.dat"
pwrext="-I22g-alpha-360bin-180bin.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
FFT="FFT-"
power="power-"

ifort -O3 -o FFT-fkp-nzw-ngalsys-I22g-360grid.exe FFT-fkp-nzw-ngalsys-I22g-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

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
        ./FFT-fkp-nzw-ngalsys-I22g-360grid.exe $Rbox 0 $P0 $fname $FFTname

        randfname=$datadir$name0$field$nameend$ranext
        FFTrandname=$FFTdir$FFT$name0$field$nameend$fftranext
        if [ -a $FFTrandname ] 
        then
            echo $FFTrandname" exists"
        else 
            echo $FFTrandname" does not exist"
            ./FFT-fkp-nzw-ngalsys-I22g-360grid.exe $Rbox 1 $P0 $randfname $FFTrandname
            echo "now it does"
        fi

        ifort -O3 -o power-fkp-ngalwsys-I22g-alpha-360grid-180bin.exe power-fkp-ngalwsys-I22g-alpha-360grid-180bin.f
        powername=$powerdir$power$name0$field$nameend$pwrext
        
        ./power-fkp-ngalwsys-I22g-alpha-360grid-180bin.exe $FFTrandname $FFTname $powername $sscale
        echo $powername
    done
done
