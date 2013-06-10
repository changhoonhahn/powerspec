#!/bin/bash

name0="cmass-dr11v0-"
nameend="-Anderson-nzw-zlim"
ext=".dat"
ranext=".ran.dat"
fftext="-ngalsys-360grid.dat"
fftranext="-ngalsys-360grid.ran.dat"
BISPext="-ngalsys-360bin-180bin.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
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
    for field in N S full
    do
        FFTname=$FFTdir$FFT$name0$field$nameend$fftext
        echo $FFTname

        FFTrandname=$FFTdir$FFT$name0$field$nameend$fftranext
        echo $FFTrandname

        BISPname=$BISPdir$bispec$name0$field$namened$BISPext".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        
        ./bisp_maneramock_v5p2.exe $iflag $FFTrandname $FFTname $BISPname
    done
done
