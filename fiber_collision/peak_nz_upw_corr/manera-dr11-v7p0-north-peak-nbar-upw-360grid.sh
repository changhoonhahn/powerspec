#!/bin/bash
name0="cmass_dr11_north_ir4"; namerand0="cmass_dr11_north_randoms_ir4"
nameend=".v7.0.wghtv.txt"; nameend_peak=".v7.0.peakcorrupw.txt"
nbarfname="nbar-dr10v5-N-Anderson.dat"
tailnbarfname="nbar-normed-cmass_dr11_north_25_randoms_ir4_combined.v7.0.upweight-pz.txt"

P0=20000; sscale=3600.0; Rbox=1800.0; box="3600"; FFT="FFT"; power="power_"; grid="360"

datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

echo "n="; read n 
# Bash Script for peak+n(z) correction scheme with peakfrac=1 in order to reproduce upweight scheme
idl -e ".r fibcoll_make_rand_peak_nbar_upw.pro"
ifort -O3 -o FFT-fkp-mock-cp-dlos-peak-nbar-upw-360grid.exe FFT-fkp-mock-cp-dlos-peak-nbar-upw-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o mock-cp-dlos-peak-nbar-upw.exe mock-cp-dlos-peak-nbar-upw.f
ifort -O3 -o power-fkp-mock-360grid-180bin.exe power-fkp-mock-360grid-180bin.f

for i in $(seq 1 $n); do
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    corrfile=$datadir$name0$i$nameend_peak
    if [[ ! -a $corrfile ]]; then 
        ./mock-cp-dlos-peak-nbar-upw.exe $datadir$nbarfname $datadir$tailnbarfname $fname $corrfile
        echo $corrfile
    fi
done
for i in $(seq 1 $n); do
    i=$( printf '%03d' $i ) 
    echo $i
    corrrandfile=$datadir$namerand0$i$nameend_peak
    if [[ ! -a $corrrandfile ]]; then   
        idl -e "fibcoll_make_rand_peak_nbar_upw,"$i",466264987" & 
        echo $corrrandfile
    fi

    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then
        wait
    fi 
done; 
wait

randcomb_fname="cmass_dr11_north_"$n"_randoms_ir4_combined.v7.0.peakcorrupw.txt"
if [[ ! -a $datadir$randcomb_fname ]]; then 
    ipython -noconfirm_exit rand_combine-peak-nbar-upw.py $n 
fi
# n(z) correction for FKP weights (IGNORING FOR PEAK+NZ+UPW) 
# ipython -noconfirm_exit fibcoll_nbar_peak_correct.py $n
# Note, tailnbarfname has also been ignored for this bash script
# Need to generate tailnbarfname based on the normalized n(z) of the upweighted PTHalo since CMASS and PTHalo disagree. 
FFTrandname=$FFTdir$FFT"cmass_dr11_north_"$n"_randoms_ir4_combined.v7.0.peakcorrupw.grid"$grid".P0"$P0".box"$box
if [[ ! -a $FFTrandname ]]; then
    ./FFT-fkp-mock-cp-dlos-peak-nbar-upw-360grid.exe $Rbox 1 $P0 $datadir$nbarfname $datadir$tailnbarfname $datadir$randcomb_fname $FFTrandname
    echo $FFTrandname
fi

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i".v7.0.peakcorrupw.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i".v7.0."$n"randoms.peakcorrupw.grid"$grid".P0"$P0".box"$box
     
    ./FFT-fkp-mock-cp-dlos-peak-nbar-upw-360grid.exe $Rbox 0 $P0 $datadir$nbarfname $datadir$tailnbarfname $fname $FFTname
    echo $FFTname
    ./power-fkp-mock-360grid-180bin.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done
