import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
from scipy.integrate import simps
rc('text', usetex=True)
rc('font', family='serif')

dr10dir = '/mount/riachuelo1/hahn/power/manera_mock/v5p2/'
dr11dir = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax12 = fig1.add_subplot(122)

fig2 = plt.figure(2, figsize=(7,8))
ax21 = fig2.add_subplot(111)

fig3 = plt.figure(3, figsize=(10,10))
ax31 = fig3.add_subplot(111)

delP_tot = []
for i in range(1,601):
    if i < 10:
        mockname_dr10 ='power_cmass_dr10_south_ir400'+str(i)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'
        mockname_dr11 ='power_cmass_dr11_south_ir400'+str(i)+'.v7.0.wghtv.txt_wboss.grid360.P020000.box3600'
    elif i < 100:
        mockname_dr10 ='power_cmass_dr10_south_ir40'+str(i)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'
        mockname_dr11 ='power_cmass_dr11_south_ir40'+str(i)+'.v7.0.wghtv.txt_wboss.grid360.P020000.box3600'
    else:
        mockname_dr10 ='power_cmass_dr10_south_ir4'+str(i)+'.v5.2.wghtv.txt_wboss.grid360.P020000.box3600'
        mockname_dr11 ='power_cmass_dr11_south_ir4'+str(i)+'.v7.0.wghtv.txt_wboss.grid360.P020000.box3600'

    mock_dr10 = np.loadtxt(dr10dir+mockname_dr10)
    mock_dr11 = np.loadtxt(dr11dir+mockname_dr11)
    mock_dr10dr11_diff = mock_dr11[:,1] - mock_dr10[:,1]

    if i == 1:
        mocktot_dr10 = mock_dr10[:,1]
        mocktot_dr11 = mock_dr11[:,1]
        mocktot_dr10dr11_diff = mock_dr10dr11_diff
        mock_k = mock_dr10[:,0]
    else:
        mocktot_dr10 = mocktot_dr10 + mock_dr10[:,1]
        mocktot_dr11 = mocktot_dr11 + mock_dr11[:,1]
        mocktot_dr10dr11_diff = mocktot_dr10dr11_diff + mock_dr10dr11_diff
    ax21.scatter( mock_k, mock_dr10dr11_diff, marker='x' )
    mock_dr10dr11_diff_ranged = mock_dr10dr11_diff[ (mock_k > 0.01) & (mock_k < 0.1) ]
    mock_k_ranged = mock_k[ (mock_k > 0.01) & (mock_k < 0.1) ]
    delP_tot.append( simps(mock_dr10dr11_diff_ranged, mock_k_ranged) )
#    delP_tot.append(np.sum(mock_dr10dr11_diff_ranged))

print i
mockavg_dr10 = np.array([ mocktot_dr10[x]/float(i) for x in range(len(mocktot_dr10)) ])
mockavg_dr11 = np.array([ mocktot_dr11[x]/float(i) for x in range(len(mocktot_dr11)) ])
mockavg_dr10dr11_diff = mocktot_dr10dr11_diff/float(i)
ax11.loglog( mock_k, mockavg_dr10, color='b', linewidth=2, label=r"$\overline{P_{mock}}$ for 600 PTHalo Mocks DR10 v5.2 South")
ax11.loglog( mock_k, mockavg_dr11, color='r', linewidth=2, label=r"$\overline{P_{mock}}$ for 600 PTHalo Mocks DR11 v7.0 South")

power_cmass_dr10v8_south = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr10v8-S-Anderson-nzw-zlim-ngalsys-360bin-180bin.dat')
power_cmass_dr11v0_south = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v0-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
power_cmass_dr11v1_south = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v1-S-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')

ax11.loglog( power_cmass_dr10v8_south[:,0], power_cmass_dr10v8_south[:,1], 'b--', linewidth=1, label='P(k) for CMASS DR10v8 South')
ax11.loglog( power_cmass_dr11v0_south[:,0], power_cmass_dr11v0_south[:,1], 'r--', linewidth=1, label='P(k) for CMASS DR11v0 South')
ax12.loglog( power_cmass_dr10v8_south[:,0], power_cmass_dr10v8_south[:,1], color='b', linewidth=2, label='P(k) for CMASS DR10v8 South')
ax12.loglog( power_cmass_dr11v0_south[:,0], power_cmass_dr11v0_south[:,1], color='r', linewidth=2, label='P(k) for CMASS DR11v0 South')

ax21.plot( mock_k, mockavg_dr10dr11_diff, 'k', linewidth=3, label=r"$\overline{P_{dr11} - P_{dr10}}$ for 600 PTHalo Mocks South" )

data_dr11v0_k = power_cmass_dr11v0_south[:,0]
data_dr10dr11v0_diff = power_cmass_dr11v0_south[:,1] - power_cmass_dr10v8_south[:,1]
data_dr10dr11v0_diff_ranged = data_dr10dr11v0_diff[ (data_dr11v0_k > 0.01) & (data_dr11v0_k < 0.1) ]
data_dr11v0_k_ranged = data_dr11v0_k[ (data_dr11v0_k > 0.01) & (data_dr11v0_k < 0.1) ]
data_dr11v0_delP_tot = simps(data_dr10dr11v0_diff_ranged, data_dr11v0_k_ranged)
#data_delP_tot = np.sum(data_dr10dr11_diff_ranged)

data_dr11v1_k = power_cmass_dr11v1_south[:,0]
data_dr10dr11v1_diff = power_cmass_dr11v1_south[:,1] - power_cmass_dr10v8_south[:,1]
data_dr10dr11v1_diff_ranged = data_dr10dr11v1_diff[ (data_dr11v1_k > 0.01) & (data_dr11v1_k < 0.1) ]
data_dr11v1_k_ranged = data_dr11v1_k[ (data_dr11v1_k > 0.01) & (data_dr11v1_k < 0.1) ]
data_dr11v1_delP_tot = simps(data_dr10dr11v1_diff_ranged, data_dr11v1_k_ranged)

print data_dr11v0_delP_tot, data_dr11v1_delP_tot
print 'Number of mocks with int_Del_P > DR11v0:', len(delP_tot[ delP_tot > data_dr11v0_delP_tot ])
print 'Number of mocks with int_Del_P > DR11v1:', len(delP_tot[ delP_tot > data_dr11v1_delP_tot ])


delP_tot_hist = ax31.hist( delP_tot, bins=20, label=r'Distribution of $\int_{k=0.01}^{0.1} P_{dr11} - P_{dr10}$ for 600 PTHalo Mocks SGC')
#ax31.vlines(data_delP_tot, 0, 100, color='r', linestyles='solid', linewidth=5, label=r'$\int_{k=0.01}^{0.1} P_{dr11} - P_{dr10}=$'+str(data_delP_tot)+' for CMASS data')
#ax31.arrow(data_dr11v0_delP_tot, 10.0, 0.0, -5.0, fc='k', ec='k', head_width=20.0, head_length=5.0, label=r'$\int_{k=0.01}^{0.1} P_{dr11v0} - P_{dr10v8}=$'+  str(data_dr11v0_delP_tot)+' for CMASS data')
#ax31.arrow(data_dr11v1_delP_tot, 10.0, 0.0, -5.0, fc='m', ec='m', head_width=20.0, head_length=5.0, label=r'$\int_{k=0.01}^{0.1} P_{dr11v1} - P_{dr10v8}=$'+  str(data_dr11v1_delP_tot)+' for CMASS data')
print 'Maximum delta P =', np.max(delP_tot)
#len(delP_tot[ (delP_tot > data_delP_tot) ])

#ax31.annotate('DR11v0', xy=(data_dr11v0_delP_tot,0.0), xytext=(data_dr11v0_delP_tot, 15.0),
#        arrowprops=dict(facecolor='black'),fontsize=18)

ax31.annotate(r'$DR11v0$', (data_dr11v0_delP_tot,0.001), xycoords='data',
        xytext=(data_dr11v0_delP_tot-25.0, 20.0), textcoords='data',
        arrowprops=dict(arrowstyle="fancy",facecolor='black',
        connectionstyle="angle3,angleA=0,angleB=-90"),
        fontsize=18,
        horizontalalignment='center', verticalalignment='top')

ax31.annotate(r'$DR11v1$', (data_dr11v1_delP_tot,0.001), xycoords='data',
        xytext=(data_dr11v1_delP_tot-25.0, 15.0), textcoords='data',
        arrowprops=dict(arrowstyle="fancy",facecolor='m',
        connectionstyle="angle3,angleA=0,angleB=-90"),
        fontsize=18,color='m',
        horizontalalignment='center', verticalalignment='top')

ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**3,10**5.2])
ax11.set_xlabel('k',fontsize=15)
ax11.set_ylabel('P(k)',fontsize=15)
ax11.legend(loc='best',prop={'size':12})
ax11.grid(True)

ax12.set_xlim([10**-3,10**0])
ax12.set_ylim([10**3,10**5.2])
ax12.set_xlabel('k',fontsize=15)
ax12.set_ylabel(r"P(k)", fontsize=18)
ax12.legend(loc='best',prop={'size':12})
ax12.grid(True)

ax21.set_xlim([0.01,0.1])
ax21.set_ylim([-6.0*10**4,6.0*10**4])
ax21.set_xscale('log')
ax21.set_xlabel('k',fontsize=18)
ax21.set_ylabel(r"$\overline{P_{\rm{DR11}} - P_{\rm{DR10}}}$", fontsize=18)
ax21.legend(loc='best',prop={'size':15})
ax21.grid(True)

ax31.set_ylim([0,100])
ax31.set_xlabel(r'$\int_{k=0.01}^{0.1} P_{dr11} - P_{dr10}$', fontsize=20)
ax31.set_ylabel('Number of Mocks', fontsize=20)
ax31.tick_params(labelsize=14)
ax31.legend(loc='best',prop={'size':15})

py.show()
