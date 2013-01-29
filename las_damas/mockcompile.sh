#!/bin/bash

name0="sdssmock_gamma_lrgFull_zm_oriana"
nameend="_no.rdcz.dat"
randname="sdssmock_gamma_lrgFull.rand_200x_no.rdcz.dat"
Rbox=1200.0

for P0 in 0 10000 20000 30000 40000
do 
    for i in {1..40}
    do
        for letter in a b c d 
        do 
            if [ $i -lt 10 ]
            then
                fname[$i]=$name0"0"$i$letter$nameend
                FFTname[$i]="FFT"$name0"0"$i$letter$nameend"P0"$P0
            else
                fname[$i]=$name0$i$letter$nameend
                FFTname[$i]="FFT"$name0$i$letter$nameend"P0"$P0
            fi
            ./FFT-fkp-mock.exe $Rbox 0 $P0 ${fname[$i]} ${FFTname[$i]}
        done
    done
done 
