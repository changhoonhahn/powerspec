import numpy as np

chidir = "/mount/chichipio2/hahn/data/manera_mock/v5p2/"
riadir = "/mount/riachuelo1/hahn/data/manera_mock/v5p2/"

Nfname = chidir+"cmass_dr10_north_randoms_ir4_combined_wboss.v5.2.wghtv.txt"
Sfname = riadir+"cmass_dr10_south_randoms_ir4_combined_wboss.v5.2.wghtv.txt"

outputname = riadir+"cmass_dr10_NS_randoms_ir4_combined_wboss.v5.2.wghtv.txt"
outputfile = open(outputname,'w')

Ndata = np.loadtxt(Nfname)
Sdata = np.loadtxt(Sfname)

for j in range(0,len(Ndata)):
    outputfile.write(str(Ndata[j,0])+'\t'+str(Ndata[j,1])+'\t'+str(Ndata[j,2])+'\n')

for j in range(0,len(Sdata)):
    outputfile.write(str(Sdata[j,0])+'\t'+str(Sdata[j,1])+'\t'+str(Sdata[j,2])+'\n')
