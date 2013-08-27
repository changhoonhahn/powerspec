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
name0   = 'cmass_dr11_north_ir4'
nameend = '.v7.0.'
for i in range(1,n+1): 
    fname_wboss = 'nbar-'+name0+str(i+1000)[1:4]+nameend+'wboss.txt'
    fname_upw   = 'nbar-'+name0+str(i+1000)[1:4]+nameend+'upweight.txt'
    fname_shfl  = 'nbar_shuffle_zlim_'+name0+str(i+1000)[1:4]+nameend+'wghtv.txt'
    fname_peak  = 'nbar-'+name0+str(i+1000)[1:4]+'.v7.0.peakcorr.txt'
    fname_rand  = 'nbar-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameend+'wghtv.txt'
    fname_randp = 'nbar-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameend+'peakcorr.txt'

    data_wboss    = np.loadtxt(dir+fname_wboss)
    data_upw    = np.loadtxt(dir+fname_upw)
    data_shfl   = np.loadtxt(dir+fname_shfl)
    data_peak   = np.loadtxt(dir+fname_peak)
    data_rand   = np.loadtxt(dir+fname_rand)
    data_randp  = np.loadtxt(dir+fname_randp)

    if i==1: 
        x_axis      = data_wboss[:,0]
        sum_wboss   = data_wboss[:,3]
        sum_upw     = data_upw[:,3]
        sum_shfl    = data_shfl[:,3]
        sum_peak    = data_peak[:,3]
        sum_rand    = data_rand[:,3]
        sum_randp   = data_randp[:,3]
    else: 
        sum_wboss   = sum_wboss+data_wboss[:,3]
        sum_upw     = sum_upw+data_upw[:,3]
        sum_shfl    = sum_shfl+data_shfl[:,3]
        sum_peak    = sum_peak+data_peak[:,3]
        sum_rand    = sum_rand+data_rand[:,3]
        sum_randp   = sum_randp+data_randp[:,3]

ratio_upw_wboss     = sum_upw/sum_wboss
ratio_shfl_wboss    = sum_shfl/sum_wboss
ratio_peak_wboss    = sum_peak/sum_wboss
ratio_peak_upw      = sum_peak/sum_upw
ratio_rand_upw      = sum_rand/sum_upw
ratio_rand_wboss    = sum_rand/sum_wboss
ratio_rand_shfl     = sum_rand/sum_shfl
ratio_rand_peak     = sum_rand/sum_peak
ratio_randp_rand    = sum_randp/sum_rand
ratio_randp_peak    = sum_randp/sum_peak

sum_wboss_norm  = sum_wboss/np.sum(sum_wboss)
sum_upw_norm    = sum_upw/np.sum(sum_upw)
sum_peak_norm   = sum_peak/np.sum(sum_peak)
sum_rand_norm   = sum_rand/np.sum(sum_rand)
ratio_rand_peak_norm = sum_rand_norm/sum_peak_norm

pthalo_fname= 'nbar-cmass-dr11may22-N-Anderson.dat'
pthalo_data = np.loadtxt(dir+pthalo_fname)
pthalo_norm = pthalo_data[:,3]/np.sum(pthalo_data[:,3])
ratio_upw_pthalo    = sum_upw/(pthalo_data[:,3]*n)
ratio_peak_pthalo   = sum_peak/(pthalo_data[:,3]*n)
ratio_wboss_pthalo  = sum_wboss/(pthalo_data[:,3]*n)
ratio_rand_pthalo   = sum_rand/(pthalo_data[:,3])
ratio_randp_pthalo  = sum_randp/(pthalo_data[:,3])

fig1 = py.figure(1,figsize=(8,5)) 
ax10 = fig1.add_subplot(111) 
ax10.plot(x_axis,sum_upw,'b',linewidth=2,label='Up weighted') 
ax10.plot(x_axis,sum_wboss,'k--',linewidth=2,label='$w_{BOSS}$ only') 
ax10.scatter(x_axis,sum_peak,color='r',label='Peak')
#ax10.scatter(x_axis,sum_shfl,color='g',label='Shuffle')
ax10.set_xlim([0.43,0.7])
ax10.set_xlabel('Redshift ($z$)',fontsize=14) 
ax10.set_ylabel('$\overline{n}(z)$',fontsize=14)
ax10.legend(loc='best') 

fig2 = py.figure(2,figsize=(8,5))
ax20 = fig2.add_subplot(111)
ax20.text(0.45,1.04,str(n)+' Mocks',fontsize=15)
ax20.plot(x_axis,ratio_upw_wboss,'b',linewidth=2,
        label='${\overline{n}(z)_{upweight}}/{\overline{n}(z)_{w_{BOSS}-only}}$')
ax20.plot(x_axis,ratio_peak_upw,'m',linewidth=2,
        label='${\overline{n}(z)_{peak}}/{\overline{n}(z)_{upweight}}$')
ax20.plot(x_axis,ratio_randp_rand,'g',linewidth=2,
        label='${\overline{n}(z)_{rand-peak}}/{\overline{n}(z)_{rand}}$') 
#ax20.plot(x_axis,ratio_shfl_wboss,'g',linewidth=2,
#        label='${\overline{n}(z)_{shuffle}}/{\overline{n}(z)_{w_{BOSS}-only}}$')
#ax20.plot(x_axis,ratio_peak_wboss,'r',linewidth=2,
#        label='${\overline{n}(z)_{peak}}/{\overline{n}(z)_{w_{BOSS}-only}}$')
ax20.set_xlim([0.43,0.7])
ax20.set_ylim([0.95,1.05])
ax20.set_xlabel('Redshift ($z$)',fontsize=14)
ax20.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax20.legend(loc='best')

fig3 = py.figure(3,figsize=(8,5))
ax30 = fig3.add_subplot(111)
ax30.plot(x_axis,ratio_upw_pthalo,'b',linewidth=2,
        label='${\overline{n}(z)_{upweight}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax30.plot(x_axis,ratio_wboss_pthalo,'k--',linewidth=2,
        label='${\overline{n}(z)_{w_{BOSS}-only}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax30.plot(x_axis,ratio_peak_pthalo,'m',linewidth=2,
        label='${\overline{n}(z)_{peak}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax30.set_xlim([0.43,0.7])
ax30.set_ylim([0.75,1.25])
ax30.set_xlabel('Redshift ($z$)',fontsize=14)
ax30.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax30.legend(loc='best')

fig4 = py.figure(4,figsize=(8,5))
ax40 = fig4.add_subplot(111)
ax40.plot(x_axis,ratio_rand_pthalo,'b',linewidth=2,
        label='${\overline{n}(z)_{rand}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax40.plot(x_axis,ratio_randp_pthalo,'k--',linewidth=2,
        label='${\overline{n}(z)_{rand-peak}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax40.set_xlim([0.43,0.7])
ax40.set_ylim([5.7,8.0])
ax40.set_xlabel('Redshift ($z$)',fontsize=14)
ax40.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax40.legend(loc='best')

fig5 = py.figure(5,figsize=(8,5))
ax50 = fig5.add_subplot(111)
ax50.plot(x_axis,ratio_rand_upw,'b',linewidth=2,
        label='${\overline{n}(z)_{rand}}/{\overline{n}(z)_{upweighted}}$') 
ax50.plot(x_axis,ratio_rand_wboss,'m',linewidth=2,
        label='${\overline{n}(z)_{rand}}/{\overline{n}(z)_{w_{BOSS}}}$') 
ax50.plot(x_axis,ratio_randp_peak,'k--',linewidth=2,
        label='${\overline{n}(z)_{rand-peak}}/{\overline{n}(z)_{peak}}$') 
ax50.set_xlim([0.43,0.7])
ax50.set_ylim([0.6,0.65])
ax50.set_xlabel('Redshift ($z$)',fontsize=14)
ax50.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax50.legend(loc='best')

#pthalo_nbar             = np.loadtxt(dir+'nbar-cmass-dr11may22-N-Anderson.dat')
#pthalo_nbar_dlos_corr   = np.loadtxt(dir+'nbar-cmass-dr11may22-N-Anderson-dlosshuffle-corrected.dat')
#
#ratio_dloscorr = pthalo_nbar_dlos_corr[:,4]/pthalo_nbar[:,3]
#
#fig3 = py.figure(3,figsize=(16,5))
#ax30 = fig3.add_subplot(121)
#ax31 = fig3.add_subplot(122)
#
#ax30.plot(pthalo_nbar[:,0],pthalo_nbar[:,3],'k',linewidth=2,label='PTHalo $\overline{n}(z)$')
#ax30.scatter(pthalo_nbar_dlos_corr[:,0],pthalo_nbar_dlos_corr[:,4],color='b',label='PTHalo $\overline{n}(z)$ $d_{LOS}$ Corrected')
#ax30.set_xlim([0.43,0.7])
#ax30.set_xlabel('Redshift ($z$)',fontsize=14)
#ax30.set_ylabel('$\overline{n}(z)$',fontsize=14) 
#ax30.legend(loc='best')
#
#ax31.plot(pthalo_nbar[:,0],ratio_dloscorr,'k',linewidth=2,label='${\overline{n}(z)_{\rm{PTHalo-corr}}}/{\overline{n}(z)_{\rm{PTHalo}}}$')
#ax31.set_xlim([0.43,0.7])
#ax31.set_ylim([0.8,1.2])
#ax31.set_xlabel('Redshift ($z$)',fontsize=14)
#ax31.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
#ax31.legend(loc='best')
py.show()
