#!bin/bash
idl -e ".r fibcoll_dlos_fit.pro"

echo "n="; read n 

for i in $(seq 1 $n); do 
    idl -e "fibcoll_dlos_fit,"$i
done
ipython fibcoll_dlos_fit.py $n 
