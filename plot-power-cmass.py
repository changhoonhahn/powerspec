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

full_dr10v8 = np.loadtxt(riadir+'power-cmass-dr10v8-full-Anderson-nzw-zlim-ngalsys-360bin-180bin.dat')
full_dr10v8_I22g = np.loadtxt(riadir+'power-cmass-dr10v8-full-Anderson-nzw-zlim-I22g-alpha-360bin-180bin.dat')

###################################################################################
#Power spectra Comparison

powfig = py.figure(1,figsize=(7,8))
powax00 = powfig.add_subplot(111)

powax00.loglog(will[:,1],will[:,2],'k--',linewidth=2, label="Percival gCMASS-Pf20000-all.lpow")
powax00.loglog(full_dr10v8[:,0],full_dr10v8[:,1],'b',linewidth=2, label="full-dr10v8")
powax00.loglog(full_dr10v8_I22g[:,0],full_dr10v8_I22g[:,1],'g',linewidth=2, label="full-dr10v8-I22g")

powax00.set_xlabel('k', fontsize=15)
powax00.set_ylabel('P(k)', fontsize=15)

powax00.set_xlim([10**-3,10**0])
powax00.set_ylim([10**3,10**5.2])

powax00.legend(loc='best',prop={'size':16})
powax00.grid(True)

py.show()
