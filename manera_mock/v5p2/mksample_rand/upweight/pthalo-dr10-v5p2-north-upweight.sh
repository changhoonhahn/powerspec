#!/bin/bash
name0="cmass_dr10_north_ir4"
nameend=".v5.2.wghtv.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
sscale=3600.0; Rbox=1800.0; box="3600"
FFT="FFT"; power="power_"
grid="360"; P0=20000

echo "n="; read n 

idl -e ".r make_rand_upweight.pro"
ifort -O3 -o FFT-fkp-mock-dr10-v5p2-upweight.exe FFT-fkp-mock-dr10-v5p2-upweight.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-mock-dr10-v5p2-wboss.exe power-fkp-mock-dr10-v5p2-wboss.f
datadir="/mount/chichipio2/hahn/data/manera_mock/v5p2/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/v5p2/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/v5p2/"

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    
    randupw=$datadir"cmass_dr10_north_randoms_ir4"$i".v5.2.upweight.makerandom.txt"
    if [[ ! -a $randupw ]]; then 
        idl -e "make_rand_upweight,"$i",638212324887,'"$datadir"','"$name0"','"$nameend"','cmass_dr10_north_randoms_ir4','"$randupw"'" &
        echo $randupw
    fi

    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then 
        wait
    fi 
done
wait

randname=$datadir"cmass_dr10_north_"$n"_randoms_ir4_combined.v5.2.upweight.makerandom.txt"
FFTrandname=$FFTdir$FFT"cmass_dr10_north_"$n"_randoms_ir4_combined.v5.2.upweight.makerandom.grid"$grid".P0"$P0".box"$box
#if [[ ! -a $randname ]]; then 
echo "Random File does not exist"
ipython -noconfirm_exit rand_combine-dr10-v5p2-north-upweight.py $n $datadir "cmass_dr10_north_randoms_ir4" ".v5.2.upweight.makerandom.txt" $randname
#fi
echo $FFTrandname 
./FFT-fkp-mock-dr10-v5p2-upweight.exe $Rbox 1 $P0 $datadir$nbarfname $randname $FFTrandname

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i )
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i".v5.2.upweight.makerandom.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i".v5.2."$n"randoms.upweight.makerandom.grid"$grid".P0"$P0".box"$box
    echo $fname
    ./FFT-fkp-mock-dr10-v5p2-upweight.exe $Rbox 0 $P0 $datadir$nbarfname $fname $FFTname
    echo $FFTname 
    ./power-fkp-mock-dr10-v5p2-wboss.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done 
