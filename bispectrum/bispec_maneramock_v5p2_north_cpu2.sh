#!/bin/bash

prefix="FFTcmass_dr10_north_ir4"
bispecpre="BISPcmass_dr10_north_ir4"
suffix=".v5.2.wghtv.txt"
sscale=3600.0
box="3600"
grid="360"
nmax="40"
nstep="3"
ncut="3"
iflag=2
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/v5p2/"
BISdir="/mount/riachuelo1/hahn/bispec/manera_mock/v5p2/"

ifort -O4 -o bisp_maneramock_v5p2.exe bisp_maneramock_v5p2.f -L/usr/local/fftw_intel_s/lib -lsrfftw -lsfftw

for P0 in 20000
do
    randFFTname=$FFTdir"FFTcmass_dr10_north_randoms_ir4_combined_wboss.v5.2.wghtv.txt.grid"$grid".P0"$P0".box"$box
    for i in {101..200}
    do 
        if [ $i -lt 10 ]
        then 
            FFTname=$FFTdir$prefix"00"$i$suffix".grid"$grid".P0"$P0".box"$box
            bispec=$BISdir$bispecpre"00"$i$suffix".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        elif [ $i -lt 100 ] 
        then
            FFTname=$FFTdir$prefix"0"$i$suffix".grid"$grid".P0"$P0".box"$box
            bispec=$BISdir$bispecpre"0"$i$suffix".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        else 
            FFTname=$FFTdir$prefix$i$suffix".grid"$grid".P0"$P0".box"$box
            bispec=$BISdir$bispecpre$i$suffix".grid"$grid".nmax"$nmax".nstep"$nstep".P0"$P0".box"$box
        fi
        echo $FFTname
        echo $randFFTname 
        echo $bispec

        ./bisp_maneramock_v5p2.exe $iflag $randFFTname $FFTname $bispec
    done
done
