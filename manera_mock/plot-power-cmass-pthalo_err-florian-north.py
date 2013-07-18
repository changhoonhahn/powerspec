import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir_v7p0 = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'
dir_v5p2 = '/mount/riachuelo1/hahn/power/manera_mock/v5p2/'

#Pbar for PTHalo mocks. 
mockpbar = plt.figure(1, figsize=(14,8))
mockpbar_ax1 = mockpbar.add_subplot(121)
mockpbar_ax2 = mockpbar.add_subplot(122)
mockpbar_ax1.set_xlim([10**-3,10**0])
mockpbar_ax1.set_ylim([10**3,10**5.2])
mockpbar_ax1.set_xlabel('k',fontsize=15)
mockpbar_ax1.set_ylabel('P(k)',fontsize=15)
mockpbar_ax1.legend(loc='best',prop={'size':12})
mockpbar_ax1.grid(True)

mockpbar_ax2.set_xlim([10**-3,10**0])
mockpbar_ax2.set_ylim([10**-2,10**0.5])
mockpbar_ax2.set_xlabel('k',fontsize=15)
mockpbar_ax2.set_ylabel(r"$\frac{\Delta P}{P}$", fontsize=18)
mockpbar_ax2.legend(loc='best',prop={'size':12})
mockpbar_ax2.grid(True)

mockname0='power_cmass_dr'
mockext_florian='wghtv.txt_wboss_florian.grid360.P020000.box3600'

for i in range(1,601):
    if i < 10:
        mockname_v7p0=mockname0+'11_north_ir400'+str(i)+'.v7.0.'+mockext_florian 
        mockname_v5p2=mockname0+'10_north_ir400'+str(i)+'.v5.2.'+mockext_florian 
    elif i < 100:
        mockname_v7p0=mockname0+'11_north_ir40'+str(i)+'.v7.0.'+mockext_florian 
        mockname_v5p2=mockname0+'10_north_ir40'+str(i)+'.v5.2.'+mockext_florian 
    else:
        mockname_v7p0=mockname0+'11_north_ir4'+str(i)+'.v7.0.'+mockext_florian 
        mockname_v5p2=mockname0+'10_north_ir4'+str(i)+'.v5.2.'+mockext_florian 
    mock_v7p0 = np.loadtxt(dir_v7p0+mockname_v7p0)
    mock_v5p2 = np.loadtxt(dir_v5p2+mockname_v5p2)
    if i == 1:
        mocktot_v7p0 = mock_v7p0[:,1]
        mocktot_v5p2 = mock_v5p2[:,1]
        mock_v7p0_k = mock_v7p0[:,0]
        mock_v5p2_k = mock_v5p2[:,0]
    else:
        mocktot_v7p0 = mocktot_v7p0 + mock_v7p0[:,1]
        mocktot_v5p2 = mocktot_v5p2 + mock_v5p2[:,1]

print i
mockavg_v7p0 = np.array([ mocktot_v7p0[x]/float(i) for x in range(len(mocktot_v7p0)) ])
mockavg_v5p2 = np.array([ mocktot_v5p2[x]/float(i) for x in range(len(mocktot_v5p2)) ])

mockpbar_ax1.loglog( mock_v7p0_k, mockavg_v7p0, color='k', linewidth=2, label=r"$\overline{P_{mock}}$ for 600 Manera Mocks v7.0 North")
mockpbar_ax1.loglog( mock_v5p2_k, mockavg_v5p2, color='r', linewidth=2, label=r"$\overline{P_{mock}}$ for 600 Manera Mocks v5.2 North")

mockscat_v7p0 = np.zeros( [len(mockavg_v7p0)] )
mockscat_v5p2 = np.zeros( [len(mockavg_v5p2)] )
for ii in range(1,601):
    if ii < 10:
        mockname_v7p0=mockname0+'11_north_ir400'+str(ii)+'.v7.0.'+mockext_florian 
        mockname_v5p2=mockname0+'10_north_ir400'+str(ii)+'.v5.2.'+mockext_florian 
    elif ii < 100:
        mockname_v7p0=mockname0+'11_north_ir40'+str(ii)+'.v7.0.'+mockext_florian 
        mockname_v5p2=mockname0+'10_north_ir40'+str(ii)+'.v5.2.'+mockext_florian 
    else:
        mockname_v7p0=mockname0+'11_north_ir4'+str(ii)+'.v7.0.'+mockext_florian 
        mockname_v5p2=mockname0+'10_north_ir4'+str(ii)+'.v5.2.'+mockext_florian 
    mock_v7p0 = np.loadtxt(dir_v7p0+mockname_v7p0)
    mock_v5p2 = np.loadtxt(dir_v5p2+mockname_v5p2)
    
    mockdiff_v7p0 = [(mock_v7p0[x,1]-mockavg_v7p0[x])**2 for x in range(len(mock_v7p0[:,1]))]
    mockdiff_v5p2 = [(mock_v5p2[x,1]-mockavg_v5p2[x])**2 for x in range(len(mock_v5p2[:,1]))]

    mockscat_v7p0 = mockscat_v7p0 + mockdiff_v7p0
    mockscat_v5p2 = mockscat_v5p2 + mockdiff_v5p2
print ii
mock_scat_v7p0 = np.sqrt( mockscat_v7p0/float(ii) )/mockavg_v7p0
mock_scat_v5p2 = np.sqrt( mockscat_v5p2/float(ii) )/mockavg_v5p2
mock_del_v7p0 = np.sqrt( mockscat_v7p0/float(ii) )
mock_del_v5p2 = np.sqrt( mockscat_v5p2/float(ii) )

mockpbar_ax2.loglog( mock_v7p0_k, mock_scat_v7p0, color='k',linewidth=2, label=r"$\Delta P/\bar{P}$ for 600 Manera Mocks v7.0 North" )
mockpbar_ax2.loglog( mock_v5p2_k, mock_scat_v5p2, color='r',linewidth=2, label=r"$\Delta P/\bar{P}$ for 600 Manera Mocks v5.2 North" )

power_cmass_dr10v8_north = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr10v8-N-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
power_cmass_dr11v0_north = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v0-N-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
power_cmass_dr11v1_north = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v1-N-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')
power_cmass_dr11v2_north = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v2-N-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat')

#Comparison between CMASS P(k) and Pbar(k) 
cmass_mock= plt.figure(2, figsize=(7,8))
cmass_mock_ax1 = cmass_mock.add_subplot(111)
cmass_mock_ax1.loglog( power_cmass_dr11v0_north[:,0], power_cmass_dr11v0_north[:,1], color='k', linewidth=2, label="P(k) CMASS DR11v0 North" )
cmass_mock_ax1.loglog( power_cmass_dr10v8_north[:,0], power_cmass_dr10v8_north[:,1], color='r', linewidth=2, label="P(k) CMASS DR11v0 North" )
cmass_mock_ax1.loglog( mock_v7p0_k, mockavg_v7p0, 'k--', linewidth=2, label="Average P(k) for 600 Manera Mocks v7.0 North" )
cmass_mock_ax1.loglog( mock_v5p2_k, mockavg_v5p2, 'r--', linewidth=2, label="Average P(k) for 600 Manera Mocks v7.0 North" )

cmass_mock_ax1.set_xlim([10**-3,10**0])
cmass_mock_ax1.set_ylim([10**3,10**5.2])
cmass_mock_ax1.set_xlabel('k',fontsize=15)
cmass_mock_ax1.set_ylabel('P(k)',fontsize=15)
cmass_mock_ax1.legend(loc='best',prop={'size':15})
cmass_mock_ax1.grid(True)

#CMASS P(k) with Error Bars from PTHalo Mocks
cmass_err = plt.figure(3, figsize=(10,7)) 
cmass_err_ax1 = cmass_err.add_subplot(111)
cmass_err_ax1.scatter( power_cmass_dr10v8_north[:,0], power_cmass_dr10v8_north[:,1], color='r', label='P(k) CMASS DR10v8 North') 
cmass_err_ax1.errorbar( power_cmass_dr10v8_north[:,0], power_cmass_dr10v8_north[:,1], yerr=mock_scat_v5p2*mockavg_v5p2, fmt='ro', capsize=3, elinewidth=2) 
cmass_err_ax1.scatter( power_cmass_dr11v0_north[:,0], power_cmass_dr11v0_north[:,1], color='k', label='P(k) CMASS DR11v0 North') 
cmass_err_ax1.errorbar( power_cmass_dr11v0_north[:,0], power_cmass_dr11v0_north[:,1], yerr=mock_scat_v7p0*mockavg_v7p0, fmt='ko', capsize=3, elinewidth=2) 
cmass_err_ax1.scatter( power_cmass_dr11v2_north[:,0], power_cmass_dr11v2_north[:,1], color='b', label='P(k) CMASS DR11v2 North')
cmass_err_ax1.errorbar( power_cmass_dr11v2_north[:,0], power_cmass_dr11v2_north[:,1], yerr=mock_scat_v7p0*mockavg_v7p0, fmt='bo', capsize=3, elinewidth=2)

cmass_err_ax1.set_yscale('log')
cmass_err_ax1.set_xlim([0.0,0.2])
cmass_err_ax1.set_ylim([10**3,10**5.2])
cmass_err_ax1.set_xlabel('k',fontsize=20)
cmass_err_ax1.set_ylabel('P(k)',fontsize=20)
lg = cmass_err_ax1.legend(loc='best',prop={'size':20})
lg.get_frame().set_linewidth(0)
cmass_err_ax1.grid(True)
cmass_err_ax1.tick_params(labelsize=15)
py.show()
