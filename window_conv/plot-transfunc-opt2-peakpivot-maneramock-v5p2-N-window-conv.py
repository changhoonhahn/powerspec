import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate
from matplotlib import rc

rc('text',usetex=True)
rc('font',family='serif')

path='/mount/chichipio2/hahn/power/manera_mock/v5p2/'

sim=np.loadtxt('transfunc-ariana-opt2-peakpivot.dat')
power=np.loadtxt(path+'power_cmass_dr10_north_ir4001.v5.2.wghtv.txt_now.grid240.P020000.box4800')
winconv=np.loadtxt(path+'transfunc-windowconvpower_cmass_dr10_north_ir4001.v5.2.wghtv.txt_now.grid240.P020000.box4800')

power_maxindx = np.argmax(power[:,1])
sim_maxindx = np.argmax(sim[:,1])
#conv_pivot = interpolate.interp1d(winconv[:,0],winconv[:,1],kind='quadratic')((power[:,0])[power_maxindx])
conv_pivot = interpolate.interp1d(winconv[:,0],winconv[:,1],kind='quadratic')((sim[:,0])[sim_maxindx])
#ratio=power[power_maxindx,1]/conv_pivot
ratio=sim[sim_maxindx,1]/conv_pivot
print ratio

winconv[:,1]=ratio*winconv[:,1]

fig0 = py.figure(1, figsize=(14,8))
ax00 = fig0.add_subplot(121)
ax01 = fig0.add_subplot(122)

fig1 = py.figure(2, figsize=(7,8))
ax10 = fig1.add_subplot(111)

ax00.loglog(winconv[:,0],winconv[:,1],'r',linewidth=2,label=r'$P_{convol}(k)$')
ax00.loglog(power[:,0],power[:,1],'b--',linewidth=2,label=r'$P_{window}(k)$')
ax00.loglog(sim[:,0],sim[:,1],'k--',linewidth=2,label=r'$P_{transf}(k)$')
ax01.loglog(power[:,0],power[:,4],linewidth=2,label=r'$P_r(k)$')


winconvratio = [ winconv[k,1]/sim[k,1] for k in range(len(winconv[:,1])) ]
ax10.plot(winconv[:,0], winconvratio, linewidth=2, label=r"$\frac{P_{convol}(k)}{P_{transf}(k)}$")

ax00.set_xlim([10**-3,10**0])
ax01.set_xlim([10**-3,10**0])
ax00.set_ylim([10**3,10**5.2])
ax10.set_xlim([10**-3,10**0])

ax00.set_xlabel('k',fontsize=15)
ax01.set_xlabel('k',fontsize=15)
ax10.set_xlabel('k',fontsize=15)
ax00.set_ylabel('P(k)',fontsize=15)
ax10.set_ylabel(r"${P_{convol}(k)}/{P_{transf}(k)}$",fontsize=17)

ax10.set_xscale('log')

ax00.grid(True)
ax01.grid(True)
ax10.grid(True)
ax00.legend(loc='lower left',prop={'size':18})
ax01.legend(loc='lower left',prop={'size':18})
ax10.legend(loc='best',prop={'size':18})
py.show()
