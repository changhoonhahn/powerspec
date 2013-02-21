import numpy as np
import pylab as py
import matplotlib.pyplot as plt

path='/mount/chichipio2/hahn/power/'

sim=np.loadtxt(path+'power_sdssmock_gamma_lrgFull_zm_oriana01a_no.rdcz.datP020000')
power=np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-960grid-480bin.dat')
winconv=np.loadtxt(path+'power-sdssmock-dr10v5-window-convol.dat')

ratio=sim[0,1]/winconv[0,1]
print ratio

winconv[:,1]=ratio*winconv[:,1]

py.figure()
plt.plot(np.log10(sim[:,0]),np.log10(sim[:,1]),'k--',label='Simulated Data')
plt.plot(np.log10(winconv[:,0]),np.log10(winconv[:,1]),'r',label='Window Convolved')
py.xlim([-2.0,0.0])
py.xlabel('k',fontsize=15)
py.ylabel('P(k)',fontsize=15)
plt.grid(True)
py.legend(loc='lower left',prop={'size':12})
py.show()
