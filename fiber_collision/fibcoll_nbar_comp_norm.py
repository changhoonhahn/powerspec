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
name0dr10 = 'cmass_dr10_north_ir4'
nameend = '.v7.0.'
nameenddr10 = '.v5.2.'
for i in range(1,n+1): 
    fname_wboss = 'nbar-normed-'+name0+str(i+1000)[1:4]+nameend+'wboss.txt'
    fname_upw   = 'nbar-normed-'+name0+str(i+1000)[1:4]+nameend+'upweight.txt'
    fname_peak  = 'nbar-normed-'+name0+str(i+1000)[1:4]+'.v7.0.peakcorr.txt'
    fname_rand  = 'nbar-normed-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameend+'wghtv.txt'
    fname_randp = 'nbar-normed-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameend+'peakcorr.txt'

    fname_wboss_dr10 = 'nbar-normed-'+name0dr10+str(i+1000)[1:4]+nameenddr10+'wboss.txt'
    fname_upw_dr10   = 'nbar-normed-'+name0dr10+str(i+1000)[1:4]+nameenddr10+'upweight.txt'
    fname_rand_dr10  = 'nbar-normed-cmass_dr10_north_randoms_ir4'+str(i+1000)[1:4]+nameenddr10+'wghtv.txt'

    data_wboss  = np.loadtxt(dir+fname_wboss)
    data_upw    = np.loadtxt(dir+fname_upw)
    data_peak   = np.loadtxt(dir+fname_peak)
    data_rand   = np.loadtxt(dir+fname_rand)
    data_randp  = np.loadtxt(dir+fname_randp)
    
    data_wboss_dr10  = np.loadtxt(dir+fname_wboss_dr10)
    data_upw_dr10    = np.loadtxt(dir+fname_upw_dr10)
    data_rand_dr10   = np.loadtxt(dir+fname_rand_dr10)

    if i==1: 
        x_axis      = data_wboss[:,0]
        sum_wboss   = data_wboss[:,3]
        sum_upw     = data_upw[:,3]
        sum_peak    = data_peak[:,3]
        sum_rand    = data_rand[:,3]
        sum_randp   = data_randp[:,3]
        
        sum_wboss_dr10   = data_wboss_dr10[:,3]
        sum_upw_dr10     = data_upw_dr10[:,3]
        sum_rand_dr10    = data_rand_dr10[:,3]
    else: 
        sum_wboss   = sum_wboss+data_wboss[:,3]
        sum_upw     = sum_upw+data_upw[:,3]
        sum_peak    = sum_peak+data_peak[:,3]
        sum_rand    = sum_rand+data_rand[:,3]
        sum_randp   = sum_randp+data_randp[:,3]
        
        sum_wboss_dr10   = sum_wboss_dr10+data_wboss_dr10[:,3]
        sum_upw_dr10     = sum_upw_dr10+data_upw_dr10[:,3]
        sum_rand_dr10    = sum_rand_dr10+data_rand_dr10[:,3]
ratio_upw_wboss     = sum_upw/sum_wboss
ratio_peak_wboss    = sum_peak/sum_wboss
ratio_peak_upw      = sum_peak/sum_upw

ratio_rand_upw      = sum_rand/sum_upw
ratio_rand_wboss    = sum_rand/sum_wboss

ratio_rand_peak     = sum_rand/sum_peak
ratio_randp_rand    = sum_randp/sum_rand
ratio_randp_peak    = sum_randp/sum_peak

ratio_rand_upw_dr10      = sum_rand_dr10/sum_upw_dr10
ratio_rand_wboss_dr10    = sum_rand_dr10/sum_wboss_dr10

pthalo_fname_dr11may= 'nbar-normed-cmass-dr11may22-N-Anderson.dat'
pthalo_fname_dr10v5 = 'nbar-normed-dr10v5-N-Anderson.dat' 

pthalo_data = np.loadtxt(dir+pthalo_fname_dr11may)
pthalo_data_dr10v5  = np.loadtxt(dir+pthalo_fname_dr10v5)

ratio_upw_pthalo    = sum_upw/(pthalo_data[:,3]*float(n))
ratio_upw_pthalo_dr10v5 = sum_upw/(pthalo_data_dr10v5[:,3]*float(n))
ratio_peak_pthalo   = sum_peak/(pthalo_data[:,3]*float(n))
ratio_wboss_pthalo  = sum_wboss/(pthalo_data[:,3]*float(n))
ratio_rand_pthalo   = sum_rand/(pthalo_data[:,3]*float(n))
ratio_randp_pthalo  = sum_randp/(pthalo_data[:,3]*float(n))

ratio_upw_cmass_dr10 = sum_upw_dr10/(pthalo_data_dr10v5[:,3]*float(n))
ratio_rand_cmass_dr10= sum_rand_dr10/(pthalo_data_dr10v5[:,3]*float(n))

fig1 = py.figure(1,figsize=(8,5)) 
ax10 = fig1.add_subplot(111) 
ax10.plot(x_axis,sum_upw,'b',linewidth=2,label='Up weighted') 
ax10.plot(x_axis,sum_wboss,'m--',linewidth=2,label='$w_{BOSS}$ only') 
ax10.scatter(x_axis,pthalo_data[:,3]*float(n),color='k',label='CMASS$_{dr11may}$') 
ax10.scatter(x_axis,sum_peak,color='r',label='Peak')
ax10.scatter(x_axis,sum_rand,color='y',label='PTHalo Random')
ax10.scatter(x_axis,sum_randp,color='g',label='PTHalo Peak Corr Random')
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
#ax20.plot(x_axis,ratio_peak_wboss,'r',linewidth=2,
#        label='${\overline{n}(z)_{peak}}/{\overline{n}(z)_{w_{BOSS}-only}}$')
ax20.set_xlim([0.43,0.7])
ax20.set_ylim([0.95,1.05])
ax20.set_xlabel('Redshift ($z$)',fontsize=14)
ax20.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax20.legend(loc='best')
ax20.grid()

fig3 = py.figure(3,figsize=(9,7))
ax30 = fig3.add_subplot(111)
ax30.text(0.50,1.10,str(n)+' Mocks',fontsize=18)
ax30.plot(x_axis,ratio_upw_pthalo,'k',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR11may}}}$") 
#ax30.plot(x_axis,ratio_upw_pthalo_dr10v5,'b--',linewidth=3,
#        label=r"${\bar{n}(z)_{\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
ax30.plot(x_axis,ratio_upw_cmass_dr10,'r',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v5.2}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
#ax30.plot(x_axis,ratio_rand_cmass_dr10,'m--',linewidth=3,
#        label=r"${\bar{n}(z)_{\rm{PTHalo-v5.2}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
#ax30.plot(x_axis,ratio_wboss_pthalo,'b--',linewidth=2,
#        label='${\overline{n}(z)_{w_{BOSS}-only}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
#ax30.plot(x_axis,ratio_peak_pthalo,'r--',linewidth=2,
#        label='${\overline{n}(z)_{peak}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
#ax30.scatter(x_axis,ratio_rand_pthalo,color='k',
#        label='${\overline{n}(z)_{rand}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
#ax30.scatter(x_axis,ratio_randp_pthalo,color='m',
#        label='${\overline{n}(z)_{rand-peak}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax30.set_xlim([0.43,0.7])
ax30.set_ylim([0.9,1.2])
ax30.set_xlabel('Redshift ($z$)',fontsize=18)
ax30.set_ylabel(r"$\bar{n} (z)_{ \rm{norm}}$ Ratio",fontsize=18) 
ax30.legend(loc='best',prop={'size':18})

fig4 = py.figure(4,figsize=(8,5))
ax40 = fig4.add_subplot(111)
ax40.plot(x_axis,ratio_rand_pthalo,'b',linewidth=2,
        label='${\overline{n}(z)_{rand}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax40.plot(x_axis,ratio_randp_pthalo,'k--',linewidth=2,
        label='${\overline{n}(z)_{rand-peak}}/{\overline{n}(z)_{CMASS-dr11may}}$') 
ax40.set_xlim([0.43,0.7])
ax40.set_ylim([0.8,1.2])
ax40.set_xlabel('Redshift ($z$)',fontsize=14)
ax40.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax40.legend(loc='best')

fig5 = py.figure(5,figsize=(8,5))
ax50 = fig5.add_subplot(111)
ax50.text(0.45,1.01,str(n)+' Mocks',fontsize=15)
#ax50.plot(x_axis,ratio_rand_upw,'b',linewidth=2,
#        label='${\overline{n}(z)_{rand}}/{\overline{n}(z)_{upweighted}}$') 
ax50.plot(x_axis,ratio_rand_wboss,'b',linewidth=2,
        label='${\overline{n}(z)_{rand}}/{\overline{n}(z)_{w_{BOSS}}}$') 
ax50.plot(x_axis,ratio_randp_peak,'k',linewidth=2,
        label='${\overline{n}(z)_{rand-peak}}/{\overline{n}(z)_{peak}}$') 
ax50.set_xlim([0.43,0.7])
ax50.set_ylim([0.975,1.025])
ax50.set_xlabel('Redshift ($z$)',fontsize=14)
ax50.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax50.legend(loc='best')
py.show()
