#!bin/bash
idl -e ".r fibcoll_cmass_dlos.pro"

idl -e "fibcoll_cmass_dlos,/north"
ipython fibcoll_cmass_dlos_fit.py 
