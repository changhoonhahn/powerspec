#!/bin/bash

randname="sdssmock_gamma_lrgFull.rand_200x_no.rdcz.dat"
Rbox=1200.0

for P0 in 0 10000 20000 30000 40000
do
    FFTname[$i]="FFT"$randname"P0"$P0
        ./FFT-fkp-mock.exe $Rbox 1 $P0 $randname ${FFTname[$i]}
done 
