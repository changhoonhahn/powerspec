import numpy as np
import pylab as py
import math as m
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')
NS='S'
bispec_dir = '/mount/riachuelo1/hahn/bispec/'
bispec_fname = 'bispec-cmass-dr10v8-'+NS+'-ngalsys-360bin-180bin.dat.grid.nmax40.nstep3.P020000.box3600'
power_dir = '/mount/riachuelo1/hahn/power/'
power_fname = 'power-cmass-dr10v8-'+NS+'-Anderson-nzw-zlim-ngalsys-360bin-180bin.dat'

k_fund = (2.0*m.pi)/(3600.0)
bisp_data = np.loadtxt(bispec_dir+bispec_fname)
power_data = np.loadtxt(power_dir+power_fname)

fig0 = plt.figure(1, figsize=(7,8))
ax00 = fig0.add_subplot(111)

fig1 = plt.figure(2, figsize=(15,6))
ax1 = fig1.add_subplot(111)

fig2 = plt.figure(3, figsize=(12,7))
ax20 = fig2.add_subplot(111)

ax00.scatter([k_fund*x for x in bisp_data[:,0]], bisp_data[:,3], label=r'$P(k_{1})$')
ax00.loglog(power_data[:,0],power_data[:,1],'m--',linewidth=2,label=r"$P(k)$ from power code")

ax1.scatter(range(0,len(bisp_data[:,7])), bisp_data[:,7], s=2, label=r'$Q_{123}$')

negQ = bisp_data[:,7] < 0
k1 = (bisp_data[:,0])[negQ]
k2 = (bisp_data[:,1])[negQ]
k3 = (bisp_data[:,2])[negQ]
Q = (bisp_data[:,7])[negQ]

mink = np.zeros(len(k1))
midk = np.zeros(len(k1))
maxk = np.zeros(len(k1))
for i in range(len(k1)):
    mink[i] = min(k1[i], k2[i], k3[i])
    ks = [ k1[i], k2[i], k3[i] ]
    ks.sort()
    midk[i] = ks[1]
    maxk[i] = ks[2]
noise1 = mink < 10
noise2 = mink > 2
min = mink[noise1 & noise2]
mid = midk[noise1 & noise2]
max = maxk[noise1 & noise2]

ax20.scatter(range(0,len(min)), min, c='b',marker='s',label=r"$min(k_1,k_2,k_3)$ for $Q_{123} < 0$")
ax20.scatter(range(0,len(mid)), mid, c='r',marker='^',label=r"$mid(k_1,k_2,k_3)$ for $Q_{123} < 0$")
ax20.scatter(range(0,len(max)), max, c='r',marker='+',label=r"$max(k_1,k_2,k_3)$ for $Q_{123} < 0$")

ax00.set_xlim([10**-3,10**0])
#ax01.set_xlim([10**-3,10**0])
#ax02.set_xlim([10**-3,10**0])
#ax1.set_xlim([0,50000])
ax20.set_xlim([0,25])

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
ax20.legend(loc='upper left')

figdir = '/home/users/hahn/figures/boss/bispectrum/'
fig0.savefig(figdir+'bispec_cmass_dr10v8_'+NS+'_powercheck.png')
fig1.savefig(figdir+'bispec_cmass_dr10v8_'+NS+'_q123.png')
fig2.savefig(figdir+'bispec_cmass_dr10v8_'+NS+'_allk_neg123.png')
#py.show()
