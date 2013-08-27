#!bin/bash/

idl -e ".r fibcoll_nbar_comp.pro"

for i in {1..10}; do 
    idl -e "fibcoll_nbar_comp,"$i",/noweight" & 
#    idl -e "fibcoll_nbar_comp,"$i",/upweight" & 
#    idl -e "fibcoll_nbar_comp,"$i",/peaknbar" & 
#    idl -e "fibcoll_nbar_comp,"$i",/random" & 
#    idl -e "fibcoll_nbar_comp,"$i",/random,/peaknbar" &
    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -gt 4 ]; then  
        wait 
    fi 
done 
