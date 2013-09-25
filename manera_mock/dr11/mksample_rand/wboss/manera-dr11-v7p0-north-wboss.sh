#!/bin/bash
name0="cmass_dr11_north_ir4"
nameend=".v7.0.wghtv.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
sscale=3600.0
Rbox=1800.0
box="3600"
FFT="FFT"
power="power_"
grid="360"
P0=20000

echo "n="; read n 

idl -e ".r make_rand_wboss.pro"
ifort -O3 -o FFT-fkp-mock-dr11-v7p0-wboss.exe FFT-fkp-mock-dr11-v7p0-wboss.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-mock-dr11-v7p0-wboss.exe power-fkp-mock-dr11-v7p0-wboss.f
datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    
    randupw=$datadir"cmass_dr11_north_randoms_ir4"$i".v7.0.wboss.txt"
#    if [[ ! -a $randupw ]]; then 
    idl -e "make_rand_wboss,"$i",466264938287" &
    echo $randupw
#    fi

    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then 
        wait
    fi 
done
wait

randname="cmass_dr11_north_"$n"_randoms_ir4_combined.v7.0.wboss.txt"
FFTrandname=$FFTdir$FFT"cmass_dr11_north_"$n"_randoms_ir4_combined.v7.0.wboss.grid"$grid".P0"$P0".box"$box
#if [[ ! -a $datadir$randname ]]; then 
#    echo "Random File does not exist"
ipython -noconfirm_exit rand_combine-dr11-v7p0-north-wboss.py $n
#fi

#if [[ ! -a $FFTrandname ]]; then
./FFT-fkp-mock-dr11-v7p0-wboss.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$randname $FFTrandname
echo $FFTrandname 
#fi

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i".v7.0.wboss.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i".v7.0."$n"randoms.wboss.grid"$grid".P0"$P0".box"$box
    echo $fname
    ./FFT-fkp-mock-dr11-v7p0-wboss.exe $Rbox 0 $P0 $datadir$nbarfname $fname $FFTname
    echo $FFTname 
    ./power-fkp-mock-dr11-v7p0-wboss.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done 
