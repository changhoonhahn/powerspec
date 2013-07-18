import numpy as np
import pylab as py

dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
cp_rand_data = np.loadtxt(dir+'cp-rand-testing.dat')
dlos_hist = np.loadtxt(dir+'cmass-dr11v2-N-Anderson-disp_los_hist_normed.dat') 

fig1 = py.figure(1) 
ax11 = fig1.add_subplot(111) 

ax11.scatter(cp_rand_data[:,0], cp_rand_data[:,1], color='k') 
ax11.plot(dlos_hist[:,0],dlos_hist[:,1], color='r')
ax11.set_xlim([0,10]) 

fig2 = py.figure(2)
ax21 = fig2.add_subplot(111)

mpc_bin = 0.1*np.array(range(10001)) 
cp_rand_dlos_hist = ax21.hist( cp_rand_data[:,0], mpc_bin, normed=1 ) 
ax21.plot(dlos_hist[:,0], dlos_hist[:,1], color='r') 

ax21.set_xlim([0,10])
py.show()
