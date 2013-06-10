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

N_dr11v0_360 = np.loadtxt(riadir+'power-cmass-dr11v0-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
S_dr11v0_360 = np.loadtxt(riadir+'power-cmass-dr11v0-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
N_dr11v0_960 = np.loadtxt(riadir+'power-cmass-dr11v0-N-Anderson-nzw-zlim-ngalsys-4800lbox-960grid-480bin.dat')
S_dr11v0_960 = np.loadtxt(riadir+'power-cmass-dr11v0-S-Anderson-nzw-zlim-ngalsys-4800lbox-960grid-480bin.dat')

###################################################################################
#Power spectra Comparison

powfig = py.figure(1,figsize=(7,8))
powax00 = powfig.add_subplot(111)

#powax00.loglog(will[:,1],will[:,2],'k--',linewidth=2, label="Percival gCMASS-Pf20000-all.lpow")
powax00.loglog(N_dr11v0_360[:,0],N_dr11v0_360[:,1],'b--',linewidth=2, label=r"P(k) for DR11v0 North $L_{Box}=3600 Mpc/h, N_{grid}=360$")
powax00.loglog(S_dr11v0_360[:,0],S_dr11v0_360[:,1],'r--',linewidth=2, label=r"P(k) for DR11v0 South $L_{Box}=3600 Mpc/h, N_{grid}=360$")
powax00.loglog(N_dr11v0_960[:,0],N_dr11v0_960[:,1],'b',linewidth=2, label=r"P(k) for DR11v0 North $L_{Box}=4800 Mpc/h, N_{grid}=960$")
powax00.loglog(S_dr11v0_960[:,0],S_dr11v0_960[:,1],'r',linewidth=2, label=r"P(k) for DR11v0 South $L_{Box}=4800 Mpc/h, N_{grid}=960$")

powax00.set_xlabel('k', fontsize=15)
powax00.set_ylabel('P(k)', fontsize=15)

powax00.set_xlim([10**-3,10**0])
powax00.set_ylim([10**3,10**5.2])

powax00.legend(loc='best',prop={'size':12})
powax00.grid(True)

py.show()
