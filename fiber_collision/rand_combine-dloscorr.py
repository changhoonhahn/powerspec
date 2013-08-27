import numpy as np
import sys

dir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
namebegin="cmass_dr11_north_randoms_ir4"
nameend="_dlosshfl_corr.v7.0.wghtv.txt"

n=sys.argv[1]
outputname = dir+"cmass_dr11_north_"+n+"_randoms_ir4_dlosshfl_corr_combined_wboss.v7.0.wghtv.txt"
outputfile = open(outputname,'w')
for i in range(1,int(n)+1):
    fname = dir+namebegin+str(i+1000)[1:4]+nameend
    print fname 

    data = np.loadtxt(fname)
    for j in range(0,len(data)):
        if (data[j,3] > 0):
            outputfile.write(str(data[j,0])+'\t'+str(data[j,1])+'\t'+str(data[j,2])+'\n')
exit()
