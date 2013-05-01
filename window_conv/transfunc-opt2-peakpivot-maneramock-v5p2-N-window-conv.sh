#!/bin/bash

ifort -O3 -o transfunc-maneramock-v5p2-N-windconv.exe sdssmock-window-conv.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

dir="/mount/chichipio2/hahn/power/manera_mock/v5p2/"
windowfname="power_cmass_dr10_north_ir4001.v5.2.wghtv.txt_now.grid240.P020000.box4800"
simfname="transfunc-ariana-opt2-peakpivot.dat"
outfname="transfunc-windowconv"$windowfname

./transfunc-maneramock-v5p2-N-windconv.exe $dir$windowfname $simfname $outfname
