import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/v5p2/'

P0 = [20000]
Lbox = [3600,4000,4800,8000]
colors = [ 'k','b','m','r' ]

fig0 = plt.figure(1,figsize=(7,8))
ax00 = fig0.add_subplot(111)

fname0 = "power_cmass_dr10_north_ir4"
fname1 = ".v5.2.wghtv.txt_wboss.grid480.P0"
fname2 = ".box"

for j in range(len(P0)):
    n=0
    for k in range(len(Lbox)):
        for i in range(1,2):
            if i < 10:
                L = fname0+'00'+str(i)+fname1+str(P0[j])+fname2+str(Lbox[k])
            elif i < 100:
                L = fname0+'0'+str(i)+fname1+str(P0[j])+fname2+str(Lbox[k])
            else:
                L = fname0+str(i)+fname1+str(P0[j])+fname2+str(Lbox[k])
            data_L = np.loadtxt(dir+L)
            ax00.loglog(data_L[:,0],data_L[:,1], colors[k], linewidth=2, label="Lbox = "+str(Lbox[k])+"Mpc")

            if i==1:
                Lboxavg = np.zeros([len(data_L)])
                Lboxavg = Lboxavg + data_L[:,1]
                n=n+1

ax00.legend(loc='best')
ax00.set_xlim([10**-3,10**0])
ax00.set_ylim([10**3,10**5.2])
ax00.set_xlabel('k')
ax00.set_ylabel('P(k)')
ax00.grid(True)
py.show()
