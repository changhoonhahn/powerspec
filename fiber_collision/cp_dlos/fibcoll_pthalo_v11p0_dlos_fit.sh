#!bin/bash
idl -e ".r fibcoll_pthalo_v11p0_dlos.pro"

echo "n="; read n 

for i in $(seq 1 $n); do 
    idl -e "fibcoll_pthalo_v11p0_dlos,"$i
done
ipython fibcoll_pthalo_v11p0_dlos_fit.py $n 
