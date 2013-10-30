#!/bin/bash

idl -e ".r fibcoll_nbar_comp_norm.pro"

echo "n="; read n 
for i in $(seq 1 $n); do 
    idl -e "fibcoll_nbar_comp_norm,"$i",'wghtv',/upweight" &
    idl -e "fibcoll_nbar_comp_norm,"$i",'upweight.makerandom',/random" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",'upweight.makerandom.test1',/random" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",'upweight.makerandom.test2',/random" & 
    
    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then
        wait
    fi 
done
idl -e "fibcoll_nbar_comp_norm,1,/cmass"
