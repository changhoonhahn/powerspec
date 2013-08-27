#!bin/bash

idl -e ".r fibcoll_dlos_fit.pro"

idl -e "fibcoll_dlos_fit, 1"

ipython fibcoll_dlos_fit.py 1 
