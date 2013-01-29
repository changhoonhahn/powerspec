#!/bin/bash

name0="sdssmock_gamma_lrgFull_zm_oriana"
nameend="_no.rdcz.dat"
randname="sdssmock_gamma_lrgFull.rand_200x_no.rdcz.dat"
sscale=2400.0

for P0 in 0 10000 20000 30000 40000
do
    for i in {1..40}
    do 
        for letter in a b c d
        do 
            if [ $i -lt 10 ] 
            then 
                FFTname[$i]="FFT"$name0"0"$i$letter$nameend"P0"$P0
                powername[$i]="power_"$name0"0"$i$letter$nameend"P0"$P0
            else 
                FFTname[$i]="FFT"$name0$i$letter$nameend"P0"$P0
                powername[$i]="power_"$name0$i$letter$nameend"P0"$P0
            fi 
            ./power-fkp-mock.exe "FFT"$randname"P0"$P0 ${FFTname[$i]} ${powername[$i]} $sscale
        done
    done
done
