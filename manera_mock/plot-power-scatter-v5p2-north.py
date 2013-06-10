import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/chichipio2/hahn/power/manera_mock/v5p2/'

Ptot=0.0
P0=[0, 10000, 20000, 30000, 40000]
colors=['k','m','b','g','r']

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax12 = fig1.add_subplot(122)
for j in range(len(P0)):
    opt2tot=np.zeros([120])
    opt2scat=np.zeros([120])

    n = 0
    for i in range(1,101):
        if i < 10:
            opt2name='power_cmass_dr10_north_ir400'+str(i)+'.v5.2.wghtv.txt_now.grid240.P0'+str(P0[j])+'.box4800'
        elif i < 100:
            opt2name='power_cmass_dr10_north_ir40'+str(i)+'.v5.2.wghtv.txt_now.grid240.P0'+str(P0[j])+'.box4800'
        else:
            opt2name='power_cmass_dr10_north_ir4'+str(i)+'.v5.2.wghtv.txt_now.grid240.P0'+str(P0[j])+'.box4800'

        opt2 = np.loadtxt(dir+opt2name)
        opt2tot = opt2tot + opt2[:,1]
        n=n+1
#        ax11.loglog( opt2[:,0], opt2[:,1], colors[j]+'--', linewidth=1)
    opt2avg = opt2tot/float(n)
    ax11.loglog( opt2[:,0], opt2avg, color=colors[j], linewidth=2, label="P0="+str(P0[j])+" Option 2")

    for ii in range(1,101):
        if ii < 10:
            opt2name='power_cmass_dr10_north_ir400'+str(ii)+'.v5.2.wghtv.txt_now.grid240.P0'+str(P0[j])+'.box4800'
        elif ii < 100:
            opt2name='power_cmass_dr10_north_ir40'+str(ii)+'.v5.2.wghtv.txt_now.grid240.P0'+str(P0[j])+'.box4800'
        else:
            opt2name='power_cmass_dr10_north_ir4'+str(ii)+'.v5.2.wghtv.txt_now.grid240.P0'+str(P0[j])+'.box4800'
        opt2 = np.loadtxt(dir+opt2name)
        opt2diff = [(opt2[x,1]-opt2avg[x])**2 for x in range(len(opt2))]
        opt2scat = opt2scat + opt2diff
    opt2scat = np.sqrt(opt2scat/float(n))/opt2avg
    ax12.loglog(opt2[:,0], opt2scat, color=colors[j],linewidth=2, label="P0="+str(P0[j])+" Option 2")

ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**3,10**5.2])
ax11.set_xlabel('k',fontsize=15)
ax11.set_ylabel('P(k)',fontsize=15)
ax11.legend(loc='best',prop={'size':12})
ax11.grid(True)

ax12.set_xlim([10**-3,10**0])
ax12.set_xlabel('k',fontsize=15)
ax12.set_ylabel(r"$\frac{\Delta P}{P}$", fontsize=18)
ax12.legend(loc='best',prop={'size':12})
ax12.grid(True)

py.show()
"""for i in range(1,41):
    if i < 10:
        ngal=np.loadtxt(truedir+'power_mock_gamma_lrg21p2_zmo_Oriana_100'+str(i)+'_z0p342_fof_b0p2.zdist.dat')[0]
        data=np.loadtxt(truedir+'power_mock_gamma_lrg21p2_zmo_Oriana_100'+str(i)+'_z0p342_fof_b0p2.zdist.dat',skiprows=1)
    else:
        ngal=np.loadtxt(truedir+'power_mock_gamma_lrg21p2_zmo_Oriana_10'+str(i)+'_z0p342_fof_b0p2.zdist.dat')[0]
        data=np.loadtxt(truedir+'power_mock_gamma_lrg21p2_zmo_Oriana_10'+str(i)+'_z0p342_fof_b0p2.zdist.dat',skiprows=1)

    Pshot=(Lbox)**3.0/(float(ngal)*(2.0*np.pi)**3.0)
    Pcorr=data[:,1]-Pshot
    k=data[:,0]

    Ptot=Ptot+Pcorr

print np.mean(Ptot), np.mean(k)
Pavg=(2*np.pi)**3*Ptot/40.0

py.figure(figsize=(8,8))
for j in range(len(P0)):
    sqr=0.0
    for i in range(1,601):
        if i < 10:
            powername='power_cmass_dr10_north_ir400'+str(i)+'.v5.1.wght.txtP0'+str(P0[j])
        elif i < 100:
            powername='power_cmass_dr10_north_ir40'+str(i)+'.v5.1.wght.txtP0'+str(P0[j])
        else:
            powername='power_cmass_dr10_north_ir4'+str(i)+'.v5.1.wght.txtP0'+str(P0[j])
        data=np.loadtxt(dir+powername)
        Pi=interpolate.interp1d(data[:,0],data[:,1],kind='quadratic')(k)

        sqr=sqr+(Pi-Pavg)**2
    scat = np.sqrt(sqr/(160.0*Pavg**2))
    plt.plot(np.log10(k), scat, c=colors[j],label='P_0='+str(P0[j]))
    py.xlim([-2.3,0.0])
    py.xlabel('k', fontsize=15)
    py.ylabel('delta(P(k))/P(k)', fontsize=15)
    plt.grid(True)
    py.legend(loc='upper right', prop={'size':12})
py.show()
"""
