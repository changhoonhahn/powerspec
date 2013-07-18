import numpy as np

dir="/mount/riachuelo1/hahn/data/manera_mock/dr11/"
namebegin="cmass_dr11_south_randoms_ir4"
nameend=".v7.0.wghtv.txt"

ra=[]
dec=[]
red=[]
w1=[]
w2=[]
w3=[]

outputname=dir+"cmass_dr11_south_randoms_ir4_combined_wboss.v7.0.wghtv.txt"
outputfile=open(outputname,'w')
for i in range(1,611):
    if i < 10:
        fname=dir+namebegin+"00"+str(i)+nameend
    elif i < 100:
        fname=dir+namebegin+"0"+str(i)+nameend
    else:
        fname=dir+namebegin+str(i)+nameend
    print i
    data=np.loadtxt(fname)

    for j in range(0,len(data)):
        if (data[j,4] > 0):
            outputfile.write(str(data[j,0])+'\t'+str(data[j,1])+'\t'+str(data[j,2])+'\n')
