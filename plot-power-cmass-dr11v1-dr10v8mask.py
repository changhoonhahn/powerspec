import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

chidir = '/mount/chichipio2/hahn/power/'
riadir = '/mount/riachuelo1/hahn/power/'
pridir = '/global/data/scr/chh327/powercode/power/'

S_dr10v8_360 = np.loadtxt(riadir+'power-cmass-dr10v8-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

N_dr11v0_360 = np.loadtxt(riadir+'power-cmass-dr11v0-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
S_dr11v0_360 = np.loadtxt(riadir+'power-cmass-dr11v0-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

N_dr11v1_360 = np.loadtxt(riadir+'power-cmass-dr11v1-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
S_dr11v1_360 = np.loadtxt(riadir+'power-cmass-dr11v1-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

S_dr11v1_mask_360 = np.loadtxt(riadir+'power-cmass-dr11v1-S-Anderson-nzw-zlim-dr10v8mask-ngalsys-3600lbox-360bin-180bin.dat')
###################################################################################
#Power spectra Comparison

powfig = py.figure(1,figsize=(7,8))
powax01 = powfig.add_subplot(111)

powax01.scatter(S_dr10v8_360[:,0],S_dr10v8_360[:,1],color='b', label=r"P(k) for DR10v8 South")
powax01.scatter(S_dr11v1_360[:,0],S_dr11v1_360[:,1],color='r', label=r"P(k) for DR11v1 South")
powax01.loglog(S_dr11v1_mask_360[:,0],S_dr11v1_mask_360[:,1],'k',linewidth=2, label=r"P(k) for DR11v1 South with DR10v8 Mask") 

powax01.set_xlabel('k', fontsize=15)
powax01.set_ylabel('P(k)', fontsize=15)

powax01.set_xlim([10**-3,10**0])
powax01.set_ylim([10**3,10**5.5])

powax01.legend(loc='best',prop={'size':12})
powax01.grid(True)
py.show()
