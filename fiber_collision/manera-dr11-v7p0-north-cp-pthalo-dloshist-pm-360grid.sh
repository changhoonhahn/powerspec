#!/bin/bash

name0="cmass_dr11_north_ir4"
nameend=".v7.0.wghtv.txt"
randname="cmass_dr11_north_randoms_ir4_combined_wboss.v7.0.wghtv.txt"
nbarfname="nbar-cmass-dr11may22-N-Anderson.dat"
dlosfname0="pthalo-ir4"
dlosfnameend="-dr11-v7p0-N-disp_los_hist_pm_normed.dat"
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

idl -e ".r fibcoll_pthalo_dlos_hist"
ifort -O3 -o FFT-fkp-mock-dr11-v7p0-wboss.exe FFT-fkp-mock-dr11-v7p0-wboss.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o FFT-fkp-mock-cp-dloshist-pm-360grid.exe FFT-fkp-mock-cp-dloshist-pm-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-mock-wboss-360grid-180bin.exe power-fkp-mock-wboss-360grid-180bin.f

FFTrandname=$FFTdir$FFT$randname".grid"$grid".P0"$P0".box"$box
if [ -a $FFTrandname ]
then
    echo $FFTrandname" ALREADY EXISTS"
else
    echo $FFTrandname" DOES NOT EXIST"
    ./FFT-fkp-mock-dr11-v7p0-wboss.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$randname $FFTrandname
fi

for i in {1..25}
do
    echo $i
    if [ $i -lt 10 ]
    then
        fname=$datadir$name0"00"$i$nameend
        FFTname=$FFTdir$FFT$name0"00"$i$nameend"-cp-pthalo-dloshist-pm.grid"$grid".P0"$P0".box"$box
        powername=$powerdir$power$name0"00"$i$nameend"-cp-pthalo-dloshist-pm.grid"$grid".P0"$P0".box"$box
        dlosfname=$datadir$dlosfname0"00"$i$dlosfnameend
    elif [ $i -lt 100 ]
    then
        fname=$datadir$name0"0"$i$nameend
        FFTname=$FFTdir$FFT$name0"0"$i$nameend"-cp-pthalo-dloshist-pm.grid"$grid".P0"$P0".box"$box
        powername=$powerdir$power$name0"0"$i$nameend"-cp-pthalo-dloshist-pm.grid"$grid".P0"$P0".box"$box
        dlosfname=$datadir$dlosfname0"0"$i$dlosfnameend
    else
        fname=$datadir$name0$i$nameend
        FFTname=$FFTdir$FFT$name0$i$nameend"-cp-pthalo-dloshist-pm.grid"$grid".P0"$P0".box"$box
        powername=$powerdir$power$name0$i$nameend"-cp-pthalo-dloshist-pm.grid"$grid".P0"$P0".box"$box
        dlosfname=$datadir$dlosfname0$i$dlosfnameend
    fi

    echo $fname

    if [ -a $FFTname ]
    then
        echo $FFTname
    else 
        idl -e "fibcoll_pthalo_dlos_hist,"$i",/north" 
        
        ipython -noconfirm_exit fibcoll_pthalo_dlos_hist.py $i
        echo $dlosfname
        
        ./FFT-fkp-mock-cp-dloshist-pm-360grid.exe $Rbox 0 $P0 $datadir$nbarfname $dlosfname $fname $FFTname
        echo $FFTname
    fi 

    ./power-fkp-mock-wboss-360grid-180bin.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done   
