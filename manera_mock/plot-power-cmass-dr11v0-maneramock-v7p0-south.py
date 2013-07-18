import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/v5p2/'

colors=['k','m','b','g','r']

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax12 = fig1.add_subplot(122)

for i in range(1,601):
    if i < 10:
        mockname='power_cmass_dr10_south_ir400'+str(i)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'
    elif i < 100:
        mockname='power_cmass_dr10_south_ir40'+str(i)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'
    else:
        mockname='power_cmass_dr10_south_ir4'+str(i)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'

    mock = np.loadtxt(dir+mockname)
    if i == 1:
        mocktot = mock[:,1]
        mock_k = mock[:,0]
    else:
        mocktot = mocktot + mock[:,1]
print i
mockavg = np.array([ mocktot[x]/float(i) for x in range(len(mocktot)) ])
ax11.loglog( mock_k, mockavg, color='k', linewidth=2, label=r"$\overline{P_{mock}}$ for 600 Manera Mocks v5p2 South")

mockscat = np.zeros( [len(mockavg)] )
for ii in range(1,601):
    if ii < 10:
        mockname='power_cmass_dr10_south_ir400'+str(ii)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'
    elif ii < 100:
        mockname='power_cmass_dr10_south_ir40'+str(ii)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'
    else:
        mockname='power_cmass_dr10_south_ir4'+str(ii)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'

    mock = np.loadtxt(dir+mockname)
    mockdiff = [(mock[x,1]-mockavg[x])**2 for x in range(len(mock[:,1]))]

    mockscat = mockscat + mockdiff
print ii
mock_scat = np.sqrt( mockscat/float(ii) )/mockavg
mock_del = np.sqrt( mockscat/float(ii) )
#[ np.sqrt( mockscat[x]/float(ii) ) for x in range(len(mockavg)) ]
ax12.loglog( mock_k, mock_scat, color='k',linewidth=2, label=r"$\Delta P/\bar{P}$ for 600 Manera Mocks v5p2 South" )

power_cmass_dr10v8_south = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr10v8-S-Anderson-nzw-zlim-ngalsys-360bin-180bin.dat')

cmass_mock_ratio = [ power_cmass_dr10v8_south[x,1]/mockavg[x] for x in range(len(mockavg)) ]

SN = []
for k in range(len(mockavg)):
    P_delP = 0.0
    for kk in range(0,k+1):
        P_delP = P_delP + (mockavg[kk]/mock_del[kk])**2
    SN.append(np.sqrt(P_delP))
"""
def delP_P(k):
    kfund = 2.0*np.pi/(3600.0)
    step = 1.0
    return np.sqrt(1.0/(2*np.pi*(k/kfund)**2*step))

delP_P_arr = np.array( [ 1.0/delP_P(power_cmass_dr10v8_north[x,0]) for x in range(len(power_cmass_dr10v8_north[:,0])) ] )
"""
fig2 = plt.figure(2, figsize=(14,8))
ax20 = fig2.add_subplot(111)
ax20.plot( power_cmass_dr10v8_south[:,0], cmass_mock_ratio, 'k--', linewidth=2, label=r"$\frac{P_{DR10v8-S}}{P_{v5p2-S}}$" )
ax20.errorbar( power_cmass_dr10v8_south[:,0], cmass_mock_ratio, yerr=mock_scat, fmt='k.' )

fig3 = plt.figure(3, figsize=(7,8))
ax30 = fig3.add_subplot(111)
ax30.loglog( power_cmass_dr10v8_south[:,0], power_cmass_dr10v8_south[:,1], color='b', linewidth=2, label="P(k) CMASS DR10v8 South" )
ax30.loglog( mock_k, mockavg, color='r', linewidth=2, label="Average P(k) for 600 Manera Mocks v5p2 South" )

fig4 = plt.figure(4, figsize=(8,8))
ax40 = fig4.add_subplot(111)
ax40.loglog( power_cmass_dr10v8_south[:,0], SN, linewidth=2, label="S/N(k) for P(k) South" )

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
py.show()
