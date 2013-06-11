#!/bin/bash

name0="a0.6452_"
nameend=".dr10_ngc.rdzw"
randname="a0.6452_rand100x.dr10_ngc.rdzw"
nbarfname="nbar-qpm-dr10v5-N-Anderson.dat"
sscale=4000.0
Rbox=2000.0
box="4000"
FFT="FFT-"
BISP="BISP-"
grid="360"
nmax="40"
nstep="3"
ncut="3"
iflag=2
FFTdir="/mount/riachuelo1/hahn/FFT/qpm_mock/"
BISdir="/mount/riachuelo1/hahn/bispec/qpm_mock/"

ifort -O4 -o bisp-qpm-dr10-ngc.exe bisp-qpm-dr10-ngc.f -L/usr/local/fftw_intel_s/lib -lsrfftw -lsfftw

for P0 in 20000
do
    randFFTname=$FFTdir$FFT$randname".grid"$grid".P0"$P0".box"$box
    for i in {101..200}
    do 
        if [ $i -lt 10 ]
        then 
            FFTname=$FFTdir$fft$name0"000"$i$nameend".grid"$grid".p0"$p0".box"$box
            bispec=$BISdir$BISP$name0"000"$i$nameend".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        elif [ $i -lt 100 ] 
        then
            FFTname=$FFTdir$fft$name0"00"$i$nameend".grid"$grid".p0"$p0".box"$box
            bispec=$BISdir$BISP$name0"00"$i$nameend".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        elif [ $i -lt 1000 ] 
        then 
            FFTname=$FFTdir$fft$name0"0"$i$nameend".grid"$grid".p0"$p0".box"$box
            bispec=$BISdir$BISP$name0"0"$i$nameend".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        else 
            FFTname=$FFTdir$fft$name0$i$nameend".grid"$grid".p0"$p0".box"$box
            bispec=$BISdir$BISP$name0$i$nameend".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        fi
        echo $FFTname
        echo $randFFTname 
        echo $bispec

        ./bisp-qpm-dr10-ngc.exe $iflag $randFFTname $FFTname $bispec
    done
done
