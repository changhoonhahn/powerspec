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

N_dr11v0_960 = np.loadtxt(riadir+'power-cmass-dr11v0-N-Anderson-nzw-zlim-ngalsys-3600lbox-960grid-480bin.dat')
S_dr11v0_960 = np.loadtxt(riadir+'power-cmass-dr11v0-S-Anderson-nzw-zlim-ngalsys-3600lbox-960grid-480bin.dat')

N_dr11v1_960 = np.loadtxt(riadir+'power-cmass-dr11v1-N-Anderson-nzw-zlim-ngalsys-3600lbox-960grid-480bin.dat')
S_dr11v1_960 = np.loadtxt(riadir+'power-cmass-dr11v1-S-Anderson-nzw-zlim-ngalsys-3600lbox-960grid-480bin.dat')

N_dr11v2_960 = np.loadtxt(riadir+'power-cmass-dr11v2-N-Anderson-nzw-zlim-ngalsys-3600lbox-960grid-480bin.dat')
S_dr11v2_960 = np.loadtxt(riadir+'power-cmass-dr11v2-S-Anderson-nzw-zlim-ngalsys-3600lbox-960grid-480bin.dat')
###################################################################################
#Power spectra Comparison of Different DR11 versions

powfig = py.figure(1,figsize=(14,8))
powax00 = powfig.add_subplot(121)
powax01 = powfig.add_subplot(122)

powax00.scatter(N_dr11v0_960[:,0],N_dr11v0_960[:,1],color='b', label=r"P(k) for DR11v0 North $L_{Box}=3600 Mpc/h, N_{grid}=960$")
powax01.scatter(S_dr11v0_960[:,0],S_dr11v0_960[:,1],color='b', label=r"P(k) for DR11v0 South $L_{Box}=3600 Mpc/h, N_{grid}=960$")
powax00.scatter(N_dr11v1_960[:,0],N_dr11v1_960[:,1],color='m', label=r"P(k) for DR11v1 North $L_{Box}=3600 Mpc/h, N_{grid}=960$")
powax01.scatter(S_dr11v1_960[:,0],S_dr11v1_960[:,1],color='m', label=r"P(k) for DR11v1 South $L_{Box}=3600 Mpc/h, N_{grid}=960$")
powax00.loglog(N_dr11v2_960[:,0],N_dr11v2_960[:,1],'k',linewidth=2, label=r"P(k) for DR11v1 North $L_{Box}=3600 Mpc/h, N_{grid}=960$")
powax01.loglog(S_dr11v2_960[:,0],S_dr11v2_960[:,1],'k',linewidth=2, label=r"P(k) for DR11v1 South $L_{Box}=3600 Mpc/h, N_{grid}=960$")

powax01.get_yaxis().set_ticklabels([])
powax00.set_xlabel('k', fontsize=15)
powax01.set_xlabel('k', fontsize=15)
powax00.set_ylabel('P(k)', fontsize=15)

powax00.set_xlim([10**-3,10**0])
powax00.set_ylim([10**3,10**5.2])
powax01.set_xlim([10**-3,10**0])
powax01.set_ylim([10**3,10**5.2])

#powax00.tick_params(labelsize=15)
#powax01.tick_params(labelsize=15)

powax00.legend(loc='best',prop={'size':12})
powax01.legend(loc='best',prop={'size':12})
powax00.grid(True)
powax01.grid(True)
powfig.subplots_adjust(left=0.10,right=0.90,wspace=0.0,hspace=0.0)

py.show()
