import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'

fname0 = 'power_cmass_dr11_north_ir4'
fname1 = '.v7.0.wghtv.txt'

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax12 = fig1.add_subplot(122)

fig2 = plt.figure(2, figsize=(14,8))
ax21 = fig2.add_subplot(121)
ax22 = fig2.add_subplot(122)

files=[]
n = 0
nrange = range(1,2)
for i in nrange:
    if i < 10:
        mockname_dlos_pthalo = fname0+'00'+str(i)+fname1+'-cp-pthalo-dloshist.grid360.P020000.box3600'
        mockname_dlos_cmass = fname0+'00'+str(i)+fname1+'-cp-cmass-dloshist.grid360.P020000.box3600'
        mockname_dlos_pthalo_pm = fname0+'00'+str(i)+fname1+'-cp-pthalo-dloshist-pm.grid360.P020000.box3600'
        mockname_dlos_cmass_pm = fname0+'00'+str(i)+fname1+'-cp-cmass-dloshist-pm.grid360.P020000.box3600'
    elif i < 100:
        mockname_dlos_pthalo = fname0+'0'+str(i)+fname1+'-cp-pthalo-dloshist.grid360.P020000.box3600'
        mockname_dlos_cmass = fname0+'0'+str(i)+fname1+'-cp-cmass-dloshist.grid360.P020000.box3600'
        mockname_dlos_pthalo_pm = fname0+'0'+str(i)+fname1+'-cp-pthalo-dloshist-pm.grid360.P020000.box3600'
        mockname_dlos_cmass_pm = fname0+'0'+str(i)+fname1+'-cp-cmass-dloshist-pm.grid360.P020000.box3600'
    else:
        mockname_dlos_pthalo = fname0+str(i)+fname1+'-cp-pthalo-dloshist.grid360.P020000.box3600'
        mockname_dlos_cmass = fname0+str(i)+fname1+'-cp-cmass-dloshist.grid360.P020000.box3600'
        mockname_dlos_pthalo_pm = fname0+str(i)+fname1+'-cp-pthalo-dloshist-pm.grid360.P020000.box3600'
        mockname_dlos_cmass_pm = fname0+str(i)+fname1+'-cp-cmass-dloshist-pm.grid360.P020000.box3600'
    try:
        with open(dir+mockname_dlos_pthalo):
            files.append(i)
    except IOError:
        print 'file ',i,' does not exist.'
        print dir+mockname_dlos_pthalo

n = len(files)
for i in files:
    if i < 10:
        mockname_dlos_pthalo = fname0+'00'+str(i)+fname1+'-cp-pthalo-dloshist.grid360.P020000.box3600'
        mockname_dlos_cmass = fname0+'00'+str(i)+fname1+'-cp-cmass-dloshist.grid360.P020000.box3600'
        mockname_dlos_pthalo_pm = fname0+'00'+str(i)+fname1+'-cp-pthalo-dloshist-pm.grid360.P020000.box3600'
        mockname_dlos_cmass_pm = fname0+'00'+str(i)+fname1+'-cp-cmass-dloshist-pm.grid360.P020000.box3600'
    elif i < 100:
        mockname_dlos_pthalo = fname0+'0'+str(i)+fname1+'-cp-pthalo-dloshist.grid360.P020000.box3600'
        mockname_dlos_cmass = fname0+'0'+str(i)+fname1+'-cp-cmass-dloshist.grid360.P020000.box3600'
        mockname_dlos_pthalo_pm = fname0+'0'+str(i)+fname1+'-cp-pthalo-dloshist-pm.grid360.P020000.box3600'
        mockname_dlos_cmass_pm = fname0+'0'+str(i)+fname1+'-cp-cmass-dloshist-pm.grid360.P020000.box3600'
    else:
        mockname_dlos_pthalo = fname0+str(i)+fname1+'-cp-pthalo-dloshist.grid360.P020000.box3600'
        mockname_dlos_cmass = fname0+str(i)+fname1+'-cp-cmass-dloshist.grid360.P020000.box3600'
        mockname_dlos_pthalo_pm = fname0+str(i)+fname1+'-cp-pthalo-dloshist-pm.grid360.P020000.box3600'
        mockname_dlos_cmass_pm = fname0+str(i)+fname1+'-cp-cmass-dloshist-pm.grid360.P020000.box3600'
    
    mock_dlos_pthalo = np.loadtxt(dir+mockname_dlos_pthalo)
    mock_dlos_cmass = np.loadtxt(dir+mockname_dlos_cmass)
    mock_dlos_pthalo_pm = np.loadtxt(dir+mockname_dlos_pthalo_pm)
    mock_dlos_cmass_pm = np.loadtxt(dir+mockname_dlos_cmass_pm)

    if i==files[0]:
        mock_dlos_pthalo_tot = mock_dlos_pthalo[:,1]
        mock_dlos_cmass_tot = mock_dlos_cmass[:,1]
        mock_dlos_pthalo_pm_tot = mock_dlos_pthalo_pm[:,1]
        mock_dlos_cmass_pm_tot = mock_dlos_cmass_pm[:,1]
        mock_k = mock_dlos_pthalo[:,0]
    else:
        mock_dlos_pthalo_tot = mock_dlos_pthalo_tot + mock_dlos_pthalo[:,1]
        mock_dlos_cmass_tot = mock_dlos_cmass_tot + mock_dlos_cmass[:,1]
        mock_dlos_pthalo_pm_tot = mock_dlos_pthalo_pm_tot + mock_dlos_pthalo_pm[:,1]
        mock_dlos_cmass_pm_tot = mock_dlos_cmass_pm_tot + mock_dlos_cmass_pm[:,1]
print n

mock_dlos_pthalo_avg = mock_dlos_pthalo_tot/float(n)
mock_dlos_cmass_avg = mock_dlos_cmass_tot/float(n)
mock_dlos_pthalo_pm_avg = mock_dlos_pthalo_pm_tot/float(n)
mock_dlos_cmass_pm_avg = mock_dlos_cmass_pm_tot/float(n)

mock_dlos_pthalo_cmass_ratio = mock_dlos_pthalo_avg/mock_dlos_cmass_avg
mock_dlos_pthalo_cmass_pm_ratio = mock_dlos_pthalo_pm_avg/mock_dlos_cmass_pm_avg

ax11.scatter( mock_k, mock_dlos_pthalo_avg, color='b', label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 PTHalo $d_{LOS}$ CP Correction")
ax11.loglog( mock_k, mock_dlos_cmass_avg, color='r', linewidth=2, label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 CMASS $d_{LOS}$ CP Correction")

ax21.scatter( mock_k, mock_dlos_pthalo_pm_avg, color='b', label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 PTHalo $\pm d_{LOS}$ CP Correction")
ax21.loglog( mock_k, mock_dlos_cmass_pm_avg, color='r', linewidth=2, label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 CMASS $\pm d_{LOS}$ CP Correction")

### Pbar ratio
ax12.scatter( mock_k, mock_dlos_pthalo_cmass_ratio, label=r"${\overline{P_{pthalo-dlos}}}/{\overline{P_{cmass-dlos}}}$" )
ax22.scatter( mock_k, mock_dlos_pthalo_cmass_pm_ratio, label=r"${\overline{P_{pthalo-\pm dlos}}}/{\overline{P_{cmass-\pm dlos}}}$" )

ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**2.75,10**5.1])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':12})
ax11.grid(True)

ax12.set_xlim([10**-3,10**0])
ax12.set_ylim([0.8,1.2])
ax12.set_xscale('log')
ax12.set_xlabel('k',fontsize=20)
ax12.legend(loc='upper left',prop={'size':16})
ax12.grid(True)

ax21.set_xlim([10**-3,10**0])
ax21.set_ylim([10**2.75,10**5.1])
ax21.set_xlabel('k',fontsize=20)
ax21.set_ylabel('P(k)',fontsize=20)
ax21.legend(loc='best',prop={'size':12})
ax21.grid(True)

ax22.set_xlim([10**-3,10**0])
ax22.set_ylim([0.8,1.2])
ax22.set_xscale('log')
ax22.set_xlabel('k',fontsize=20)
ax22.legend(loc='upper left',prop={'size':16})
ax22.grid(True)

py.show()
