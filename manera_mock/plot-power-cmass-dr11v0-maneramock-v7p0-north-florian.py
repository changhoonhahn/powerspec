import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'

colors=['k','m','b','g','r']

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax12 = fig1.add_subplot(122)

for i in range(1,601):
    if i < 10:
        mockname='power_cmass_dr11_north_ir400'+str(i)+'.v7.0.wghtv.txt_wboss_florian.grid360.P020000.box3600'
    elif i < 100:
        mockname='power_cmass_dr11_north_ir40'+str(i)+'.v7.0.wghtv.txt_wboss_florian.grid360.P020000.box3600'
    else:
        mockname='power_cmass_dr11_north_ir4'+str(i)+'.v7.0.wghtv.txt_wboss_florian.grid360.P020000.box3600'

    mock = np.loadtxt(dir+mockname)
    if i == 1:
        mocktot = mock[:,1]
        mock_k = mock[:,0]
    else:
        mocktot = mocktot + mock[:,1]
print i
mockavg = np.array([ mocktot[x]/float(i) for x in range(len(mocktot)) ])
ax11.loglog( mock_k, mockavg, color='k', linewidth=2, label=r"$\overline{P_{mock}}$ for 600 Manera Mocks v7.0 North")

mockscat = np.zeros( [len(mockavg)] )
for ii in range(1,601):
    if ii < 10:
        mockname='power_cmass_dr11_north_ir400'+str(ii)+'.v7.0.wghtv.txt_wboss_florian.grid360.P020000.box3600'
    elif ii < 100:
        mockname='power_cmass_dr11_north_ir40'+str(ii)+'.v7.0.wghtv.txt_wboss_florian.grid360.P020000.box3600'
    else:
        mockname='power_cmass_dr11_north_ir4'+str(ii)+'.v7.0.wghtv.txt_wboss_florian.grid360.P020000.box3600'

    mock = np.loadtxt(dir+mockname)
    mockdiff = [(mock[x,1]-mockavg[x])**2 for x in range(len(mock[:,1]))]

    mockscat = mockscat + mockdiff
print ii
mock_scat = np.sqrt( mockscat/float(ii) )/mockavg
mock_del = np.sqrt( mockscat/float(ii) )

ax12.loglog( mock_k, mock_scat, color='k',linewidth=2, label=r"$\Delta P/\bar{P}$ for 600 Manera Mocks v7.0 North" )
#ax11.errorbar( mock_k, mockavg, yerr=mock_scat*mockavg, fmt='ko') 

power_cmass_dr11v0_north = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v0-N-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
power_cmass_dr11v1_north = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v1-N-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
power_cmass_dr11v2_north = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v2-N-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')

cmass_mock_ratio = [ power_cmass_dr11v0_north[x,1]/mockavg[x] for x in range(len(mockavg)) ]

SN = []
for k in range(len(mockavg)):
    P_delP = 0.0
    for kk in range(0,k+1):
        P_delP = P_delP + (mockavg[kk]/mock_del[kk])**2
    SN.append(np.sqrt(P_delP))

fig2 = plt.figure(2, figsize=(14,8))
ax20 = fig2.add_subplot(111)
ax20.plot( power_cmass_dr11v0_north[:,0], cmass_mock_ratio, 'k--', linewidth=2, label=r"$\frac{P_{DR11v0-N}}{P_{v7.0-N}}$" )
ax20.errorbar( power_cmass_dr11v0_north[:,0], cmass_mock_ratio, yerr=mock_scat, fmt='k.' )

fig3 = plt.figure(3, figsize=(7,8))
ax30 = fig3.add_subplot(111)
ax30.loglog( power_cmass_dr11v0_north[:,0], power_cmass_dr11v0_north[:,1], color='b', linewidth=2, label="P(k) CMASS DR11v0 North" )
ax30.loglog( mock_k, mockavg, color='r', linewidth=2, label="Average P(k) for 600 Manera Mocks v7.0 North" )

fig4 = plt.figure(4, figsize=(8,8))
ax40 = fig4.add_subplot(111)
ax40.loglog( power_cmass_dr11v0_north[:,0], SN, linewidth=2, label="S/N(k) for P(k) North" )

fig5 = plt.figure(5, figsize=(8,7)) 
ax50 = fig5.add_subplot(111)
ax50.scatter( power_cmass_dr11v0_north[:,0], power_cmass_dr11v0_north[:,1], color='k', label='P(k) CMASS DR11v0 North') 
ax50.errorbar( power_cmass_dr11v0_north[:,0], power_cmass_dr11v0_north[:,1], yerr=mock_scat*mockavg, fmt='ko', capsize=5, elinewidth=3) 
ax50.scatter( power_cmass_dr11v1_north[:,0], power_cmass_dr11v1_north[:,1], color='r', label='P(k) CMASS DR11v1 North') 
ax50.errorbar( power_cmass_dr11v1_north[:,0], power_cmass_dr11v1_north[:,1], yerr=mock_scat*mockavg, fmt='ro', capsize=5, elinewidth=3) 
ax50.scatter( power_cmass_dr11v2_north[:,0], power_cmass_dr11v2_north[:,1], color='m', label='P(k) CMASS DR11v2 North') 
ax50.errorbar( power_cmass_dr11v2_north[:,0], power_cmass_dr11v2_north[:,1], yerr=mock_scat*mockavg, fmt='mo', capsize=5, elinewidth=3) 

ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**3,10**5.2])
ax11.set_xlabel('k',fontsize=15)
ax11.set_ylabel('P(k)',fontsize=15)
ax11.legend(loc='best',prop={'size':12})
ax11.grid(True)

ax12.set_xlim([10**-3,10**0])
ax12.set_ylim([10**-2,10**0.5])
ax12.set_xlabel('k',fontsize=15)
ax12.set_ylabel(r"$\frac{\Delta P}{P}$", fontsize=18)
ax12.legend(loc='best',prop={'size':12})
ax12.grid(True)

ax20.set_xlim([10**-3,10**0])
ax20.set_ylim([0.0,4.5])
ax20.set_xlabel('k', fontsize=25)
ax20.set_ylabel(r"$\frac{P_{BOSS}}{P_{MOCK}}$", fontsize=25)
ax20.legend(loc='best', prop={'size':25})
ax20.set_xscale('log')
ax20.grid(True)

ax30.set_xlim([10**-3,10**0])
ax30.set_ylim([10**3,10**5.2])
ax30.set_xlabel('k',fontsize=15)
ax30.set_ylabel('P(k)',fontsize=15)
ax30.legend(loc='best',prop={'size':15})
ax30.grid(True)

ax40.set_xlim([10**-3,10**0])
ax40.set_ylim([10**-0.5,10**3])
ax40.set_xlabel('k',fontsize=20)
ax40.set_ylabel('S/N',fontsize=20)
ax40.legend(loc='best',prop={'size':15})
ax40.grid(True)

ax50.set_yscale('log')
ax50.set_xlim([0.0,0.2])
ax50.set_ylim([10**3,10**5.2])
ax50.set_xlabel('k',fontsize=20)
ax50.set_ylabel('P(k)',fontsize=20)
lg = ax50.legend(loc='best',prop={'size':20})
lg.get_frame().set_linewidth(0)
ax50.grid(True)
ax50.tick_params(labelsize=15)
py.show()
