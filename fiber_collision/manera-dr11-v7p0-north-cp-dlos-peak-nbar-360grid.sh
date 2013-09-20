#!/bin/bash
name0="cmass_dr11_north_ir4"; namerand0="cmass_dr11_north_randoms_ir4"
nameend=".v7.0.wghtv.txt"; nameend_wboss=".v7.0.wboss.txt"
nameend_upw=".v7.0.upweight.txt"; nameend_peak=".v7.0.peakcorr.txt"
nbarfname="nbar-cmass-dr11may22-N-Anderson.dat"
tailnbarfname="nbar-dr11may22-N-Anderson-pz.dat"

P0=20000; sscale=3600.0; Rbox=1800.0; box="3600"; FFT="FFT"; power="power_"; grid="360"
maxjobs=6

datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

echo "n="; read n 

idl -e ".r fibcoll_make_rand_peak_nbar.pro"
idl -e ".r fibcoll_nbar_comp.pro"
ifort -O3 -o FFT-fkp-mock-cp-dlos-peak-nbar-360grid.exe FFT-fkp-mock-cp-dlos-peak-nbar-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o mock-cp-dlos-peak-nbar.exe mock-cp-dlos-peak-nbar.f
ifort -O3 -o power-fkp-mock-weightr-360grid-180bin.exe power-fkp-mock-weightr-360grid-180bin.f

for i in $(seq 1 $n); do
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    corrfile=$datadir$name0$i$nameend_peak
    corrrandfile=$datadir$namerand0$i$nameend_peak
    nbarcorrfile=$datadir"nbar-normed-"$name0$i$nameend_peak
    
    if [[ -a $corrfile ]] && [[ -a $corrrandfile ]] && [[ -a $nbarcorrfile ]]; then
        echo $corrfile 
        echo $corrrandfile
        echo $nbarcorrfile
    else
        if [[ ! -a $corrfile ]]; then 
            ./mock-cp-dlos-peak-nbar.exe $datadir$nbarfname $datadir$tailnbarfname $fname $corrfile
            echo $corrfile
        fi
        if [[ ! -a $corrrandfile ]]; then   
            idl -e "fibcoll_make_rand_peak_nbar,"$i",466264987" 
            echo $corrrandfile
        fi 
        if [[ ! -a $nbarcorrfile ]]; then
            idl -e "fibcoll_nbar_comp_norm,"$i",/peaknbar" 
            echo $nbarcorrfile
        fi
    fi
    if [ $datadir"nbar-normed-"$name0$i$nameend_wboss -ot $nbarcorrfile -o $datadir"nbar-normed-"$name0$i$nameend_upw -ot $nbarcorrfile ]; then 
#        jobcnt=(`jobs -p`)
        echo $datadir"nbar-normed-"$name0$i$nameend_wboss
        echo $datadir"nbar-normed-"$name0$i$nameend_upw
#        if [ ${#jobcnt[@]} -lt $(( $maxjobs-4 ))  ]; then 
        idl -e "fibcoll_nbar_comp_norm,"$i",/noweight" &
        idl -e "fibcoll_nbar_comp_norm,"$i",/upweight" &
        idl -e "fibcoll_nbar_comp_norm,"$i",/random" &
        idl -e "fibcoll_nbar_comp_norm,"$i",/randpeak" &
        wait 
#        fi
    fi 
done; echo $n 

randcomb_fname="cmass_dr11_north_"$n"_randoms_ir4_combined_wghtr.v7.0.peakcorr.txt"
if [[ ! -a $randcomb_fname ]]; then 
    ipython -noconfirm_exit rand_combine-peak-nbar.py $n 
fi

# n(z) correction for FKP weights (less important than above).
ipython -noconfirm_exit fibcoll_nbar_peak_correct.py $n

corrnbarfname="nbar-dr10v5-N-Anderson-peaknbarcorr.dat"
FFTrandname=$FFTdir$FFT$randcomb_fname".grid"$grid".P0"$P0".box"$box
if [ -a $FFTrandname ]; then
    echo $FFTrandname
else
    ./FFT-fkp-mock-cp-dlos-peak-nbar-360grid.exe $Rbox 1 $P0 $datadir$corrnbarfname $datadir$tailnbarfname $datadir$randcomb_fname $FFTrandname
    echo $FFTrandname
fi

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    FFTname=$FFTdir$FFT$name0$i$nameend"-cp-dlos-peak-nbar.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i$nameend"-cp-dlos-peak-nbar.grid"$grid".P0"$P0".box"$box
     
    ./FFT-fkp-mock-cp-dlos-peak-nbar-360grid.exe $Rbox 0 $P0 $datadir$corrnbarfname $datadir$tailnbarfname $fname $FFTname
    echo $FFTname
    ./power-fkp-mock-weightr-360grid-180bin.exe $FFTname $FFTrandname $powername $sscale
    echo $powername
done
