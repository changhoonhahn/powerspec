import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'
dr11testdir = '/mount/riachuelo1/hahn/power/manera_mock/dr11test/'

fname0 = 'power_cmass_dr11_north_ir4'
fname1 = '.v7.0.wghtv.txt'

files=[]

nrange_end = int(sys.argv[1])+1
nrange = range(1,nrange_end)
n = len(nrange)
for i in nrange:
    mockname_up         = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    mockname_up_mkrand  = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.upweight.makerandom.grid360.P020000.box3600'
    mockname_up_test    = fname0+str(i+1000)[1:4]+'.v11.0.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    
    mock_up         = np.loadtxt(dir+mockname_up)
    mock_up_mkrand  = np.loadtxt(dir+mockname_up_mkrand)
    mock_up_test    = np.loadtxt(dr11testdir+mockname_up_test)

    if i==1:
        mock_k = mock_up[:,0]
        mock_up_tot         = mock_up[:,1]
        mock_up_mkrand_tot  = mock_up_mkrand[:,1]
        mock_up_test_tot    = mock_up_test[:,1]
    else:
        mock_up_tot         = mock_up_tot + mock_up[:,1]
        mock_up_mkrand_tot  = mock_up_mkrand_tot + mock_up_mkrand[:,1]
        mock_up_test_tot    = mock_up_test_tot + mock_up_test[:,1]

power_cmass_dr11_nzw = np.loadtxt('/mount/riachuelo1/hahn/power/power-cmass-dr11v2-N-Anderson-nzw-zlim-ngalsys-3600lbox-360grid-180bin.dat')
mock_up_avg         = mock_up_tot/float(n)
mock_up_mkrand_avg  = mock_up_mkrand_tot/float(n)
mock_up_test_avg    = mock_up_test_tot/float(n)

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax11.text(2.0*10**-3.0,10**4,str(n)+' PTHalo DR11 v11.0 Mocks',fontsize=15)
ax11.text(2.0*10**-3.0,10**3.9,str(n)+' PTHalo DR11 v7.0 Mocks',fontsize=15)
ax11.scatter( power_cmass_dr11_nzw[:,0], power_cmass_dr11_nzw[:,1], color='k',
        label=r"$\overline{P(k)}$ CMASS DR11v2 North$")
ax11.loglog( mock_k, mock_up_avg, 'b', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0")
ax11.loglog( mock_k, mock_up_mkrand_avg, 'm--', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 Make Random")
ax11.scatter( mock_k, mock_up_test_avg, color='r', 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v11.0")
ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**3,10**5.1])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':14})
ax11.grid(True)

ratio_up_cmass          = mock_up_avg/power_cmass_dr11_nzw[:,1]
ratio_up_mkrand_cmass   = mock_up_mkrand_avg/power_cmass_dr11_nzw[:,1]
ratio_up_test_cmass     = mock_up_test_avg/power_cmass_dr11_nzw[:,1]

ax12 = fig1.add_subplot(122)
ax12.plot( mock_k, ratio_up_cmass, 'b', linewidth=2, 
        label=r"$\overline{P(k)}_{\rm{v7.0}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.plot( mock_k, ratio_up_mkrand_cmass, 'm', linewidth=2, 
        label=r"$\overline{P(k)}_{\rm{v7.0},\rm{mkrandom}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.plot( mock_k, ratio_up_test_cmass, 'r', linewidth=2, 
        label=r"$\overline{P(k)}_{\rm{v11.0}}/\overline{P(k)}_{\rm{CMASS}}$")
ax12.grid(True)
ax12.set_xscale('log')
ax12.set_xlim([10**-3,10**0])
ax12.set_ylim([0.4,1.5])
ax12.legend(loc='best',prop={'size':16})
py.show()
