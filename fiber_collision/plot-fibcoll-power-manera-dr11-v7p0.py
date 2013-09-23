import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'

fname0 = 'power_cmass_dr11_north_ir4'
fname1 = '.v7.0.wghtv.txt'

files=[]

nrange_end = int(sys.argv[1])+1
nrange = range(1,nrange_end)
n = len(nrange)
for i in nrange:
    mockname_up     = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    mockname_wb     = fname0+str(i+1000)[1:4]+fname1+'_wbossonly.grid360.P020000.box3600'
    mockname_no     = fname0+str(i+1000)[1:4]+fname1+'_noweight.grid360.P020000.box3600'
    mockname_dlos   = fname0+str(i+1000)[1:4]+fname1+'-cp-pthalo-dloshist.grid360.P020000.box3600'
    mockname_dlos_pm= fname0+str(i+1000)[1:4]+fname1+'-cp-pthalo-dloshist-pm.grid360.P020000.box3600'
    mockname_shl    = 'power_shuffle_cmass_dr11_north_ir4'+str(i+1000)[1:4]+fname1+'-cp-dlosshuffle.grid360.P020000.box3600' 
    mockname_shlup  = 'power_upweighted_cmass_dr11_north_ir4'+str(i+1000)[1:4]+fname1+'-cp-dlosupweighted.grid360.P020000.box3600' 
    mockname_shlz   = 'power_shuffle_zlim_cmass_dr11_north_ir4'+str(i+1000)[1:4]+fname1+'-cp-dlosshuffle.grid360.P020000.box3600' 
    mockname_shlz_nz= 'power_shuffle_zlim_cmass_dr11_north_ir4'+str(i+1000)[1:4]+fname1+'-cp-dlosshuffle-nbarcorr.grid360.P020000.box3600' 
    mockname_peak   = fname0+str(i+1000)[1:4]+fname1+'-cp-dlos-peak-nbar.grid360.P020000.box3600'
    
    mock_up     = np.loadtxt(dir+mockname_up)
    mock_wb     = np.loadtxt(dir+mockname_wb)
    mock_no     = np.loadtxt(dir+mockname_no)
    mock_dlos   = np.loadtxt(dir+mockname_dlos)
    mock_dlos_pm= np.loadtxt(dir+mockname_dlos_pm)
    mock_shl    = np.loadtxt(dir+mockname_shl)
    mock_shlup  = np.loadtxt(dir+mockname_shlup)
    mock_shlz   = np.loadtxt(dir+mockname_shlz)
    mock_shlz_nz= np.loadtxt(dir+mockname_shlz_nz)
    mock_peak   = np.loadtxt(dir+mockname_peak)

    if i==1:
        mock_k = mock_up[:,0]
        mock_up_tot         = mock_up[:,1]
        mock_wb_tot         = mock_wb[:,1]
        mock_no_tot         = mock_no[:,1]
        mock_dlos_tot       = mock_dlos[:,1]
        mock_dlos_pm_tot    = mock_dlos_pm[:,1]
        mock_shl_tot        = mock_shl[:,1]
        mock_shlup_tot      = mock_shlup[:,1]
        mock_shlz_tot       = mock_shlz[:,1]
        mock_shlz_nz_tot    = mock_shlz[:,1]
        mock_peak_tot       = mock_peak[:,1]
    else:
        mock_up_tot         = mock_up_tot + mock_up[:,1]
        mock_wb_tot         = mock_wb_tot + mock_wb[:,1]
        mock_no_tot         = mock_no_tot + mock_no[:,1]
        mock_dlos_tot       = mock_dlos_tot + mock_dlos[:,1]
        mock_dlos_pm_tot    = mock_dlos_pm_tot + mock_dlos_pm[:,1]
        mock_shl_tot        = mock_shl_tot + mock_shl[:,1]
        mock_shlup_tot      = mock_shlup_tot + mock_shlup[:,1]
        mock_shlz_tot       = mock_shlz_tot + mock_shlz[:,1]
        mock_shlz_nz_tot    = mock_shlz_nz_tot + mock_shlz_nz[:,1]
        mock_peak_tot       = mock_peak_tot+mock_peak[:,1]
mock_up_avg         = mock_up_tot/float(n)
mock_wb_avg         = mock_wb_tot/float(n)
mock_no_avg         = mock_no_tot/float(n)
mock_dlos_avg       = mock_dlos_tot/float(n)
mock_dlos_pm_avg    = mock_dlos_pm_tot/float(n)
mock_shl_avg        = mock_shl_tot/float(n)
mock_shlup_avg      = mock_shlup_tot/float(n)
mock_shlz_avg       = mock_shlz_tot/float(n)
mock_shlz_nz_avg    = mock_shlz_nz_tot/float(n)
mock_peak_avg       = mock_peak_tot/float(n)

mock_up_wb_ratio        = mock_up_avg/mock_wb_avg
mock_no_wb_ratio        = mock_no_avg/mock_wb_avg
mock_dlos_wb_ratio      = mock_dlos_avg/mock_wb_avg
mock_dlos_pm_wb_ratio   = mock_dlos_pm_avg/mock_wb_avg
mock_shl_wb_ratio       = mock_shl_avg/mock_wb_avg
mock_shlup_wb_ratio     = mock_shlup_avg/mock_wb_avg
mock_shlz_wb_ratio      = mock_shlz_avg/mock_wb_avg
mock_shlz_nz_wb_ratio   = mock_shlz_nz_avg/mock_wb_avg
mock_peak_wb_ratio      = mock_peak_avg/mock_wb_avg

#mock_up_no_ratio = mock_up_avg/mock_no_avg
#mock_dlos_no_ratio = mock_dlos_avg/mock_no_avg
#mock_dlos_pm_no_ratio = mock_dlos_pm_avg/mock_no_avg

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax11.plot( mock_k, mock_wb_avg, 'ko-', 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w=w_{boss}$")
ax11.loglog( mock_k, mock_up_avg, color='b', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w=w_{BOSS}(w_{CP}+w_{RF}-1)$")
ax11.loglog( mock_k, mock_dlos_pm_avg, color='r', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $d_{LOS}$ CP $\pm$ Correction")
ax11.loglog( mock_k, mock_peak_avg, color='g', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $d_{LOS}$ Exponential Peak $\overline{n}(z)$ Tail")
#ax11.loglog( mock_k, mock_shlz_avg, color='y', linewidth=2, 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 PTHalo $d_{LOS}$ Shuffle z limit")
#ax11.loglog( mock_k, mock_shlup_avg, color='g', linewidth=2, 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 PTHalo $d_{LOS}$ Shuffle Upweighted")

ax12 = fig1.add_subplot(122)
ax12.scatter( mock_k, mock_up_wb_ratio, color='b', 
        label=r"${\overline{P_{up-w}}}/{\overline{P_{wboss}}}$" )
ax12.scatter( mock_k, mock_dlos_pm_wb_ratio, color='r', 
        label=r"${\overline{P_{cp-\pm-corr}}}/{\overline{P_{wboss}}}$" )
ax12.scatter( mock_k, mock_peak_wb_ratio, color='g',
        label=r"${\overline{P_{d_{LOS} peak}}}/{\overline{P_{wboss}}}$" )
#ax12.scatter( mock_k, mock_shlz_nz_wb_ratio, color='m', label=r"${\overline{P_{\rm{dlos-shuffle-nbarz}}}}/{\overline{P_{wboss}}}$" )
#ax12.scatter( mock_k, mock_shlz_wb_ratio, color='y', label=r"${\overline{P_{\rm{dlos-shuffle-zlim}}}}/{\overline{P_{wboss}}}$" )
#ax12.scatter( mock_k, mock_shlup_wb_ratio, color='g', label=r"${\overline{P_{\rm{dlos-upweighted}}}}/{\overline{P_{wboss}}}$" )

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

#fig2 = plt.figure(2, figsize=(14,8))
#ax21 = fig2.add_subplot(121)
#ax22 = fig2.add_subplot(122)

# P(K) COMPARISON TO NO WEIGHT ONLY:  
#ax21.plot( mock_k, mock_no_avg, 'ko-', label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w=1$")
#ax21.loglog( mock_k, mock_up_avg, color='b', linewidth=2, label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w=w_{BOSS}(w_{CP}+w_{RF}-1)$")
#ax21.loglog( mock_k, mock_dlos_avg, color='m', linewidth=2, label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 PTHalo $d_{LOS}$ CP Correction")
#ax21.loglog( mock_k, mock_dlos_pm_avg, color='r', linewidth=2, label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 PTHalo $d_{LOS}$ CP $\pm$ Correction")

### Pbar ratio
#ax22.scatter( mock_k, mock_up_no_ratio, color='b', label=r"${\overline{P_{up-w}}}/{\overline{P_{no w}}}$" )
#ax22.scatter( mock_k, mock_dlos_no_ratio, color='m', label=r"${\overline{P_{cp-corr}}}/{\overline{P_{no w}}}$" )
#ax22.scatter( mock_k, mock_dlos_pm_no_ratio, color='r', label=r"${\overline{P_{cp-\pm-corr}}}/{\overline{P_{no w}}}$" )
#ax22.scatter( mock_k, mock_cp_no_ratio, color='g', label=r"${\overline{P_{naive-cp-corr}}}/{\overline{P_{no w}}}$" )
#
#ax21.set_xlim([10**-3,10**0])
#ax21.set_ylim([10**2.75,10**5.1])
#ax21.set_xlabel('k',fontsize=20)
#ax21.set_ylabel('P(k)',fontsize=20)
#ax21.legend(loc='best',prop={'size':12})
#ax21.grid(True)
#
#ax22.set_xlim([10**-3,10**0])
#ax22.set_ylim([0.8,1.2])
#ax22.set_xscale('log')
#ax22.set_xlabel('k',fontsize=20)
#ax22.legend(loc='upper left',prop={'size':16})
#ax22.grid(True)

py.show()
