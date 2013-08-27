#!/bin/bash
name0="cmass_dr11_north_ir4"; namerand0="cmass_dr11_north_randoms_ir4"
nameend=".v7.0.wghtv.txt"; namerandend=".v7.0.peakcorr.txt"
nameend_wboss=".v7.0.wboss.txt"
nameend_upw=".v7.0.upweight.txt"
nameend_corr=".v7.0.peakcorr.txt"
nbarfname="nbar-cmass-dr11may22-N-Anderson.dat"
tailnbarfname="nbar-dr11may22-N-Anderson-pz.dat"

P0=20000; sscale=3600.0; Rbox=1800.0; box="3600"; FFT="FFT"; power="power_"; grid="360"
maxjobs=6

datadir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/dr11/"
powerdir="/mount/riachuelo1/hahn/power/manera_mock/dr11/"

echo "n="; read n 
for i in $(seq 1 $n); do
    i=$( printf '%03d' $i ) 
    echo $i
    fname=$datadir$name0$i$nameend
    corrfile=$datadir$name0$i$nameend_corr
    corrrandfile=$datadir$namerand0$i$namerandend
    nbarcorrfile=$datadir"nbar-"$name0$i$nameend_corr
    
    if [[ -a $corrfile ]] && [[ -a $corrrandfile ]] && [[ -a $nbarcorrfile ]]; then
        echo $corrfile 
        echo $corrrandfile
        echo $nbarcorrfile
    else
        if [[ ! -a $corrfile ]]; then 
            echo "NO "$corrfile
        fi
        if [[ ! -a $corrrandfile ]]; then   
            echo "NO "$corrrandfile
        fi 
        if [[ ! -a $nbarcorrfile ]]; then
            echo "NO "$nbarcorrfile
        fi
    fi
    if [[ $datadir"nbar-"$name0$i$nameend_wboss -ot $nbarcorrfile ]] || [[ $datadir"nbar-"$name0$i$nameend_upw -ot $nbarcorrfile ]]; then 
        jobcnt=(`jobs -p`)
        echo "JOB COUNT="$jobcnt
        echo $datadir"nbar-"$name0$i$nameend_wboss
        echo $datadir"nbar-"$name0$i$nameend_upw
        MODDATE=$(stat -c %y $datadir"nbar-"$name0$i$nameend_wboss)
        MODDATE=${MODDATE%% *}
        echo $MODDATE
        MODDATE=$(stat -c %y $datadir"nbar-"$name0$i$nameend_upw)
        MODDATE=${MODDATE%% *}
        echo $MODDATE
        MODDATE=$(stat -c %y $nbarcorrfile)
        MODDATE=${MODDATE%% *}
        echo $MODDATE
    fi 
done
