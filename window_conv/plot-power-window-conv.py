import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text',usetex=True)
rc('font',family='serif')

path='/mount/chichipio2/hahn/power/'

sim=np.loadtxt(path+'power_sdssmock_gamma_lrgFull_zm_oriana01a_no.rdcz.datP020000')
power=np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-960grid-480bin.dat')
winconv=np.loadtxt(path+'power-sdssmock-dr10v5-window-convol.dat')

ratio=sim[0,1]/winconv[0,1]
print ratio

winconv[:,1]=ratio*winconv[:,1]

fig0 = py.figure(1,figsize=(7,8))
ax00 = fig0.add_subplot(111)

ax00.loglog(sim[:,0],sim[:,1],'k--',linewidth=2,label='Simulated Data')
ax00.loglog(winconv[:,0],winconv[:,1],'r',linewidth=2,label='Window Convolved')

ax00.set_xlim([10**-3,10**0])
ax00.set_ylim([10**3,10**5.2])

ax00.set_xlabel('k',fontsize=15)
ax00.set_ylabel('P(k)',fontsize=15)
ax00.grid(True)
ax00.legend(loc='best',prop={'size':12})
py.show()
