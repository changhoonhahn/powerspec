import numpy as np
import pylab as py
import math as m
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

bispec_dir = '/mount/riachuelo1/hahn/bispec/qpm_mock/'
bispec_fname = 'BISP-a0.6452_0001.dr10_ngc.rdzw.grid360.nmax40.nstep3.P020000.box4000'
power_dir = '/mount/riachuelo1/hahn/power/qpm_mock/'
power_fname = 'power-a0.6452_0001.dr10_ngc.rdzw_weight.grid360.P020000.box4000'

k_fund = (2.0*m.pi)/(4000.0)
bisp_data = np.loadtxt(bispec_dir+bispec_fname)
power_data = np.loadtxt(power_dir+power_fname)

fig0 = plt.figure(1, figsize=(7,8))
ax00 = fig0.add_subplot(111)

fig1 = plt.figure(2, figsize=(15,6))
ax1 = fig1.add_subplot(111)

fig2 = plt.figure(3, figsize=(12,7))
ax20 = fig2.add_subplot(111)

ax00.scatter([k_fund*x for x in bisp_data[:,0]], bisp_data[:,3], label=r'$P(k_{1})$')
ax00.loglog(power_data[:,0],power_data[:,1],'m--',linewidth=2,label=r"$P(k)$ (Option 1)")

ax1.scatter(range(0,len(bisp_data[:,7])), bisp_data[:,7], s=2, label=r'$Q_{123}$')

negQ = bisp_data[:,7] < 0
k1 = (bisp_data[:,0])[negQ]
k2 = (bisp_data[:,1])[negQ]
k3 = (bisp_data[:,2])[negQ]
Q = (bisp_data[:,7])[negQ]

print "Number of triangles with negative Q = ", len(Q)

mink = np.zeros(len(k1))
midk = np.zeros(len(k1))
maxk = np.zeros(len(k1))
for i in range(len(k1)):
    mink[i] = min(k1[i], k2[i], k3[i])
    ks = [ k1[i], k2[i], k3[i] ]
    ks.sort()
    midk[i] = ks[1]
    maxk[i] = ks[2]
#noise1 = mink < 10
#noise2 = mink > 2
#min = mink[noise1 & noise2]
#mid = midk[noise1 & noise2]
#max = maxk[noise1 & noise2]

ax20.scatter(range(0,len(mink)), mink, c='b',marker='s',label=r"$min(k_1,k_2,k_3)$ for $Q_{123} < 0$")
ax20.scatter(range(0,len(midk)), midk, c='r',marker='^',label=r"$mid(k_1,k_2,k_3)$ for $Q_{123} < 0$")
ax20.scatter(range(0,len(maxk)), maxk, c='r',marker='+',label=r"$max(k_1,k_2,k_3)$ for $Q_{123} < 0$")

ax00.set_xlim([10**-3,10**0])
#ax01.set_xlim([10**-3,10**0])
#ax02.set_xlim([10**-3,10**0])
#ax1.set_xlim([0,50000])
ax20.set_xlim([0,10])

ax00.set_ylim([10**3,10**5.2])
#ax01.set_ylim([10**3,10**5.2])
#ax02.set_ylim([10**3,10**5.2])
ax1.set_ylim([-2, 4])

ax00.set_xscale('log')
#ax01.set_xscale('log')
#ax02.set_xscale('log')
ax00.set_yscale('log')
#ax01.set_yscale('log')
#ax02.set_yscale('log')

ax00.set_xlabel(r"$k_{1}$", fontsize=18)
#ax01.set_xlabel(r"$k_{2}$", fontsize=18)
#ax02.set_xlabel(r"$k_{3}$", fontsize=18)
ax1.set_xlabel("Triangles", fontsize=15)
ax20.set_xlabel(r"Triangles with $Q_{123} < 0$", fontsize=15)
ax00.set_ylabel(r"$P(k)$", fontsize=15)
ax1.set_ylabel(r"$Q_{123}$", fontsize=15)
ax20.set_ylabel(r"$min(k_1,k_2,k_3)$", fontsize=15)

ax00.grid(True)
#ax01.grid(True)
#ax02.grid(True)

ax00.legend(loc='best')
#ax01.legend(loc='best')
#ax02.legend(loc='best')
ax20.legend(loc='best')

figdir = '/home/users/hahn/figures/boss/bispectrum/qpm_mock/'

fig0.savefig(figdir+'bispec_qpm_dr10_ngc_0001_powercheck.png')
fig1.savefig(figdir+'bispec_qpm_dr10_ngc_0001_q123.png')
fig2.savefig(figdir+'bispec_qpm_dr10_ngc_0001_allk_negq123.png')
py.show()
