#!/bin/bash
name0="cmass_dr11_north_ir4"; namerand0="cmass_dr11_north_randoms_ir4"
nameend=".v7.0.wghtv.txt"; nameend_peak=".v7.0.peakcorr.txt"
nbarfname="nbar-dr10v5-N-Anderson"; dat=".dat"; txt=".txt"

P0=20000; sscale=3600.0; Rbox=1800.0; box="3600"; FFT="FFT"; power="power_"; grid="360"

datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

echo "n="; read n 
ifort -O3 -o mock-cp-dlos-peak-nbar.exe mock-cp-dlos-peak-nbar.f
ifort -O3 -o FFT-fkp-peak-nbar-corr-mock-360grid.exe FFT-fkp-peak-nbar-corr-mock-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

# p(z) for the tail of the dLOS distribution based on the normalized n(z)_upweight:
nbar_upweight="nbar-normed-cmass_dr11_north_25_randoms_ir4_combined.v7.0.upweight"
ipython -noconfirm_exit fibcoll_nbarz_pz_peak_nbar.py $datadir $nbar_upweight $txt 
tailnbarfname=$nbar_upweight"-pz"$txt
echo $tailnbarfname

# Constructing the Peak+n(z) corrected Mock catalogs
for i in $(seq 1 $n); do
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    corrfile=$datadir$name0$i$nameend_peak
#    if [[ ! -a $corrfile ]]; then 
    ./mock-cp-dlos-peak-nbar.exe $datadir$nbarfname$dat $datadir$tailnbarfname $fname $corrfile
    echo $corrfile
#    fi
    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then
        wait
    fi 
done
wait 

# n(z) correction for FKP weights:
ipython -noconfirm_exit fibcoll_nbar_wfkp_peak_nbar.py $n $datadir$nbarfname
nbar_wfkp_corr_fname=$nbarfname"-peaknbarcorr.dat"

for i in $(seq 1 $n); do 
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend_peak
    FFTname=$FFTdir$FFT$name0$i".v7.0.peakcorr.grid"$grid".P0"$P0".box"$box
    powername=$powerdir$power$name0$i".v7.0."$n"randoms.peakcorr.grid"$grid".P0"$P0".box"$box
     
    ./FFT-fkp-peak-nbar-corr-mock-360grid.exe $Rbox 0 $P0 $datadir$nbar_wfkp_corr_fname $datadir$tailnbarfname $fname $FFTname
    echo $FFTname
done
