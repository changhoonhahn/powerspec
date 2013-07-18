#!/bin/bash
sscale=3600.0
Rbox=1800.0
box="3600"
fftext="-ngalsys-"$box"lbox-360grid.dat"
fftranext="-ngalsys-"$box"lbox-360grid.ran.dat"
pwrext="-ngalsys-"$box"lbox-360bin-180bin.dat"
FFT="FFT-"
power="power-"

ifort -O3 -o FFT-fkp-nzw-ngalsys-360grid.exe FFT-fkp-nzw-ngalsys-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw

datadir="/global/data/scr/chh327/powercode/data/"
FFTdir="/mount/riachuelo1/hahn/FFT/"
powerdir="/mount/riachuelo1/hahn/power/"

for P0 in 20000
do
    fname=$datadir"cmass-dr11v2-S-Anderson-nzw-zlim-dr10v8mask.dat"
    FFTname=$FFTdir$FFT"cmass-dr11v2-S-Anderson-nzw-zlim-dr10v8mask"$fftext
    echo $fname
    echo $FFTname
    ./FFT-fkp-nzw-ngalsys-360grid.exe $Rbox 0 $P0 $fname $FFTname

    randfname=$datadir"cmass-dr11v2-S-Anderson-nzw-zlim-dr10v8mask.ran.dat"
    FFTrandname=$FFTdir$FFT"cmass-dr11v2-S-Anderson-nzw-zlim-dr10v8mask"$fftranext
    if [ -a $FFTrandname ] 
    then
        echo $FFTrandname" exists"
    else 
        echo $FFTrandname" does not exist"
        ./FFT-fkp-nzw-ngalsys-360grid.exe $Rbox 1 $P0 $randfname $FFTrandname
        echo "now it does"
    fi

    ifort -O3 -o power-fkp-ngalwsys-360grid-180bin.exe power-fkp-ngalwsys-360grid-180bin.f
    powername=$powerdir$power"cmass-dr11v2-S-Anderson-nzw-zlim-dr10v8mask"$pwrext
    
    ./power-fkp-ngalwsys-360grid-180bin.exe $FFTrandname $FFTname $powername $sscale
    echo $powername
done
