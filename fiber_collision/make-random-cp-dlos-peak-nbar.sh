#!/bin/bash
name0="cmass_dr11_north_ir4"; namerand0="cmass_dr11_north_randoms_ir4"
nameend=".v7.0.wghtv.txt"; nameend_wboss=".v7.0.wboss.txt"
nameend_upw=".v7.0.upweight.txt"; nameend_peak=".v7.0.peakcorr.txt"

maxjobs=6

datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

echo "n="; read n 

idl -e ".r fibcoll_make_rand_peak_nbar.pro"
ifort -O3 -o mock-cp-dlos-peak-nbar.exe mock-cp-dlos-peak-nbar.f

for i in $(seq 1 $n); do
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    corrfile=$datadir$name0$i$nameend_peak
    corrrandfile=$datadir$namerand0$i$nameend_peak
    
    if [[ ! -a $corrfile ]]; then 
        ./mock-cp-dlos-peak-nbar.exe $datadir$nbarfname $datadir$tailnbarfname $fname $corrfile
        echo $corrfile
    fi
    randomseed=$RANDOM
    idl -e "fibcoll_make_rand_peak_nbar,"$i","$randomseed
    echo $randomseed
    echo $corrrandfile
done
