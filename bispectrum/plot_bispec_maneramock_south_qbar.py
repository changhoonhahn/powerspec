import numpy as np
import pylab as py
import math as m
import matplotlib.pyplot as plt
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

bispec_dir = '/mount/riachuelo1/hahn/bispec/manera_mock/v5p2/'
bispec_fname0 = 'BISPcmass_dr10_south_ir4'
bispec_fname1 = '.v5.2.wghtv.txt.grid360.nmax40.nstep3.P020000.box3600'

for i in range(1,601):
    if i < 10:
        bisp_name = bispec_fname0+'00'+str(i)+bispec_fname1
    elif i < 100:
        bisp_name = bispec_fname0+'0'+str(i)+bispec_fname1
    else:
        bisp_name = bispec_fname0+str(i)+bispec_fname1

    bisp_data = np.loadtxt(bispec_dir+bisp_name)

    if i == 1:
        Q_comb = bisp_data[:,7]
        Q_kmax = bisp_data[:,0]
    else:
        Q_comb = Q_comb + bisp_data[:,7]
print i
Q_avg = Q_comb / float(i)

Q_scat = np.zeros( [len(Q_avg)] )
for i in range(1,601):
    if i < 10:
        bisp_name = bispec_fname0+'00'+str(i)+bispec_fname1
    elif i < 100:
        bisp_name = bispec_fname0+'0'+str(i)+bispec_fname1
    else:
        bisp_name = bispec_fname0+str(i)+bispec_fname1
    bisp_data = np.loadtxt(bispec_dir+bisp_name)

    Q_diff = [ ( bisp_data[j,7] - Q_avg[j] )**2 for j in range(len(Q_avg)) ]
    Q_scat = Q_scat + Q_diff

Q_scatter = np.sqrt( Q_scat/float(i) )/Q_avg

bispec_cmass_S = np.loadtxt('/mount/riachuelo1/hahn/bispec/bispec-cmass-dr10v8-S-ngalsys-360bin-180bin.dat.grid.nmax40.nstep3.P020000.box3600')
boss_mock = bispec_cmass_S[:,7]/Q_avg

uniq_kmax = np.unique(Q_kmax)
Q_SN = []
for i in range(len(uniq_kmax)):
    Q_i = Q_avg[ Q_kmax <= uniq_kmax[i] ]
    delQ_i = Q_scatter[ Q_kmax <= uniq_kmax[i] ]

    Q_sum = 0.0
    for ii in range(len(Q_i)):
        Q_sum = Q_sum + ( Q_i[ii] / delQ_i[ii] )**2
    Q_SN.append( np.sqrt(Q_sum) )


###Figures:
fig1 = plt.figure(1, figsize=(15,6))
ax10 = fig1.add_subplot(111)
ax10.scatter(range(0,len(Q_avg)), Q_avg, s = 2, label = r'$\overline{Q_123}$ for Manera Mock v5p2 South')
ax10.set_xlim([0,6500])
ax10.set_ylim([-2, 4])
ax10.set_xlabel("Triangles", fontsize=15)
ax10.set_ylabel(r"$\overline{Q_{123}}$", fontsize=20)
ax10.legend(loc='best')

fig2 = plt.figure(2, figsize = (15,6) )
ax20 = fig2.add_subplot(111)
ax20.scatter( range( 0, len(Q_avg) ), Q_scatter, s=2, label = r'$\frac{\Delta Q}{\overline{Q}}$ for Manera mock v5p2 South' )
ax20.set_xlim([0,6500])
ax20.set_ylim([-2, 4])
ax20.set_xlabel("Triangles", fontsize=15)
ax20.set_ylabel(r"$\frac{\Delta Q_{123}}{\overline{Q_{123}}}$", fontsize=25)
ax20.legend(loc='best')

fig3 = plt.figure(3, figsize = (30,6) )
ax30 = fig3.add_subplot(111)
#ax30.scatter( range( 0, len(boss_mock) ), boss_mock, s=3, label = r'S\frac{Q_{BOSS}}{\overline{Q_{mock}}}$' )
ax30.errorbar( range( 0, len(boss_mock) ), boss_mock, yerr=Q_scatter, fmt='ko' )
ax30.set_xlim([0,6500])
#ax30.set_ylim([0.5,2])
ax30.set_xlabel("Triangles", fontsize = 15 )
ax30.set_ylabel(r'$\frac{Q_{BOSS}}{\overline{Q_{mock}}}$', fontsize=25)
ax30.legend(loc='best')

fig4 = plt.figure(4, figsize = (15,6))
ax40 = fig4.add_subplot(111)
ax40.scatter( range( 0, len(bispec_cmass_N[:,7]) ), bispec_cmass_N[:,7], s=7, c='k', label=r"$Q_{123,dr10v8-S}$" )
#ax40.scatter( range( 0, len(bispec_cmass_full[:,7]) ), bispec_cmass_full[:,7], s=7, c='g', label=r"$Q_{123,dr10v8-full}$" )
ax40.scatter( range( 0, len(Q_avg) ), Q_avg, s=7, c='r', label=r"$\overline{Q_{123,Mock-v5p2-S}}$" )
ax40.set_xlim([0,6500])
ax40.set_xlabel('Triangles', fontsize = 15 )
ax40.set_ylabel(r"$Q_{123}$", fontsize = 25 )
ax40.legend(loc='best')

kfund = 2.0*np.pi/(3600.0)
fig5 = plt.figure(5, figsize = (8,8))
ax50 = fig5.add_subplot(111)
ax50.loglog( kfund*uniq_kmax, Q_SN ,label=r'S/N(k) for $Q_{123}$ of 600 Manera Mocks v5p2 South')
ax50.set_xlim([10**-3,10**0])
ax50.set_xlabel(r'k',fontsize=25)
ax50.set_ylabel('S/N', fontsize=25)
ax50.legend(loc='best')



#py.show()
