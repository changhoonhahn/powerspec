import numpy as np
import pylab as py
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

riadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
prismdir = '/global/data/scr/chh327/powercode/data/'
cp_rand_data = np.loadtxt(riadir+'cp-rand-testing-pm.dat')
#cp_rand_data = np.loadtxt(riadir+'cp-rand-testing.dat')
#dlos_hist_pthalo = np.loadtxt(prismdir+'pthalo-ir4211-dr11-v7p0-N-disp_los_hist_normed.dat')
dlos_hist_pthalo = np.loadtxt(prismdir+'pthalo-ir4211-dr11-v7p0-N-disp_los_hist_pm_normed.dat')
#dlos_hist_cmass = np.loadtxt(prismdir+'cmass-dr11v2-N-Anderson-disp_los_hist_normed.dat') 
dlos_hist_cmass = np.loadtxt(prismdir+'cmass-dr11v2-N-Anderson-disp_los_hist_normed-pm.dat') 

fig1 = py.figure(1) 
ax11 = fig1.add_subplot(111) 

ax11.scatter(cp_rand_data[:,0], cp_rand_data[:,1], color='k') 
ax11.plot(dlos_hist_pthalo[:,0],dlos_hist_pthalo[:,1], color='r')
ax11.set_xlim([-10,10])
#ax11.set_xlim([0,10])

fig2 = py.figure(2)
ax21 = fig2.add_subplot(111)

mpc_bin = -1000.0+0.1*np.array(range(20001)) 
#mpc_bin = 0.1*np.array(range(10001)) 
#cp_rand_dlos_hist = ax21.hist( cp_rand_data[:,0], mpc_bin, normed=1 ) 
ax21.plot(dlos_hist_pthalo[:,0], dlos_hist_pthalo[:,1], color='b', linewidth=3, label='Noramlized $d_{LOS}$ Distribution for PTHalo') 
ax21.plot(dlos_hist_cmass[:,0], dlos_hist_cmass[:,1], color='r', linewidth=3, label='Normalized $d_{LOS}$ Distribution for CMASS') 
ax21.set_xlim([-25,25])
#ax21.set_xlim([0,25])
ax21.set_ylim([0.0,1.0])
ax21.legend(loc='best')
ax21.set_xlabel('d (Mpc)') 
py.show()
