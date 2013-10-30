import numpy as np
import pylab as py
import sys
from scipy.integrate import simps
from scipy import integrate
from scipy.optimize import curve_fit
from matplotlib import rc

dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'

fig4 = py.figure(4)
dump = fig4.add_subplot(111)
mpc_bin = -1000.0+0.1*np.array(range(20001))

def expon(x,sig,A):
    return A*np.exp(-np.absolute(x)/sig)/(2.0*sig)
    
disp_los    = np.loadtxt(dir+'cmass-dr11v2-N-Anderson_dlos.dat')

hist_disp_los   = dump.hist(disp_los,mpc_bin)
disp_los_x      = [ (hist_disp_los[1][i] + hist_disp_los[1][i+1])/2.0 for i in range(len(hist_disp_los[1])-1) ]

popt, pcov = curve_fit(expon,np.array(disp_los_x[10000:10300]),hist_disp_los[0][10000:10300],p0=[0.4,np.max(hist_disp_los[0])])
print popt[0]
