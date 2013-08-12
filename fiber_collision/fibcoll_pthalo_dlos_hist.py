import numpy as np
import pylab as py
from scipy.integrate import simps
from scipy.optimize import curve_fit
from matplotlib import rc
import sys

rc('text', usetex=True)
rc('font', family='serif')

n = '{0:03}'.format(int(sys.argv[1]))
prismdir = '/global/data/scr/chh327/powercode/data/'
riadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
disp_los = np.loadtxt(riadir+'cmass_dr11_north_ir4'+str(n)+'v7.0_disp_los_pm.dat')
data = np.loadtxt(riadir+'cmass_dr11_north_ir4'+str(n)+'.v7.0.wghtv.txt')

mpc_bin = -1000.0+0.1*np.array(range(20001))

fig4 = py.figure(4)
dump = fig4.add_subplot(111)

fig1 = py.figure(1)
ax1 = fig1.add_subplot(111)

fig2 = py.figure(2)
ax2 = fig2.add_subplot(111)

hist_disp_los = dump.hist(disp_los,mpc_bin, label='Line of Sight Displacement Histogram')
disp_los_x = [ (hist_disp_los[1][i] + hist_disp_los[1][i+1])/2.0 for i in range(len(hist_disp_los[1])-1) ]

def expon(x,sig): 
    return np.max(hist_disp_los[0])*np.exp(-x/sig)

popt, pcov = curve_fit(expon, np.array(disp_los_x[10000:10100]), hist_disp_los[0][10000:10100])
print popt

ax1.plot(disp_los_x, hist_disp_los[0], linewidth=3, label=r'Histogram of $d_{LOS}$')
ax1.plot(disp_los_x[10000:10100], expon(np.array(disp_los_x[10000:10100]), popt[0]), 'r', linewidth=3, label=r'Exponential distribution with $\sigma=$'+str(popt))
ax1.set_xlim([0,10])
ax1.set_xlabel('Displacement (Mpc)')
ax1.set_ylabel('Number of Galaxies')
ax1.legend(loc='best')

# Writing the normalized histogram to file
hist_disp_los_normed = dump.hist( disp_los, mpc_bin, normed=1 ) 
output = np.zeros(2*len(disp_los_x)).reshape((len(disp_los_x),2))
output[:,0] = disp_los_x
output[:,1] = hist_disp_los_normed[0]

ax2.plot(output[:,0],output[:,1])
ax2.set_ylim([0,1.2]) 
ax2.set_xlim([0,20])
np.savetxt(riadir+'pthalo-ir4'+str(n)+'-dr11-v7p0-N-disp_los_hist_pm_normed.dat', output)
print riadir+'pthalo-ir4'+str(n)+'-dr11-v7p0-N-disp_los_hist_pm_normed.dat'

exit()
