#!bin/bash/
idl -e ".r fibcoll_nbar_comp_norm.pro"

for i in {1..8}; do 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/noweight,/dr10" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/upweight,/dr10" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/noweight" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/upweight" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/peaknbar" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/random,/dr10" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/random" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/randpeak" &
#    idl -e "fibcoll_nbar_comp_norm,"$i",/noweight,/dr11test" & 
#    idl -e "fibcoll_nbar_comp_norm,"$i",/wboss,/dr11test" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",/upweight" & 
    idl -e "fibcoll_nbar_comp_norm,"$i",/random" & 
    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then  
        wait 
    fi 
done 
#idl -e "fibcoll_nbar_comp_norm,1,/cmass"
#idl -e "fibcoll_nbar_comp_norm,1,/cmass,/dr10"
#idl -e "fibcoll_nbar_comp_norm,1,/combined" 
