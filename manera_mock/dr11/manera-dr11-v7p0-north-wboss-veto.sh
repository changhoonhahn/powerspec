#!/bin/bash
name0="cmass_dr11_north_ir4"
nameend=".v7.0.wghtv.txt"
nbarfname="nbar-cmass-dr11v0-N-Anderson.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
FFT="FFT"
power="power_"
grid="360"
P0=20000
echo "n="; read n 

ifort -O3 -o FFT-fkp-mock-dr11-v7p0-wboss-veto.exe FFT-fkp-mock-dr11-v7p0-wboss-veto.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-mock-dr11-v7p0-wboss.exe power-fkp-mock-dr11-v7p0-wboss.f
datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

randname0="cmass_dr11_north_"$n"_randoms_ir4_combined_wboss_veto"
randname=$randname0$nameend
FFTrandname=$FFTdir$FFT$randname0".grid"$grid".P0"$P0".box"$box

if [[ ! -a $datadir$randname ]]; then 
    echo "Random File does not exist"
    ipython -noconfirm_exit rand_combine-dr11-v7p0-north-wboss-veto.py $n
fi

if [[ ! -a $FFTrandname ]]; then
    echo $FFTrandname 
    ./FFT-fkp-mock-dr11-v7p0-wboss-veto.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$randname $FFTrandname
fi

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i$nameend"_wboss_veto.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i$nameend"_wboss_veto.grid"$grid".P0"$P0".box"$box
    echo $fname
    ./FFT-fkp-mock-dr11-v7p0-wboss-veto.exe $Rbox 0 $P0 $datadir$nbarfname $fname $FFTname
    echo $FFTname 
    ./power-fkp-mock-dr11-v7p0-wboss.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done 
