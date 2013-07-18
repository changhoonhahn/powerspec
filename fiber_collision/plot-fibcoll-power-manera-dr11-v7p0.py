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
nrange = range(1,101)
for i in nrange:
    if i < 10:
        mockname_up = fname0+'00'+str(i)+fname1+'_upweighted.grid360.P020000.box3600'
        mockname_wb = fname0+'00'+str(i)+fname1+'_wbossonly.grid360.P020000.box3600'
        mockname_no = fname0+'00'+str(i)+fname1+'_noweight.grid360.P020000.box3600'
        mockname_dlos = fname0+'00'+str(i)+fname1+'-cp-dloshist.grid360.P020000.box3600'
        mockname_cp = fname0+'00'+str(i)+fname1+'-cp-crude.grid360.P020000.box3600'
    elif i < 100:
        mockname_up = fname0+'0'+str(i)+fname1+'_upweighted.grid360.P020000.box3600'
        mockname_wb = fname0+'0'+str(i)+fname1+'_wbossonly.grid360.P020000.box3600'
        mockname_no = fname0+'0'+str(i)+fname1+'_noweight.grid360.P020000.box3600'
        mockname_dlos = fname0+'0'+str(i)+fname1+'-cp-dloshist.grid360.P020000.box3600'
        mockname_cp = fname0+'0'+str(i)+fname1+'-cp-crude.grid360.P020000.box3600'
    else:
        mockname_up = fname0+str(i)+fname1+'_upweighted.grid360.P020000.box3600'
        mockname_wb = fname0+str(i)+fname1+'_wbossonly.grid360.P020000.box3600'
        mockname_no = fname0+str(i)+fname1+'_noweight.grid360.P020000.box3600'
        mockname_dlos = fname0+str(i)+fname1+'-cp-dloshist.grid360.P020000.box3600'
        mockname_cp = fname0+str(i)+fname1+'-cp-crude.grid360.P020000.box3600'
    try:
        with open(dir+mockname_up):
            files.append(i)
    except IOError:
        print 'file ',i,' does not exist.'

n = len(files)
for i in files:
    if i < 10:
        mockname_up = fname0+'00'+str(i)+fname1+'_upweighted.grid360.P020000.box3600'
        mockname_wb = fname0+'00'+str(i)+fname1+'_wbossonly.grid360.P020000.box3600'
        mockname_no = fname0+'00'+str(i)+fname1+'_noweight.grid360.P020000.box3600'
        mockname_dlos = fname0+'00'+str(i)+fname1+'-cp-dloshist.grid360.P020000.box3600'
        mockname_cp = fname0+'00'+str(i)+fname1+'-cp-crude.grid360.P020000.box3600'
    elif i < 100:
        mockname_up = fname0+'0'+str(i)+fname1+'_upweighted.grid360.P020000.box3600'
        mockname_wb = fname0+'0'+str(i)+fname1+'_wbossonly.grid360.P020000.box3600'
        mockname_no = fname0+'0'+str(i)+fname1+'_noweight.grid360.P020000.box3600'
        mockname_dlos = fname0+'0'+str(i)+fname1+'-cp-dloshist.grid360.P020000.box3600'
        mockname_cp = fname0+'0'+str(i)+fname1+'-cp-crude.grid360.P020000.box3600'
    else:
        mockname_up = fname0+str(i)+fname1+'_upweighted.grid360.P020000.box3600'
        mockname_wb = fname0+str(i)+fname1+'_wbossonly.grid360.P020000.box3600'
        mockname_no = fname0+str(i)+fname1+'_noweight.grid360.P020000.box3600'
        mockname_dlos = fname0+str(i)+fname1+'-cp-dloshist.grid360.P020000.box3600'
        mockname_cp = fname0+str(i)+fname1+'-cp-crude.grid360.P020000.box3600'

    mock_up = np.loadtxt(dir+mockname_up)
    mock_wb = np.loadtxt(dir+mockname_wb)
    mock_no = np.loadtxt(dir+mockname_no)
    mock_cp = np.loadtxt(dir+mockname_cp)
    mock_dlos = np.loadtxt(dir+mockname_dlos)

    if i==files[0]:
        mock_up_tot = mock_up[:,1]
        mock_wb_tot = mock_wb[:,1]
        mock_no_tot = mock_no[:,1]
        mock_cp_tot = mock_cp[:,1]
        mock_dlos_tot = mock_dlos[:,1]
        mock_k = mock_up[:,0]
    else:
        mock_up_tot = mock_up_tot + mock_up[:,1]
        mock_wb_tot = mock_wb_tot + mock_wb[:,1]
        mock_no_tot = mock_no_tot + mock_no[:,1]
        mock_dlos_tot = mock_dlos_tot + mock_dlos[:,1]
        mock_cp_tot = mock_cp_tot + mock_cp[:,1]
print n

mock_up_avg = mock_up_tot/float(n)
mock_wb_avg = mock_wb_tot/float(n)
mock_no_avg = mock_no_tot/float(n)
mock_cp_avg = mock_cp_tot/float(n)
mock_dlos_avg = mock_dlos_tot/float(n)
mock_up_wb_ratio = mock_up_avg/mock_wb_avg
mock_no_wb_ratio = mock_no_avg/mock_wb_avg
mock_dlos_wb_ratio = mock_dlos_avg/mock_wb_avg
mock_cp_wb_ratio = mock_cp_avg/mock_wb_avg

### Pbar
ax11.loglog( mock_k, mock_no_avg, color='k', linewidth=2, label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 $w=1$")
ax11.loglog( mock_k, mock_wb_avg, color='g', linewidth=2, label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 $w_{boss}$ only")
ax11.loglog( mock_k, mock_cp_avg, color='m', linewidth=2, label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 $d_{LOS}$ fiber collision correction")

ax21.scatter( mock_k, mock_up_avg, color='b', label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 $w=w_{BOSS}(w_{CP}+w_{RF}-1)$")
ax21.plot( mock_k, mock_wb_avg, 'ko-', label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 $w=w_{boss}$")
ax21.loglog( mock_k, mock_dlos_avg, color='m', linewidth=2, label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 CMASS $d_{LOS}$ CP Correction")
ax21.loglog( mock_k, mock_cp_avg, color='g', linewidth=2, label=r"$\overline{P(k)}$ for PTHalo NGC DR11 v7.0 naive CP Correction")

### Pbar ratio
ax12.scatter( mock_k, mock_up_wb_ratio, label=r"$\frac{\overline{P_{upweighted}}}{\overline{P_{wbossonly}}}$" )

ax22.scatter( mock_k, mock_up_wb_ratio, color='b', label=r"$\frac{\overline{P_{up-w}}}{\overline{P_{wboss}}}$" )
ax22.scatter( mock_k, mock_dlos_wb_ratio, color='m', label=r"$\frac{\overline{P_{cp-corr}}}{\overline{P_{wboss}}}$" )
ax22.scatter( mock_k, mock_cp_wb_ratio, color='g', label=r"$\frac{\overline{P_{naive-cp-corr}}}{\overline{P_{wboss}}}$" )

ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**2.5,10**6.0])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':12})
ax11.grid(True)

ax12.set_xlim([10**-3,10**0])
ax12.set_xscale('log')
ax12.set_xlabel('k',fontsize=20)
ax12.set_ylabel(r"$P_{\rm{upweighted}}/P_{\rm{wbossonly}}$",fontsize=20)
ax12.legend(loc='best',prop={'size':24})
ax12.grid(True)

ax21.set_xlim([10**-3,10**0])
ax21.set_ylim([10**2.75,10**5.1])
ax21.set_xlabel('k',fontsize=20)
ax21.set_ylabel('P(k)',fontsize=20)
ax21.legend(loc='best',prop={'size':12})
ax21.grid(True)

ax22.set_xlim([10**-3,10**0])
ax22.set_xscale('log')
ax22.set_xlabel('k',fontsize=20)
ax22.legend(loc='upper left',prop={'size':20})
ax22.grid(True)

py.show()
