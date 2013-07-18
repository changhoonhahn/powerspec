#!/bin/bash

name0="cmass-dr11v2-"
nameend="-Anderson-nzw-zlim"
ext=".dat"
ranext=".ran.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
fftext="-ngalsys-"$box"lbox-360grid.dat"
fftranext="-ngalsys-"$box"lbox-360grid.ran.dat"
BISPext="-ngalsys-"$box"lbox-360bin-180bin.dat"
nmax="40"
nstep="3"
ncut="3"
iflag=2
FFT="FFT-"
bispec="bispec-"
power="power-"

ifort -O4 -o bisp_maneramock_v5p2.exe bisp_maneramock_v5p2.f -L/usr/local/fftw_intel_s/lib -lsrfftw -lsfftw

FFTdir="/mount/riachuelo1/hahn/FFT/"
BISPdir="/mount/riachuelo1/hahn/bispec/"

for P0 in 20000
do
    for field in N S 
    do
        FFTname=$FFTdir$FFT$name0$field$nameend$fftext
        echo $FFTname

        FFTrandname=$FFTdir$FFT$name0$field$nameend$fftranext
        echo $FFTrandname

        BISPname=$BISPdir$bispec$name0$field$namened$BISPext".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        
        ./bisp_maneramock_v5p2.exe $iflag $FFTrandname $FFTname $BISPname
    done
done
