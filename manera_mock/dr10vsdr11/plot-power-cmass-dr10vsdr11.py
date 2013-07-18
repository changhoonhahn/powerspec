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

N_dr10v8_360 = np.loadtxt(riadir+'power-cmass-dr10v8-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
S_dr10v8_360 = np.loadtxt(riadir+'power-cmass-dr10v8-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

N_dr11v0_360 = np.loadtxt(riadir+'power-cmass-dr11v0-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
S_dr11v0_360 = np.loadtxt(riadir+'power-cmass-dr11v0-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

N_dr11v1_360 = np.loadtxt(riadir+'power-cmass-dr11v1-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
S_dr11v1_360 = np.loadtxt(riadir+'power-cmass-dr11v1-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

N_dr11v2_360 = np.loadtxt(riadir+'power-cmass-dr11v2-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
S_dr11v2_360 = np.loadtxt(riadir+'power-cmass-dr11v2-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

###################################################################################
#Power spectra Comparison

powfig = py.figure(1,figsize=(14,8))
powax00 = powfig.add_subplot(121)
powax01 = powfig.add_subplot(122)

powax00.loglog(N_dr10v8_360[:,0],N_dr10v8_360[:,1],'ko',linewidth=3, label=r"P(k) for DR10v8 North $L_{Box}=3600 Mpc/h, N_{grid}=360$")
powax01.loglog(S_dr10v8_360[:,0],S_dr10v8_360[:,1],'ko',linewidth=3, label=r"P(k) for DR10v8 South $L_{Box}=3600 Mpc/h, N_{grid}=360$")
powax00.loglog(N_dr11v2_360[:,0],N_dr11v2_360[:,1],'r--',linewidth=3, label=r"P(k) for DR11v2 North $L_{Box}=3600 Mpc/h, N_{grid}=360$")
powax01.loglog(S_dr11v2_360[:,0],S_dr11v2_360[:,1],'r--',linewidth=3, label=r"P(k) for DR11v2 South $L_{Box}=3600 Mpc/h, N_{grid}=360$")
powax00.loglog(N_dr11v1_360[:,0],N_dr11v1_360[:,1],'b--',linewidth=1, label=r"P(k) for DR11v1 North $L_{Box}=3600 Mpc/h, N_{grid}=360$")
powax01.loglog(S_dr11v1_360[:,0],S_dr11v1_360[:,1],'b--',linewidth=1, label=r"P(k) for DR11v1 South $L_{Box}=3600 Mpc/h, N_{grid}=360$")

powax00.set_xlabel('k', fontsize=15)
powax01.set_xlabel('k', fontsize=15)
powax00.set_ylabel('P(k)', fontsize=15)

powax00.set_xlim([10**-3.2,10**0])
powax00.set_ylim([10**3,10**5.2])

powax01.set_xlim([10**-3.2,10**0])
powax01.set_ylim([10**3,10**5.2])

powax00.legend(loc='best',prop={'size':12})
powax00.grid(True)
powax01.legend(loc='best',prop={'size':12})
powax01.grid(True)

powax00.tick_params(labelsize=14)
powax01.get_yaxis().set_ticklabels([])
powax01.tick_params(labelsize=14)

powfig.subplots_adjust(left=0.10,right=0.90,wspace=0.0,hspace=0.0)

py.show()
