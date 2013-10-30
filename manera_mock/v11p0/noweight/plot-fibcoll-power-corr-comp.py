import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

rc('text', usetex=True)
rc('font', family='serif')

v5p2_dir = '/mount/riachuelo1/hahn/power/manera_mock/v5p2/'
v7p0_dir = '/mount/riachuelo1/hahn/power/manera_mock/v7p0/'
v11p0_dir = '/mount/riachuelo1/hahn/power/manera_mock/v11p0/'

dr11_prefix = 'power_cmass_dr11_north_ir4'
dr10_prefix = 'power_cmass_dr10_north_ir4'
fname1 = '.v7.0.wghtv.txt'

files=[]

nrange_end = int(sys.argv[1])+1
nrange = range(1,nrange_end)
n = len(nrange)
for i in nrange:
    mockname_up_v5p2    = dr10_prefix+str(i+1000)[1:4]+'.v5.2.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    mockname_up_v7p0    = dr11_prefix+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    mockname_up_v11p0   = dr11_prefix+str(i+1000)[1:4]+'.v11.0.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    mockname_up_v5p2_mkrand = dr10_prefix+str(i+1000)[1:4]+'.v5.2.'+str(n)+'randoms.upweight.makerandom.grid360.P020000.box3600'
    mockname_up_v7p0_mkrand = dr11_prefix+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.upweight.makerandom.grid360.P020000.box3600'
    mockname_up_v11p0_mkrand = dr11_prefix+str(i+1000)[1:4]+'.v11.0.'+str(n)+'randoms.upweight.makerandom.grid360.P020000.box3600'
    mockname_now_v5p2_mkrand = dr10_prefix+str(i+1000)[1:4]+'.v5.2.'+str(n)+'randoms.noweight.makerandom.grid360.P020000.box3600'
    mockname_now_v7p0_mkrand = dr11_prefix+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.noweight.makerandom.grid360.P020000.box3600'
    mockname_now_v11p0_mkrand = dr11_prefix+str(i+1000)[1:4]+'.v11.0.'+str(n)+'randoms.noweight.makerandom.grid360.P020000.box3600'
    
    mock_up_v5p2  = np.loadtxt(v5p2_dir+mockname_up_v5p2)
    mock_up_v7p0  = np.loadtxt(v7p0_dir+mockname_up_v7p0)
    mock_up_v11p0 = np.loadtxt(v11p0_dir+mockname_up_v11p0)
    mock_up_v5p2_mkrand  = np.loadtxt(v5p2_dir+mockname_up_v5p2_mkrand)
    mock_up_v7p0_mkrand  = np.loadtxt(v7p0_dir+mockname_up_v7p0_mkrand)
    mock_up_v11p0_mkrand = np.loadtxt(v11p0_dir+mockname_up_v11p0_mkrand)
    mock_now_v5p2_mkrand  = np.loadtxt(v5p2_dir+mockname_now_v5p2_mkrand)
    mock_now_v7p0_mkrand  = np.loadtxt(v7p0_dir+mockname_now_v7p0_mkrand)
    mock_now_v11p0_mkrand = np.loadtxt(v11p0_dir+mockname_now_v11p0_mkrand)

    if i==1:
        mock_k              = mock_up_v11p0[:,0]
        mock_up_v5p2_tot    = mock_up_v5p2[:,1]
        mock_up_v7p0_tot    = mock_up_v7p0[:,1]
        mock_up_v11p0_tot   = mock_up_v11p0[:,1]
        mock_up_v5p2_mkrand_tot    = mock_up_v5p2_mkrand[:,1]
        mock_up_v7p0_mkrand_tot    = mock_up_v7p0_mkrand[:,1]
        mock_up_v11p0_mkrand_tot = mock_up_v11p0_mkrand[:,1]
        mock_now_v5p2_mkrand_tot    = mock_now_v5p2_mkrand[:,1]
        mock_now_v7p0_mkrand_tot    = mock_now_v7p0_mkrand[:,1]
        mock_now_v11p0_mkrand_tot   = mock_now_v11p0_mkrand[:,1]
    else:
        mock_up_v5p2_tot    = mock_up_v5p2_tot + mock_up_v5p2[:,1]
        mock_up_v7p0_tot    = mock_up_v7p0_tot + mock_up_v7p0[:,1]
        mock_up_v11p0_tot   = mock_up_v11p0_tot + mock_up_v11p0[:,1]
        mock_up_v5p2_mkrand_tot    = mock_up_v5p2_mkrand_tot + mock_up_v5p2_mkrand[:,1]
        mock_up_v7p0_mkrand_tot    = mock_up_v7p0_mkrand_tot + mock_up_v7p0_mkrand[:,1]
        mock_up_v11p0_mkrand_tot = mock_up_v11p0_mkrand_tot + mock_up_v11p0_mkrand[:,1]
        mock_now_v5p2_mkrand_tot    = mock_now_v5p2_mkrand_tot + mock_now_v5p2_mkrand[:,1]
        mock_now_v7p0_mkrand_tot    = mock_now_v7p0_mkrand_tot + mock_now_v7p0_mkrand[:,1]
        mock_now_v11p0_mkrand_tot   = mock_now_v11p0_mkrand_tot + mock_now_v11p0_mkrand[:,1]

power_cmass_dr11_nzw = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v2-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
power_cmass_dr10_nzw = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr10v8-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
mock_up_v5p2_avg    = mock_up_v5p2_tot/float(n)
mock_up_v7p0_avg    = mock_up_v7p0_tot/float(n)
mock_up_v11p0_avg   = mock_up_v11p0_tot/float(n)
mock_up_v5p2_mkrand_avg = mock_up_v5p2_mkrand_tot/float(n)
mock_up_v7p0_mkrand_avg = mock_up_v7p0_mkrand_tot/float(n)
mock_up_v11p0_mkrand_avg = mock_up_v11p0_mkrand_tot/float(n)
mock_now_v5p2_mkrand_avg    = mock_now_v5p2_mkrand_tot/float(n)
mock_now_v7p0_mkrand_avg    = mock_now_v7p0_mkrand_tot/float(n)
mock_now_v11p0_mkrand_avg   = mock_now_v11p0_mkrand_tot/float(n)

fig1 = plt.figure(1, figsize=(14,8))
#ax11 = fig1.add_subplot(121)
#ax11.text(2.0*10**-3.0,10**4,str(n)+' PTHalo DR11 v11.0 Mocks',fontsize=15)
#ax11.text(2.0*10**-3.0,10**3.9,str(n)+' PTHalo DR11 v7.0 Mocks',fontsize=15)
#ax11.scatter( power_cmass_dr11_nzw[:,0], power_cmass_dr11_nzw[:,1], color='k',
#        label=r"$\overline{P(k)}$ CMASS DR11v2 North$")
#ax11.loglog( mock_k, mock_up_v5p2_avg, 'g--', linewidth=3, 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR10 v5.2")
#ax11.loglog( mock_k, mock_up_v7p0_avg, 'b--', linewidth=3, 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0")
#ax11.scatter( mock_k, mock_up_v11p0_avg, color='r', 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v11.0")
#ax11.scatter( mock_k, mock_up_v11p0_mkrand_avg, color='m', 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v11.0 mksample Randoms")
#ax11.set_xlim([10**-3,10**0])
#ax11.set_ylim([10**3,10**5.1])
#ax11.set_xlabel('k',fontsize=20)
#ax11.set_ylabel('P(k)',fontsize=20)
#ax11.legend(loc='best',prop={'size':14})
#ax11.grid(True)

ratio_up_v5p2_cmass  = mock_up_v5p2_avg/power_cmass_dr10_nzw[:,1]
ratio_up_v7p0_cmass  = mock_up_v7p0_avg/power_cmass_dr11_nzw[:,1]
ratio_up_v11p0_cmass = mock_up_v11p0_avg/power_cmass_dr11_nzw[:,1]
ratio_up_v5p2_mkrand_cmass  = mock_up_v5p2_mkrand_avg/power_cmass_dr10_nzw[:,1]
ratio_up_v7p0_mkrand_cmass  = mock_up_v7p0_mkrand_avg/power_cmass_dr11_nzw[:,1]
ratio_up_v11p0_mkrand_cmass = mock_up_v11p0_mkrand_avg/power_cmass_dr11_nzw[:,1]
ratio_now_v5p2_mkrand_cmass  = mock_now_v5p2_mkrand_avg/power_cmass_dr10_nzw[:,1]
ratio_now_v7p0_mkrand_cmass  = mock_now_v7p0_mkrand_avg/power_cmass_dr11_nzw[:,1]
ratio_now_v11p0_mkrand_cmass = mock_now_v11p0_mkrand_avg/power_cmass_dr11_nzw[:,1]

ax12 = fig1.add_subplot(111)
ax12.scatter( mock_k, ratio_up_v5p2_cmass, color='g',
        label=r"$\overline{P(k)}_{\rm{v5.2}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.scatter( mock_k, ratio_up_v7p0_cmass, color='b', 
        label=r"$\overline{P(k)}_{\rm{v7.0}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.scatter( mock_k, ratio_up_v11p0_cmass, color='r', 
        label=r"$\overline{P(k)}_{\rm{v11.0}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.plot( mock_k, ratio_now_v5p2_mkrand_cmass, 'g', linewidth=2, 
        label=r"$\overline{P(k)}_{\rm{v5.2},\rm{mksample rand}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.plot( mock_k, ratio_now_v7p0_mkrand_cmass, 'b', linewidth=2, 
        label=r"$\overline{P(k)}_{\rm{v7.0},\rm{mksample rand}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.plot( mock_k, ratio_now_v11p0_mkrand_cmass, 'r', linewidth=2, 
        label=r"$\overline{P(k)}_{\rm{v11.0},\rm{mksample rand}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.grid(True)
ax12.set_xscale('log')
ax12.set_xlim([10**-3,10**0])
ax12.set_ylim([0.4,1.5])
ax12.legend(loc='best',prop={'size':16})
py.show()
