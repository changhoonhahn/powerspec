import numpy as np
import pylab as py
import sys
from scipy.integrate import simps
from scipy import integrate
from scipy.optimize import curve_fit
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

n   = int(sys.argv[1])
dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'

disp_los    = np.loadtxt(dir+'cmass_dr11_north_ir4'+str(n+1000)[1:4]+'v7.0_dlos.dat')
data        = np.loadtxt('/global/data/scr/chh327/powercode/data/cmass_dr11_north_ir4'+str(n+1000)[1:4]+'.v7.0.wghtv.txt')

mpc_bin = -1000.0+0.1*np.array(range(20001))

fig4 = py.figure(4)
dump = fig4.add_subplot(111)

hist_disp_los   = dump.hist(disp_los,mpc_bin, label='Line of Sight Displacement Histogram')
disp_los_x      = [ (hist_disp_los[1][i] + hist_disp_los[1][i+1])/2.0 for i in range(len(hist_disp_los[1])-1) ]

def expon(x,sig,A):
    return A*np.exp(-np.absolute(x)/sig)/(2.0*sig)

popt, pcov = curve_fit(expon,np.array(disp_los_x[10000:10010]),hist_disp_los[0][10000:10010],p0=[0.4,np.max(hist_disp_los[0])])
print popt[1]/np.trapz(hist_disp_los[0],x=disp_los_x)

fig1 = py.figure(1)
ax1 = fig1.add_subplot(111)
ax1.plot(disp_los_x, hist_disp_los[0],linewidth=3, label=r'Histogram of $d_{LOS}$')
ax1.plot(disp_los_x[10000:10100],expon(np.array(disp_los_x[10000:10100]),popt[0],popt[1]), 'r', linewidth=3, label=r'Exponential distribution with $\sigma=$'+str(popt[0])[0:6]+' and $A=$'+str(popt[1])[0:6])
ax1.set_xlim([-5.0,5.0])
ax1.set_ylim([0.0,2000.0])
ax1.set_xlabel('Displacement (Mpc)')
ax1.set_ylabel('Number of Galaxies')
ax1.legend(loc='best')

for d in [0.5,1.0,1.5,2.0,2.5]: 
    expfit_frac = float(len(disp_los[(disp_los<d) & (disp_los>-d)]))/float(len(disp_los))
    print expfit_frac,'percent of galaxies within ',d
py.show()
