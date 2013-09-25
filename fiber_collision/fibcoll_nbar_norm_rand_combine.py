import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'

n   = int(sys.argv[1])
name0   = 'nbar-normed-cmass_dr11_north_'
nameend = '_randoms_ir4_combined.v7.0.'

fname_rand_wboss        = name0+str(n)+nameend+'wboss.txt'
fname_rand_wboss_veto   = name0+str(n)+nameend+'wboss.veto.txt'
fname_rand_peakcorr     = name0+str(n)+nameend+'peakcorr.txt'
fname_rand_upweight     = name0+str(n)+nameend+'upweight.txt'

data_rand_wboss         = np.loadtxt(dir+fname_rand_wboss)
data_rand_wboss_veto    = np.loadtxt(dir+fname_rand_wboss_veto)
data_rand_peakcorr      = np.loadtxt(dir+fname_rand_peakcorr)
data_rand_upweight      = np.loadtxt(dir+fname_rand_upweight)

mockname0 = 'nbar-normed-cmass_dr11_north_ir4'

for i in range(1,n+1): 
    fname_upw   = mockname0+str(i+1000)[1:4]+'.v7.0.upweight.txt'
    fname_peak  = mockname0+str(i+1000)[1:4]+'.v7.0.peakcorr.txt' 

    data_upw    = np.loadtxt(dir+fname_upw)
    data_peak   = np.loadtxt(dir+fname_peak) 

    if i==1:
        mock_x_axis      = data_upw[:,0]
        sum_upw     = data_upw[:,3] 
        sum_peak    = data_peak[:,3]
    else: 
        sum_upw     = sum_upw+data_upw[:,3]
        sum_peak    = sum_peak+data_peak[:,3]
ratio_peak_upw = sum_peak/sum_upw
################################################################################################################
# Normed n(z) Comparison:
################################################################################################################
fig1 = py.figure(1,figsize=(8,5))
ax10 = fig1.add_subplot(111) 
ax10.text(0.45,0.03,str(n)+' Randoms',fontsize=15)
ax10.scatter(data_rand_wboss[:,0],data_rand_wboss[:,3],color='k',
        label=r'$w_{\rm{BOSS}} > 0$')
ax10.plot(data_rand_wboss_veto[:,0],data_rand_wboss_veto[:,3],'b',linewidth=2,
        label=r'$w_{\rm{BOSS}} > 0$ and veto mask applied')
ax10.plot(data_rand_peakcorr[:,0],data_rand_peakcorr[:,3],'r--',linewidth=2,
        label=r'Peak+$\bar{n}(z)$ Corrected')
ax10.set_xlim([0.43,0.7])
ax10.set_xlabel('Redshift ($z$)',fontsize=14)
ax10.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$',fontsize=14) 
ax10.legend(loc='best')
################################################################################################################
# Normed n(z) Ratio Comparison:
################################################################################################################
x_axis = data_rand_wboss[:,0]
ratio_rand_wboss_wboss_veto     = data_rand_wboss[:,3]/data_rand_wboss_veto[:,3]
ratio_rand_peakcorr_wboss_veto  = data_rand_peakcorr[:,3]/data_rand_wboss_veto[:,3]
ratio_rand_peakcorr_upweight    = data_rand_peakcorr[:,3]/data_rand_upweight[:,3]

fig2 = py.figure(2,figsize=(8,5))
ax20 = fig2.add_subplot(111) 
#ax20.text(0.45,str(n)+' Randoms',fontsize=15)
ax20.plot(x_axis,ratio_rand_wboss_wboss_veto,'b',linewidth=2,
        label=r'${(w_{\rm{BOSS}})_{\rm{Random}}}/{(w_{\rm{BOSS}} > 0 + \rm{vetomask})_{\rm{Random}}}$')
ax20.plot(x_axis,ratio_rand_peakcorr_wboss_veto,'r--',linewidth=2,
        label=r'${(\rm{Peak}+\bar{n}(z))_{\rm{Random}}}/{(w_{\rm{BOSS}} > 0 + \rm{vetomask})_{\rm{Random}}}$')
ax20.plot(x_axis,ratio_rand_peakcorr_upweight,'g--',linewidth=2,
        label=r'${(\rm{Peak}+\bar{n}(z))_{\rm{Random}}}/{(w_{\rm{upweight}})_{\rm{Random}}}$')
ax20.plot(mock_x_axis,ratio_peak_upw,'k',linewidth=2,
        label=r'${(\rm{Peak}+\bar{n}(z))_{\rm{Mock}}}/{(w_{\rm{upweight}})_{\rm{Mock}}}$')
ax20.set_xlim([0.43,0.7])
ax20.set_ylim([0.95,1.05])
ax20.set_xlabel('Redshift ($z$)',fontsize=14)
ax20.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=14) 
ax20.legend(loc='best')
################################################################################################################
# Normed n(z) Random-over-Mock Ratio Comparison:
################################################################################################################
ratio_rand_wboss_veto_mock_upw  = (data_rand_wboss_veto[:,3]*float(n))/sum_upw
ratio_rand_upw_mock_upw  = (data_rand_upweight[:,3]*float(n))/sum_upw
ratio_rand_peakcorr_mock_peak   = (data_rand_peakcorr[:,3]*float(n))/sum_peak

fig3 = py.figure(3,figsize=(8,5))
ax30 = fig3.add_subplot(111)
ax30.plot(x_axis,ratio_rand_wboss_veto_mock_upw,'b',linewidth=2,
        label=r'${(w_{\rm{BOSS}}+\rm{vetomask})_{\rm{Random}}}/{(w_{\rm{upweight}})_{\rm{Mock}}}$')
ax30.plot(x_axis,ratio_rand_upw_mock_upw,'g--',linewidth=2,
        label=r'${(w_{\rm{upweight}})_{\rm{Random}}}/{(w_{\rm{upweight}})_{\rm{Mock}}}$')
ax30.plot(x_axis,ratio_rand_peakcorr_mock_peak,'r--',linewidth=2,
        label=r'${({\rm{Peak}}+\bar{n}(z))_{\rm{Random}}}/{({\rm{Peak}}+\bar{n}(z))_{\rm{Mock}}}$')
ax30.set_xlim([0.43,0.7])
ax30.set_ylim([0.95,1.05])
ax30.set_xlabel('Redshift ($z$)',fontsize=14)
ax30.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=14) 
ax30.legend(loc='best')

py.show()
