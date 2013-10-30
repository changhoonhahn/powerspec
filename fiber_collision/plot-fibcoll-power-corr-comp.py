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
    mockname_wb     = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.wboss.grid360.P020000.box3600'
    mockname_up     = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    mockname_peak   = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.peakcorr.grid360.P020000.box3600'
    mockname_now    = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.noweight.grid360.P020000.box3600'
    mockname_peakupw    = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.peakcorrupw.grid360.P020000.box3600'
    mockname_peaknopeak = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.peakcorrnopeak.grid360.P020000.box3600'
    mockname_tailtest   = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.peakcorrtail.grid360.P020000.box3600'
    mockname_broadpeak  = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.peaknz.fpeak1.broad.grid360.P020000.box3600'
    
    mock_wb     = np.loadtxt(dir+mockname_wb)
    mock_up     = np.loadtxt(dir+mockname_up)
    mock_peak   = np.loadtxt(dir+mockname_peak)
    mock_now    = np.loadtxt(dir+mockname_now)
    mock_peakupw    = np.loadtxt(dir+mockname_peakupw)
    mock_peaknopeak = np.loadtxt(dir+mockname_peaknopeak)
    mock_tailtest   = np.loadtxt(dir+mockname_tailtest)
    mock_broadpeak  = np.loadtxt(dir+mockname_broadpeak)

    if i==1:
        mock_k = mock_up[:,0]
        mock_wb_tot         = mock_wb[:,1]
        mock_up_tot         = mock_up[:,1]
        mock_peak_tot       = mock_peak[:,1]
        mock_now_tot        = mock_now[:,1]
        mock_peakupw_tot    = mock_peakupw[:,1]
        mock_peaknopeak_tot = mock_peaknopeak[:,1]
        mock_tailtest_tot   = mock_tailtest[:,1]
        mock_broadpeak_tot  = mock_broadpeak[:,1]
    else:
        mock_wb_tot         = mock_wb_tot + mock_wb[:,1]
        mock_up_tot         = mock_up_tot + mock_up[:,1]
        mock_peak_tot       = mock_peak_tot + mock_peak[:,1]
        mock_now_tot        = mock_now_tot + mock_now[:,1]
        mock_peakupw_tot    = mock_peakupw_tot + mock_peakupw[:,1]
        mock_peaknopeak_tot = mock_peaknopeak_tot + mock_peaknopeak[:,1]
        mock_tailtest_tot   = mock_tailtest_tot + mock_tailtest[:,1]
        mock_broadpeak_tot  = mock_broadpeak_tot + mock_broadpeak[:,1]
mock_wb_avg         = mock_wb_tot/float(n)
mock_up_avg         = mock_up_tot/float(n)
mock_peak_avg       = mock_peak_tot/float(n)
mock_now_avg        = mock_now_tot/float(n)
mock_peakupw_avg    = mock_peakupw_tot/float(n)
mock_peaknopeak_avg = mock_peaknopeak_tot/float(n)
mock_tailtest_avg   = mock_tailtest_tot/float(n)
mock_broadpeak_avg  = mock_broadpeak_tot/float(n)

fig1 = plt.figure(1, figsize=(14,8))
ax11 = fig1.add_subplot(121)
ax11.text(2.0*10**-3.0,10**5,str(n)+' PTHalo DR11 v7.0 Mocks',fontsize=15)
ax11.scatter( mock_k, mock_wb_avg, color='k',
        label=r"$\overline{P(k)}_{w_{BOSS}}$")
#ax11.loglog( mock_k, mock_now_avg, 'r', linewidth=3, 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w=1$")
#ax11.loglog( mock_k, mock_up_avg, 'b', linewidth=3, 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w_{upweighted}$")
ax11.loglog( mock_k, mock_peak_avg, 'b', linewidth=3,
        label=r"$\overline{P(k)}_{\rm{Peak}+\bar{n}(z)}$")
#ax11.loglog( mock_k, mock_peakupw_avg, 'm--', linewidth=2, 
#        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 Peak$+\bar{n}(z)$ with $f_{\rm{peak}}=1$")
ax11.loglog( mock_k, mock_peaknopeak_avg, color='m', linewidth=2, 
        label=r"$\overline{P(k)}_{\rm{Peak}+\bar{n}(z); f_{\rm{peak}}=0}$")
#ax11.loglog( mock_k, mock_tailtest_avg, color='r', linewidth=2, 
#        label=r"$\overline{P(k)}_{2\% \rm{Tail \; Test}}$")
ax11.loglog( mock_k, mock_broadpeak_avg, color='r', linewidth=2, 
        label=r"$\overline{P(k)}_{f_{\rm{peak}}=1,\sigma=5}$")
ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**3,10**5.1])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':14})
ax11.grid(True)

ratio_up_wb         = mock_up_avg/mock_wb_avg
ratio_now_wb        = mock_now_avg/mock_wb_avg
ratio_peak_wb       = mock_peak_avg/mock_wb_avg
ratio_peakupw_wb    = mock_peakupw_avg/mock_wb_avg
ratio_nopeak_wb     = mock_peaknopeak_avg/mock_wb_avg
ratio_tailtest_wb   = mock_tailtest_avg/mock_wb_avg
ratio_broadpeak_wb  = mock_broadpeak_avg/mock_wb_avg

ax12 = fig1.add_subplot(122)
ax12.plot( mock_k, ratio_up_wb,'k--', linewidth=2,
        label=r"$\overline{P(k)}_{\rm{upweight}}/\overline{P(k)}_{w_{\rm{BOSS}}}$")
#ax12.scatter( mock_k, ratio_now_wb, color='r', 
#        label=r"$\overline{P(k)}_{w=1}/\overline{P(k)}_{w_{\rm{BOSS}}}$")
ax12.scatter( mock_k, ratio_peak_wb, color='b', 
        label=r"$\overline{P(k)}_{\rm{Peak}+\bar{n}(z)}/\overline{P(k)}_{w_{\rm{BOSS}}}$")
#ax12.scatter( mock_k, ratio_peakupw_wb, color='m', 
#        label=r"$\overline{P(k)}_{\rm{Peak}+\bar{n}(z)}/\overline{P(k)}_{w_{\rm{BOSS}}}$")
ax12.scatter( mock_k, ratio_nopeak_wb, color='m', 
        label=r"$\overline{P(k)}_{\rm{No Peak}}/\overline{P(k)}_{w_{\rm{BOSS}}}$")
#ax12.scatter( mock_k, ratio_tailtest_wb, color='r', 
#        label=r"$\overline{P(k)}_{\rm{tail test}}/\overline{P(k)}_{w_{\rm{BOSS}}}$")
ax12.scatter( mock_k, ratio_broadpeak_wb, color='r', 
        label=r"$\overline{P(k)}_{f_{\rm{peak}}=1,\sigma=5}/\overline{P(k)}_{w_{\rm{BOSS}}}$")
ax12.grid(True)
ax12.set_xscale('log')
ax12.set_xlim([10**-3,10**0])
ax12.legend(loc='best',prop={'size':14})
py.show()
