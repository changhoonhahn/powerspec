import numpy as np
import pylab as py

r1 = np.loadtxt('tailnbar_r1_test.dat')
r2 = np.loadtxt('tailnbar_r2_test.dat')
nbarnormed = np.loadtxt('/mount/riachuelo1/hahn/data/manera_mock/dr11/nbar-normed-cmass_dr11_north_ir4001.v7.0.peakcorr.txt')
fig1 = py.figure(1)
ax11 = fig1.add_subplot(111)

z_bin = 0.0+0.005*np.array(range(201))
tail_hist_r1 = ax11.hist(r1,z_bin,normed=1)
tail_hist_r2 = ax11.hist(r2,z_bin,normed=1)
ax11.plot(nbarnormed[:,0],200.0*nbarnormed[:,3],'r')
py.show()
