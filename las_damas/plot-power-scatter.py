import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate

dir = '/mount/chichipio2/hahn/power/las_damas/'
truedir='/mount/chichipio2/rs123/MOCKS/LRG21p2_zm_box/gaussian/zspace/stats/'
Lbox=2400.0

Ptot=0.0
P0=[0, 10000, 20000, 30000, 40000]
colors=['k','m','b','g','r']
letters=[ 'a', 'b', 'c', 'd' ]
for i in range(1,41):
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
    for i in range(1,41):
        for letter in letters:
            if i < 10:
                powername='power_sdssmock_gamma_lrgFull_zm_oriana0'+str(i)+letter+'_no.rdcz.datP0'+str(P0[j])
            else:
                powername='power_sdssmock_gamma_lrgFull_zm_oriana'+str(i)+letter+'_no.rdcz.datP0'+str(P0[j])
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
