#!/bin/bash
name0="cmass_dr11_north_ir4"
nameend=".v7.0.wghtv.txt"
randname="cmass_dr11_north_randoms_ir4_combined_wboss.v7.0.wghtv.txt"
nbarfname="nbar-cmass-dr11may22-N-Anderson.dat"
cpbarfname="nbar-dr11may22-N-Anderson-pz.dat"
dlosfname="cmass-dr11v2-N-Anderson-disp_los_hist_normed.dat"
P0=20000
sscale=3600.0
Rbox=1800.0
box="3600"
FFT="FFT"
power="power_"
grid="360"

prismdir="/global/data/scr/chh327/powercode/data/"
datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

ifort -O3 -o FFT-fkp-mock-dr11-v7p0-wboss.exe FFT-fkp-mock-dr11-v7p0-wboss.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o FFT-fkp-mock-cp-naive-360grid.exe FFT-fkp-mock-cp-naive-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-mock-wboss-360grid-180bin.exe power-fkp-mock-wboss-360grid-180bin.f

FFTrandname=$FFTdir$FFT$randname".grid"$grid".P0"$P0".box"$box
if [ -a $FFTrandname ]
then
    echo $FFTrandname" ALREADY EXISTS"
else
    echo $FFTrandname" DOES NOT EXIST"
    ./FFT-fkp-mock-dr11-v7p0-wboss.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$randname $FFTrandname
fi

for i in {1..1}
do
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i$nameend"-cp-naive.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i$nameend"-cp-naive.grid"$grid".P0"$P0".box"$box
    echo $fname

    ./FFT-fkp-mock-cp-naive-360grid.exe $Rbox 0 $P0 $datadir$nbarfname $datadir$cpbarfname $fname $FFTname
    echo $FFTname
    ./power-fkp-mock-wboss-360grid-180bin.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done    
