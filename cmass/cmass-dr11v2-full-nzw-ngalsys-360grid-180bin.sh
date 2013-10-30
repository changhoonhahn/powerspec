#!/bin/bash
name0="cmass-dr11v2-"; nameend="-Anderson-nzw-zlim"; field="N"
ext=".dat"; ranext=".ran.dat"
sscale=3600.0; Rbox=1800.0; box="3600"; P0=20000

fftext="-ngalsys-"$box"lbox-360grid.dat"
fftranext="-ngalsys-"$box"lbox-360grid.ran.dat"
pwrext="-ngalsys-"$box"lbox-360grid-180bin.dat"
FFT="FFT-"
power="power-"

idl -e ".r build_cmass_ns_data.pro"
ifort -O3 -o FFT-fkp-nzw-ngalsys-360grid.exe FFT-fkp-nzw-ngalsys-360grid.f -L/usr/local/fftw_intel_s/lib -lsfftw -lsfftw
ifort -O3 -o power-fkp-ngalwsys-360grid-180bin.exe power-fkp-ngalwsys-360grid-180bin.f

datadir="/global/data/scr/chh327/powercode/data/"
riadir="/mount/riachuelo1/hahn/data/"
FFTdir="/mount/riachuelo1/hahn/FFT/"
powerdir="/mount/riachuelo1/hahn/power/"

idl -e "build_cmass_ns_data,'dr11v2',/north,/nzw"
fname=$riadir$name0$field$nameend$ext
FFTname=$FFTdir$FFT$name0$field$nameend$fftext
echo $fname
./FFT-fkp-nzw-ngalsys-360grid.exe $Rbox 0 $P0 $fname $FFTname
echo $FFTname

randfname=$riadir$name0$field$nameend$ranext
FFTrandname=$FFTdir$FFT$name0$field$nameend$fftranext
./FFT-fkp-nzw-ngalsys-360grid.exe $Rbox 1 $P0 $randfname $FFTrandname

powername=$powerdir$power$name0$field$nameend$pwrext
./power-fkp-ngalwsys-360grid-180bin.exe $FFTrandname $FFTname $powername $sscale
echo $powername
