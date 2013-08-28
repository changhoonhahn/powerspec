#!bin/bash/
idl -e ".r fibcoll_nbar_comp_norm.pro"

for i in {1..10}; do 
    idl -e "fibcoll_nbar_comp_norm,"$i",/noweight" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",/upweight" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",/peaknbar" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",/random" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",/randpeak" &
    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then  
        wait 
    fi 
done 

idl -e "fibcoll_nbar_comp_norm,1,/cmass"
