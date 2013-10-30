#!/bin/bash
name0="cmass_dr11_north_ir4"
nameend=".v11.0.wghtv.txt"
nbarfname="nbar-cmass-dr11may22-N-Anderson.dat"
sscale=3600.0; Rbox=1800.0; box="3600"
FFT="FFT"; power="power_"
grid="360"; P0=20000

echo "n="; read n 

idl -e ".r make_rand_noweight.pro"
ifort -O3 -o FFT-fkp-mock-dr11-v11p0-noweight.exe FFT-fkp-mock-dr11-v11p0-noweight.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-mock-dr11-v11p0-wboss.exe power-fkp-mock-dr11-v11p0-wboss.f
datadir="/mount/riachuelo1/hahn/data/manera_mock/v11p0/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/v11p0/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/v11p0/"

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    
    randupw=$datadir"cmass_dr11_north_randoms_ir4"$i".v11.0.noweight.makerandom.txt"
#    if [[ ! -a $randupw ]]; then 
        idl -e "make_rand_noweight,"$i",62649382123887" &
        echo $randupw
#    fi

    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then 
        wait
    fi 
done
wait

randname="cmass_dr11_north_"$n"_randoms_ir4_combined.v11.0.noweight.makerandom.txt"
FFTrandname=$FFTdir$FFT"cmass_dr11_north_"$n"_randoms_ir4_combined.v11.0.noweight.makerandom.grid"$grid".P0"$P0".box"$box
#if [[ ! -a $datadir$randname ]]; then 
    echo "Random File does not exist"
    ipython -noconfirm_exit rand_combine-dr11-v11p0-north-noweight.py $n
#fi
echo $FFTrandname 
./FFT-fkp-mock-dr11-v11p0-noweight.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$randname $FFTrandname

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i".v11.0.noweight.makerandom.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i".v11.0."$n"randoms.noweight.makerandom.grid"$grid".P0"$P0".box"$box
    echo $fname
    ./FFT-fkp-mock-dr11-v11p0-noweight.exe $Rbox 0 $P0 $datadir$nbarfname $fname $FFTname
    echo $FFTname 
    ./power-fkp-mock-dr11-v11p0-wboss.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done 
