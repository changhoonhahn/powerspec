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
    fname_rand  = 'nbar-normed-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameend+'upweight.txt'
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

cmass_dr11may_fname = 'nbar-normed-cmass-dr11may22-N-Anderson.dat'
cmass_dr10v5_fname  = 'nbar-normed-dr10v5-N-Anderson.dat'

cmass_dr11may_data  = np.loadtxt(dir+cmass_dr11may_fname)
cmass_dr10v5_data   = np.loadtxt(dir+cmass_dr10v5_fname)

################################################################################################################
# Nbar(z) Ratios: 
################################################################################################################
ratio_upw_wboss     = sum_upw/sum_wboss

ratio_peak_wboss    = sum_peak/sum_wboss
ratio_peak_upw      = sum_peak/sum_upw
ratio_randp_rand    = sum_randp/sum_rand

ratio_rand_upw      = sum_rand/sum_upw
ratio_rand_wboss    = sum_rand/sum_wboss
ratio_randp_peak    = sum_randp/sum_peak

ratio_rand_upw_v5p2      = sum_rand_dr10/sum_upw_dr10
ratio_rand_wboss_v5p2    = sum_rand_dr10/sum_wboss_dr10
ratio_rand_v7p0_rand_v5p2= sum_rand/sum_rand_dr10

ratio_upw_v7p0_cmass_dr11may    = sum_upw/(float(n)*cmass_dr11may_data[:,3])
ratio_wboss_v7p0_cmass_dr11may  = sum_wboss/(float(n)*cmass_dr11may_data[:,3])
ratio_rand_v7p0_cmass_dr11may   = sum_rand/(float(n)*cmass_dr11may_data[:,3])
ratio_peak_v7p0_cmass_dr11may   = sum_peak/(float(n)*cmass_dr11may_data[:,3])
ratio_randp_v7p0_cmass_dr11may  = sum_randp/(float(n)*cmass_dr11may_data[:,3])

ratio_upw_v7p0_cmass_dr10v5     = sum_upw/(float(n)*cmass_dr10v5_data[:,3])
ratio_rand_v7p0_cmass_dr10v5    = sum_rand/(float(n)*cmass_dr10v5_data[:,3])

ratio_wboss_v5p2_cmass_dr10v5   = sum_wboss_dr10/(float(n)*cmass_dr10v5_data[:,3])
ratio_upw_v5p2_cmass_dr10v5     = sum_upw_dr10/(float(n)*cmass_dr10v5_data[:,3])
ratio_rand_v5p2_cmass_dr10v5    = sum_rand_dr10/(float(n)*cmass_dr10v5_data[:,3])
################################################################################################################
# wBOSS only and upweight comparison:
################################################################################################################
fig1 = py.figure(1,figsize=(8,5))
ax10 = fig1.add_subplot(111) 
ax10.text(0.45,1.04,str(n)+' Mocks',fontsize=15)
ax10.plot(x_axis,ratio_upw_wboss,'b',linewidth=2,
        label=r'${\bar{n}(z)_{\rm{upweight}}}/{\bar{n}(z)_{w_{BOSS}-only}}$')
ax10.set_xlim([0.43,0.7])
ax10.set_ylim([0.95,1.05])
ax10.set_xlabel('Redshift ($z$)',fontsize=14)
ax10.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=14) 
ax10.legend(loc='best')
################################################################################################################
# peak+nbar(z) corrected over uncorrected comparison: 
################################################################################################################
fig2 = py.figure(2,figsize=(8,5))
ax20 = fig2.add_subplot(111)
ax20.text(0.45,1.04,str(n)+' Mocks',fontsize=15)
ax20.plot(x_axis,ratio_peak_upw,'k',linewidth=2,
        label=r'${\bar{n}(z)_{\rm{peak}+\bar{n}(z)}}/{\bar{n}(z)_{\rm{upweight}}}$')
ax20.plot(x_axis,ratio_randp_rand,'r',linewidth=2,
        label=r'${\bar{n}(z)_{\rm{rand},\rm{peak}+\bar{n}(z)}}/{\bar{n}(z)_{\rm{rand}}}$') 
ax20.set_xlim([0.43,0.7])
ax20.set_ylim([0.95,1.05])
ax20.set_xlabel('Redshift ($z$)',fontsize=18)
ax20.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=18) 
ax20.legend(loc='best')
ax20.grid()
################################################################################################################
# nbar(z) ratio for PTHalo mocks over CMASS: 
################################################################################################################
fig3 = py.figure(3,figsize=(9,7))
ax30 = fig3.add_subplot(111)
ax30.text(0.50,1.10,str(n)+' Mocks',fontsize=18)
ax30.plot(x_axis,ratio_upw_v7p0_cmass_dr11may,'k',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR11May22}}}$") 
ax30.plot(x_axis,ratio_upw_v7p0_cmass_dr10v5,'m--',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
ax30.plot(x_axis,ratio_upw_v5p2_cmass_dr10v5,'r',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v5.2}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
ax30.set_xlim([0.43,0.7])
ax30.set_ylim([0.9,1.2])
ax30.set_xlabel('Redshift ($z$)',fontsize=18)
ax30.set_ylabel(r"$\bar{n} (z)_{ \rm{norm}}$ Ratio",fontsize=18) 
ax30.legend(loc='best',prop={'size':18})
################################################################################################################
# nbar(z) ratio for PTHalo randoms over CMASS: 
################################################################################################################
fig4 = py.figure(4,figsize=(9,7))
ax40 = fig4.add_subplot(111)
ax40.plot(x_axis,ratio_rand_v7p0_cmass_dr11may,'k',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v7.0.}}}/{\bar{n}(z)_{\rm{CMASS-DR11May22}}}$") 
ax40.plot(x_axis,ratio_rand_v7p0_cmass_dr10v5,'m--',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
ax40.plot(x_axis,ratio_rand_v5p2_cmass_dr10v5,'r',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v5.2.}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
ax40.set_xlim([0.43,0.7])
ax40.set_ylim([0.9,1.2])
ax40.set_xlabel('Redshift ($z$)',fontsize=18)
ax40.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=18) 
ax40.legend(loc='best',prop={'size':18})
################################################################################################################
# nbar(z) ratio for PTHalo Randoms over PTHalo Mocks: 
################################################################################################################
fig5 = py.figure(5,figsize=(9,7))
ax50 = fig5.add_subplot(111)
ax50.text(0.45,1.015,str(n)+' Mocks',fontsize=18)
ax50.plot(x_axis,ratio_rand_upw,'b',linewidth=3,
        label=r'${\bar{n}(z)_{\rm{rand},\rm{upweight}}}/{\bar{n}(z)_{\rm{mock},\rm{upweighted}}}$') 
#ax50.scatter(x_axis,ratio_rand_upw_v5p2,color='m',
#        label=r'${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v5.2}}}/{\bar{n}(z)_{\rm{upweighted},\rm{PTHalo-v5.2}}}$') 
ax50.plot(x_axis,ratio_randp_peak,'k',linewidth=3,
        label=r'${\bar{n}(z)_{\rm{rand},\rm{peak}+\bar{n}(z)}}/{\bar{n}(z)_{\rm{mock},\rm{peak}+\bar{n}(z)}}$') 
ax50.set_xlim([0.43,0.7])
ax50.set_ylim([0.975,1.025])
ax50.set_xlabel('Redshift ($z$)',fontsize=18)
ax50.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=18) 
ax50.legend(loc='best',prop={'size':16})
py.show()
