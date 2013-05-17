import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text',usetex=True)
rc('font',family='serif')

path='/mount/chichipio2/hahn/power/manera_mock/v5p2/'

sim=np.loadtxt('transfunc-ariana-opt2-peakpivot.dat')
power=np.loadtxt(path+'power_cmass_dr10_north_ir4001.v5.2.wghtv.txt_now.grid240.P020000.box4800')
winconv=np.loadtxt(path+'transfunc-windowconvpower_cmass_dr10_north_ir4001.v5.2.wghtv.txt_now.grid240.P020000.box4800')

ratio=sim[0,1]/winconv[0,1]
print ratio

winconv[:,1]=ratio*winconv[:,1]

fig0 = py.figure(1, figsize=(7,8))
ax00 = fig0.add_subplot(111)

ax00.loglog(sim[:,0],sim[:,1],'k--',label='Simulated Data')
ax00.loglog(power[:,0],power[:,4],'b',label='Window Power')
ax00.loglog(winconv[:,0],winconv[:,1],'r',label='Window Convolved')

ax00.set_xlim([10**-3,10**0])
ax00.set_ylim([10**3,10**5.2])

ax00.set_xlabel('k',fontsize=15)
ax00.set_ylabel('P(k)',fontsize=15)
ax00.grid(True)
ax00.legend(loc='lower left',prop={'size':12})
py.show()
