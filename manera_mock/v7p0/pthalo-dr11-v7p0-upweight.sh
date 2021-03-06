#!/bin/bash
name0="cmass_dr11_north_ir4"; nameend=".v7.0.wghtv.txt"
randname0="cmass_dr11_north_randoms_ir4"
nbarfname="nbar-dr10v5-N-Anderson.dat"
sscale=3600.0; Rbox=1800.0; box="3600"
FFT="FFT_"; power="power_"
grid="360"; P0=20000

echo "n="; read n 

ifort -O3 -o FFT-fkp-pthalo-dr11-v7p0-upweight.exe FFT-fkp-pthalo-dr11-v7p0-upweight.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-pthalo-dr11-v7p0.exe power-fkp-pthalo-dr11-v7p0.f
datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/v7p0/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/v7p0/"

randname=$datadir"cmass_dr11_north_"$n"_randoms_ir4_combined.v7.0.txt"
#if [[ ! -a $randname ]]; then 
echo $randname 
ipython -noconfirm_exit rand_combine-dr11-v7p0-north.py $n $datadir $randname0 $nameend $randname
#fi
FFTrandname=$FFTdir$FFT"cmass_dr11_north_"$n"_randoms_ir4_combined.v7.0.grid"$grid".P0"$P0".box"$box
#if [[ ! -a $FFTrandname ]]; then 
echo $FFTrandname 
./FFT-fkp-pthalo-dr11-v7p0-upweight.exe $Rbox 1 $P0 $datadir$nbarfname $randname $FFTrandname
#fi

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i".v7.0.upweight.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i".v7.0."$n"randoms.upweight.grid"$grid".P0"$P0".box"$box
    echo $fname
    ./FFT-fkp-pthalo-dr11-v7p0-upweight.exe $Rbox 0 $P0 $datadir$nbarfname $fname $FFTname
    echo $FFTname 
    ./power-fkp-pthalo-dr11-v7p0.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done 
