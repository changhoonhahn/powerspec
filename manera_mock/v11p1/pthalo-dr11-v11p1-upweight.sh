#!/bin/bash
name0="cmass_dr11_north_ir4"; nameend=".v11.0.wghtv.txt"
nbarfname="nbar-cmass-dr11may22-N-Anderson.dat"
sscale=3600.0; Rbox=1800.0; box="3600"
FFT="FFT_"; power="power_"
grid="360"; P0=20000

echo "n="; read n 

ifort -O3 -o FFT-fkp-pthalo-dr11-v11p1-upweight.exe FFT-fkp-pthalo-dr11-v11p1-upweight.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-pthalo-dr11-v11p1.exe power-fkp-pthalo-dr11-v11p1.f
datadir="/mount/riachuelo1/hahn/data/manera_mock/v11p0/"
randdir="/mount/riachuelo1/hahn/data/manera_mock/v11p1/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/v11p0/"
FFTranddir="/mount/riachuelo1/hahn/FFT/manera_mock/v11p1/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/v11p1/"

randname="cmass_dr11_north_"$n"_randoms_ir4_combined.v11.1.txt"
FFTrandname=$FFTranddir$FFT"cmass_dr11_north_"$n"_randoms_ir4_combined.v11.1.grid"$grid".P0"$P0".box"$box

if [[ ! -a $randdir$randname ]]; then 
    echo $randdir$randname 
    ipython -noconfirm_exit rand_combine-dr11-v11p1-north.py $n
fi
#if [[ ! -a $FFTrandname ]]; then 
#    echo $FFTrandname 
./FFT-fkp-pthalo-dr11-v11p1-upweight.exe $Rbox 1 $P0 $datadir$nbarfname $randdir$randname $FFTrandname
#fi

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i".v11.0.upweight.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i".v11.1."$n"randoms.upweight.grid"$grid".P0"$P0".box"$box
    echo $fname
    ./FFT-fkp-pthalo-dr11-v11p1-upweight.exe $Rbox 0 $P0 $datadir$nbarfname $fname $FFTname
    echo $FFTname 
    ./power-fkp-pthalo-dr11-v11p1.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done 
