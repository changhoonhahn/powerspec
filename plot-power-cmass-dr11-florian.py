import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

will  = np.loadtxt('gCMASS_Pf20000_all.lpow')

chidir = '/mount/chichipio2/hahn/power/'
riadir = '/mount/riachuelo1/hahn/power/'
pridir = '/global/data/scr/chh327/powercode/power/'

S_dr10v8_360 = np.loadtxt(riadir+'power-cmass-dr10v8-S-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
S_dr11v0_360 = np.loadtxt(riadir+'power-cmass-dr11v0-S-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
S_dr11v1_360 = np.loadtxt(riadir+'power-cmass-dr11v1-S-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
S_dr11v2_360 = np.loadtxt(riadir+'power-cmass-dr11v2-S-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
###################################################################################
#Power spectra Comparison

powfig = py.figure(1,figsize=(12,7))
powax00 = powfig.add_subplot(111)

powax00.scatter(S_dr10v8_360[:,0],S_dr10v8_360[:,1],color='r',s=6,label=r"P(k) for DR10v8 South")
powax00.scatter(S_dr11v0_360[:,0],S_dr11v0_360[:,1],color='k',s=6,label=r"P(k) for DR11v0 South")
powax00.scatter(S_dr11v1_360[:,0],S_dr11v1_360[:,1],color='b',s=6,label=r"P(k) for DR11v1 South")
powax00.scatter(S_dr11v2_360[:,0],S_dr11v2_360[:,1],color='m',s=6,label=r"P(k) for DR11v2 South")

powax00.set_xlabel('k', fontsize=15)
powax00.set_ylabel('P(k)', fontsize=15)
powax00.set_yscale('log')
powax00.set_xlim([0.0,0.2])
powax00.set_ylim([10**3,10**5.2])

powax00.legend(loc='best',prop={'size':12})
powax00.grid(True)

py.show()
