#!/bin/bash

prefix="FFTcmass_dr10_south_ir4"
bispec="BISPcmass_dr10_south_ir4"
suffix=".v5.2.wghtv.txt"
sscale=3600.0
box="3600"
grid="480"
iflag=2
FFTdir="/mount/riachuelo1/hahn/FFT/manera_mock/v5p2/"
BISdir="/mount/riachuelo1/hahn/bispec/manera_mock/v5p2/"

ifort -O4 -o bisp_maneramock_v5p2_south.exe bisp_maneramock_v5p2_south.f -L/usr/local/fftw_intel_s/lib -lsrfftw -lsfftw

for P0 in 20000
do
    randFFTname=$FFTdir"FFTcmass_dr10_south_randoms_ir4_combined_wboss.v5.2.wghtv.txt.grid"$grid".P0"$P0".box"$box
    for i in {1..1}
    do 
        if [ $i -lt 10 ]
        then 
            FFTname[$i]=$FFTdir$prefix"00"$i$suffix".grid"$grid".P0"$P0".box"$box
            bispec[$i]=$BISdir$bispec"00"$i$suffix".grid"$grid".P0"$P0".box"$box
        elif [ $i -lt 100 ] 
        then
            FFTname[$i]=$FFTdir$prefix"0"$i$suffix".grid"$grid".P0"$P0".box"$box
            bispec[$i]=$BISdir$bispec"0"$i$suffix".grid"$grid".P0"$P0".box"$box
        else 
            FFTname[$i]=$FFTdir$prefix$i$suffix".grid"$grid".P0"$P0".box"$box
            bispec[$i]=$BISdir$bispec$i$suffix".grid"$grid".P0"$P0".box"$box
        fi
        echo ${FFTname[$i]}
        echo $randFFTname 
        echo ${bispec[$i]}

        ./bisp_maneramock_v5p2_south.exe $iflag $randFFTname ${FFTname[$i]} ${bispec[$i]}
    done
done
