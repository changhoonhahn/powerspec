import numpy as np
import pylab as py
import random as ran
from scipy import interpolate
import sys 

n           = int(sys.argv[1])
file_dir    = sys.argv[2]
file_name   = sys.argv[3] 

for i in range(1,n+1): 
    fname_upw   = 'nbar-normed-cmass_dr11_north_ir4'+str(i+1000)[1:4]+'.v7.0.upweight.txt'
    data_upw    = np.loadtxt(file_dir+fname_upw)

    if i==1: 
        zmid    = data_upw[:,0]
        sum_upw = data_upw[:,3]
    else: 
        sum_upw = sum_upw+data_upw[:,3]
nbar_pz_upw = sum_upw/np.max(sum_upw)

outputfile  = file_dir+file_name
output = open(outputfile,'w')
for i in range(len(zmid)): 
    output.write(str(zmid[i])+'\t'+str(nbar_pz_upw[i])+'\n')
exit()
