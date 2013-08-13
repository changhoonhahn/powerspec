#!/bin/bash

idl -e ".r fibcoll_nbar_comp.pro"

for i in {11..25} 
do 
    idl -e "fibcoll_nbar_comp,"$i",/noweight"
    idl -e "fibcoll_nbar_comp,"$i",/upweight"
    idl -e "fibcoll_nbar_comp,"$i",/shuffle"
done 

ipython -noconfirm_exit fibcoll_nbar_comp.py 
