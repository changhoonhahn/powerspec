import numpy as np

dir="/mount/chichipio2/hahn/data/manera_mock/"
namebegin="cmass_dr10_north_randoms_ir4"
nameend=".v5.1.wght.txt"

ra=[]
dec=[]
red=[]

for i in range(1,301):
    if i < 10:
        fname=dir+namebegin+"00"+str(i)+nameend
    elif i < 100:
        fname=dir+namebegin+"0"+str(i)+nameend
    else:
        fname=dir+namebegin+str(i)+nameend
    print i
    data=np.loadtxt(fname)

    ra=np.append(ra,data[:,0])
    dec=np.append(dec,data[:,1])
    red=np.append(red,data[:,2])

print ra,dec,red

output = np.empty((len(ra),3))
output[:,0]=ra
output[:,1]=dec
output[:,2]=red
print output

outputname=dir+"cmass_dr10_north_randoms_ir4_combined.v5.1.wght.txt"
np.savetxt(outputname,output)


