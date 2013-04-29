import numpy as np
import pylab as py
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

fdir="/mount/chichipio2/hahn/data/manera_mock/"
fname="cmass_dr10_north_ir4001.v5.1.wght.txt"

data = np.loadtxt(fdir+fname)

bin = []
for i in range(0,41):
    bin.append(0.4+0.01*np.float(i))

py.figure(1)
ax1 = py.subplot(2,1,1)
ax2 = py.subplot(2,1,2)
hist1 = ax1.hist(data[:,2],bin,color='b',label='RSD Redshift')#,histtype='bar')
hist2 = ax1.hist(data[:,7],bin,color='r',label='True Redshift')#,histtype='bar')
#print hist1[0]
#print hist2[0]
ax1.legend(loc='best',prop={'size':14})
ax2.set_xlabel('Redshift (z)',fontsize=15)

#rsd=[float(i) for i in hist1[0]]
#true=[float(j) for j in hist2[0]]

ratio=[]
for i in range(0,len(hist1[0])):
    if hist1[0][i]==0:
        ratio.append(0.0)
    else:
        ratio.append(float(hist2[0][i])/float(hist1[0][i]))

bin=[float(i)+0.005 for i in bin]
ax2.plot(bin[0:40],ratio,color='k',label="z_{True}/z_{RSD}")
ax2.set_ylabel(r"$z_{True}/z_{RSD}$",fontsize=16)
ax2.set_ylim([0.95,1.05])


###############################################################################
#Comparison between the histogram and nbar#####################################
###############################################################################
nbar=np.loadtxt('/mount/chichipio2/hahn/data/manera_mock/nbar-dr10v5-N-Anderson.dat')
py.figure(2)
ax3 = py.subplot(1,1,1)
#ax4 = py.subplot(1,2,2)
ax3.plot(bin[0:40],hist1[0])#/max(hist1[0]),color='k')
ax3.plot(nbar[50:201,0],max(hist1[0])*nbar[50:201,3]/max(nbar[50:201,3]),color='b')
ax3.set_xlim([0.4,0.8])
#ax3.set_ylim([0.0,1.0])

#ax4.set_xlim([0.4,0.8])
#ax4.set_ylim([0.0,1.0])

###############################################################################
#Histogram of the randomly generated redshift##################################
###############################################################################
cprand=np.loadtxt('/mount/chichipio2/hahn/data/manera_mock/cp-rand-cmass_dr10_north_ir4001.v5.1.wght.txt')
py.figure(3)
ax5 = py.subplot(1,1,1)
cpranhist = ax5.hist(cprand[:,2],bin,label='Randomly Generated Redshift')
ax5.plot(nbar[70:201,0],max(cpranhist[0])*nbar[70:201,3]/max(nbar[70:201,3]),color='r',linewidth=3)
ax5.set_xlabel("Redshift (z)")
ax5.set_title("Redshift Distribution of Randomly Generated Redshift")
py.show()
