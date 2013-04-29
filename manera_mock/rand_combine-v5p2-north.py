import numpy as np

dir="/mount/chichipio2/hahn/data/manera_mock/v5p2/"
namebegin="cmass_dr10_north_randoms_ir4"
nameend=".v5.2.wghtv.txt"

outputname=dir+"cmass_dr10_north_randoms_ir4_combined.v5.2.wghtv.txt"
outputfile=open(outputname,'w')
for i in range(1,301):
    if i < 10:
        fname=dir+namebegin+"00"+str(i)+nameend
    elif i < 100:
        fname=dir+namebegin+"0"+str(i)+nameend
    else:
        fname=dir+namebegin+str(i)+nameend
    print i
    data=np.loadtxt(fname)

    for j in range(0,len(data)):
        outputfile.write(str(data[j,0])+'\t'+str(data[j,1])+'\t'+str(data[j,2])+'\n')