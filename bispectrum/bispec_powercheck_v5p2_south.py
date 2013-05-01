import numpy as np
import pylab as py
import math as m
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/bispec/manera_mock/v5p2/'
fname = 'BISPcmass_dr10_south_ir4001.v5.2.wghtv.txt.grid480.P020000.box4000'

k_fund = (2*m.pi)/(4000.0)
bisp_data = np.loadtxt(dir+fname)

fig0 = plt.figure(1, figsize=(21,8))
ax00 = fig0.add_subplot(131)
ax01 = fig0.add_subplot(132)
ax02 = fig0.add_subplot(133)

fig1 = plt.figure(2, figsize=(10,8))
ax1 = fig1.add_subplot(111)

ax00.scatter([k_fund*x for x in bisp_data[:,0]], bisp_data[:,3], label=r'$P(k_{1})$')
ax01.scatter([k_fund*x for x in bisp_data[:,1]], bisp_data[:,4], label=r'$P(k_{2})$')
ax02.scatter([k_fund*x for x in bisp_data[:,2]], bisp_data[:,5], label=r'$P(k_{3})$')

ax1.scatter(range(0,len(bisp_data[:,7])), bisp_data[:,7], label=r'$Q_{123}$')

ax00.set_xlim([10**-3,10**0])
ax01.set_xlim([10**-3,10**0])
ax02.set_xlim([10**-3,10**0])

ax00.set_ylim([10**3,10**5.2])
ax01.set_ylim([10**3,10**5.2])
ax02.set_ylim([10**3,10**5.2])

ax00.set_xscale('log')
ax01.set_xscale('log')
ax02.set_xscale('log')
ax00.set_yscale('log')
ax01.set_yscale('log')
ax02.set_yscale('log')

ax00.set_xlabel(r"$k_{1}$", fontsize=15)
ax01.set_xlabel(r"$k_{2}$", fontsize=15)
ax02.set_xlabel(r"$k_{3}$", fontsize=15)
ax00.set_ylabel(r"$P(k)$", fontsize=15)
ax1.set_ylabel(r"$Q_{123}$", fontsize=15)

ax00.grid(True)
ax01.grid(True)
ax02.grid(True)

py.legend(loc='best')
py.show()
