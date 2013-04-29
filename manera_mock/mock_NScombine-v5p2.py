import numpy as np

chidir = "/mount/chichipio2/hahn/data/manera_mock/v5p2/"
riadir = "/mount/riachuelo1/hahn/data/manera_mock/v5p2/"

Nprefix = "cmass_dr10_north_ir4"
Sprefix = "cmass_dr10_south_ir4"

outprefix = "cmass_dr10_NS_ir4"

suffix = ".v5.2.wghtv.txt"

for i in range(1,611):
    if i < 10:
        Nfname = chidir+Nprefix+"00"+str(i)+suffix
        Sfname = riadir+Sprefix+"00"+str(i)+suffix
        outname = riadir+outprefix+"00"+str(i)+suffix
    elif i < 100:
        Nfname = chidir+Nprefix+"0"+str(i)+suffix
        Sfname = riadir+Sprefix+"0"+str(i)+suffix
        outname = riadir+outprefix+"0"+str(i)+suffix
    else:
        Nfname = chidir+Nprefix+str(i)+suffix
        Sfname = riadir+Sprefix+str(i)+suffix
        outname = riadir+outprefix+str(i)+suffix
    print i
    outputfile = open(outname,'w')

    Ndata = np.loadtxt(Nfname)
    Sdata = np.loadtxt(Sfname)

    for j in range(0,len(Ndata)):
        outputfile.write(str(Ndata[j,0])+'\t'+str(Ndata[j,1])+'\t'+str(Ndata[j,2])+'\t'+str(Ndata[j,3])+'\t'+str(Ndata[j,4])+'\t'+str(Ndata[j,5])+'\t'+str(Ndata[j,6])+'\t'+str(Ndata[j,7])+'\t'+str(Ndata[j,8])+'\t'+str(Ndata[j,9])+'\t'+str(Ndata[j,10])+'\t'+str(Ndata[j,11])+'\n')


    for j in range(0,len(Sdata)):
        outputfile.write(str(Sdata[j,0])+'\t'+str(Sdata[j,1])+'\t'+str(Sdata[j,2])+'\t'+str(Sdata[j,3])+'\t'+str(Sdata[j,4])+'\t'+str(Sdata[j,5])+'\t'+str(Sdata[j,6])+'\t'+str(Sdata[j,7])+'\t'+str(Sdata[j,8])+'\t'+str(Sdata[j,9])+'\t'+str(Sdata[j,10])+'\t'+str(Sdata[j,11])+'\n')

