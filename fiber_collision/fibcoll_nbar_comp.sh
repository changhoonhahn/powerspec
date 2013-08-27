#!/bin/bash

idl -e ".r fibcoll_nbar_comp.pro"

for i in {1..25} 
do 
    echo $i
    idl -e "fibcoll_nbar_comp,"$i",/noweight" &  
    idl -e "fibcoll_nbar_comp,"$i",/upweight" & 
    idl -e "fibcoll_nbar_comp,"$i",/shuffle" & 
    wait 
done 
ipython -noconfirm_exit fibcoll_nbar_comp.py 

idl -e "fibcoll_nbar_comp,1,/random"
