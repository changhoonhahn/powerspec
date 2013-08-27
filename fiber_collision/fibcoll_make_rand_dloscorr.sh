#!/bin/bash
maxjobs=6

idl -e ".r fibcoll_make_rand_dloscorr.pro"

for i in {1..25}
do 
    jobcnt=(`jobs -p`)
    if [ ${#jobcnt[@]} -lt $(( $maxjobs-3)) ] ; then 
        idl -e "fibcoll_make_rand_dloscorr,"$i",466264987" & 
        shift 
    fi 
done 
wait 

ipython -noconfirm_exit rand_combine-dloscorr.py 25
