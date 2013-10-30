import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

rc('text', usetex=True)
rc('font', family='serif')

dir11   = '/mount/riachuelo1/hahn/data/manera_mock/dr11test/'
dir7    = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'

n   = int(sys.argv[1])
name0       = 'cmass_dr11_north_ir4'
nameendv11  = '.v11.0.'
nameendv7   = '.v7.0.'
for i in range(1,n+1): 
    fname_upw11 = 'nbar-normed-'+name0+str(i+1000)[1:4]+nameendv11+'upweight.txt'
    fname_rand11= 'nbar-normed-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameendv11+'wghtv.txt'
    fname_upw7  = 'nbar-normed-'+name0+str(i+1000)[1:4]+nameendv7+'upweight.txt'
    fname_rand7 = 'nbar-normed-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameendv7+'wghtv.txt'

    data_upw11    = np.loadtxt(dir11+fname_upw11)
    data_rand11   = np.loadtxt(dir11+fname_rand11)
    data_upw7    = np.loadtxt(dir7+fname_upw7)
    data_rand7   = np.loadtxt(dir7+fname_rand7)

    if i==1: 
        x_axis      = data_upw11[:,0]
        sum_upw11   = data_upw11[:,3]
        sum_rand11  = data_rand11[:,3]
        sum_upw7    = data_upw7[:,3]
        sum_rand7   = data_rand7[:,3]
    else: 
        sum_upw11   = sum_upw11+data_upw11[:,3]
        sum_rand11  = sum_rand11+data_rand11[:,3]
        sum_upw7    = sum_upw7+data_upw7[:,3]
        sum_rand7   = sum_rand7+data_rand7[:,3]

cmass_dr11may_fname = 'nbar-normed-cmass-dr11may22-N-Anderson.dat'
cmass_dr10v5_fname  = 'nbar-normed-dr10v5-N-Anderson.dat'

cmass_dr11may_data  = np.loadtxt('/mount/riachuelo1/hahn/data/manera_mock/dr11/'+cmass_dr11may_fname)
cmass_dr10v5_data   = np.loadtxt('/mount/riachuelo1/hahn/data/manera_mock/dr11/'+cmass_dr10v5_fname)

################################################################################################################
# Nbar(z) Ratios: 
################################################################################################################
ratio_rand_upw11= sum_rand11/sum_upw11
ratio_rand_upw7 = sum_rand7/sum_upw7

ratio_upw_v11p0_cmass_dr11may   = sum_upw11/(float(n)*cmass_dr11may_data[:,3])
ratio_rand_v11p0_cmass_dr11may  = sum_rand11/(float(n)*cmass_dr11may_data[:,3])
ratio_upw_v7p0_cmass_dr11may    = sum_upw7/(float(n)*cmass_dr11may_data[:,3])
ratio_rand_v7p0_cmass_dr11may   = sum_rand7/(float(n)*cmass_dr11may_data[:,3])

ratio_upw_v11p0_cmass_dr10v5    = sum_upw11/(float(n)*cmass_dr10v5_data[:,3])
ratio_rand_v11p0_cmass_dr10v5   = sum_rand11/(float(n)*cmass_dr10v5_data[:,3])
ratio_upw_v7p0_cmass_dr10v5     = sum_upw7/(float(n)*cmass_dr10v5_data[:,3])
ratio_rand_v7p0_cmass_dr10v5    = sum_rand7/(float(n)*cmass_dr10v5_data[:,3])
################################################################################################################
# wBOSS only and upweight comparison:
################################################################################################################
#fig1 = py.figure(1,figsize=(8,5))
#ax10 = fig1.add_subplot(111) 
#ax10.text(0.45,1.04,str(n)+' Mocks',fontsize=15)
#ax10.plot(x_axis,ratio_upw_wboss,'b',linewidth=2,
#        label=r'${\bar{n}(z)_{\rm{upweight}}}/{\bar{n}(z)_{w_{\rm{BOSS}}-only}}$')
#ax10.plot(x_axis,ratio_now_wboss,'m',linewidth=2,
#        label=r'${\bar{n}(z)_{\rm{noweight}}}/{\bar{n}(z)_{w_{\rm{BOSS}}-only}}$')
#ax10.set_xlim([0.43,0.7])
#ax10.set_ylim([0.95,1.05])
#ax10.set_xlabel('Redshift ($z$)',fontsize=14)
#ax10.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=14) 
#ax10.legend(loc='best')
################################################################################################################
# peak+nbar(z) corrected over uncorrected comparison: 
################################################################################################################
#fig2 = py.figure(2,figsize=(8,5))
#ax20 = fig2.add_subplot(111)
#ax20.text(0.45,1.04,str(n)+' Mocks',fontsize=15)
#ax20.plot(x_axis,ratio_peak_upw,'k',linewidth=2,
#        label=r'${\bar{n}(z)_{\rm{peak}+\bar{n}(z)}}/{\bar{n}(z)_{\rm{upweight}}}$')
#ax20.plot(x_axis,ratio_randp_rand,'r',linewidth=2,
#        label=r'${\bar{n}(z)_{\rm{rand},\rm{peak}+\bar{n}(z)}}/{\bar{n}(z)_{\rm{rand}}}$') 
#ax20.set_xlim([0.43,0.7])
#ax20.set_ylim([0.95,1.05])
#ax20.set_xlabel('Redshift ($z$)',fontsize=18)
#ax20.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=18) 
#ax20.legend(loc='best')
#ax20.grid()
################################################################################################################
# nbar(z) ratio for PTHalo mocks over CMASS: 
################################################################################################################
fig3 = py.figure(3,figsize=(9,7))
ax30 = fig3.add_subplot(111)
ax30.text(0.50,1.05,str(n)+' PTHalo v7.0, v11.0 North Mocks',fontsize=18)
#ax30.plot(x_axis,ratio_now_v11p0_cmass_dr11may,'k',linewidth=3,
#        label=r"${\bar{n}(z)_{\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR11May22}}}$") 
ax30.plot(x_axis,ratio_upw_v11p0_cmass_dr11may,'k',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v11.0}}}/{\bar{n}(z)_{\rm{CMASS-DR11May22}}}$") 
ax30.plot(x_axis,ratio_upw_v11p0_cmass_dr10v5,'k--',linewidth=2,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v11.0}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
ax30.plot(x_axis,ratio_upw_v7p0_cmass_dr11may,'m',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR11May22}}}$") 
ax30.plot(x_axis,ratio_upw_v7p0_cmass_dr10v5,'m--',linewidth=2,
        label=r"${\bar{n}(z)_{\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
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
ax40.text(0.50,1.05,str(n)+' PTHalo v7.0, v11.0 North Randoms',fontsize=18)
ax40.plot(x_axis,ratio_rand_v11p0_cmass_dr11may,'k',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v11.0.}}}/{\bar{n}(z)_{\rm{CMASS-DR11May22}}}$") 
ax40.plot(x_axis,ratio_rand_v11p0_cmass_dr10v5,'k--',linewidth=2,
        label=r"${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v11.0}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
ax40.plot(x_axis,ratio_rand_v7p0_cmass_dr11may,'m',linewidth=3,
        label=r"${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v7.0.}}}/{\bar{n}(z)_{\rm{CMASS-DR11May22}}}$") 
ax40.plot(x_axis,ratio_rand_v7p0_cmass_dr10v5,'m--',linewidth=2,
        label=r"${\bar{n}(z)_{\rm{rand},\rm{PTHalo-v7.0}}}/{\bar{n}(z)_{\rm{CMASS-DR10v5}}}$") 
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
ax50.text(0.45,1.02,str(n)+' PTHalo v7.0,v11.0 North Mocks+Randoms',fontsize=18)
ax50.plot(x_axis,ratio_rand_upw11,'k',linewidth=3,
        label=r'${\bar{n}(z)_{\rm{v11.0},\rm{rand},\rm{upweight}}}/{\bar{n}(z)_{\rm{v11.0},\rm{mock},\rm{upweighted}}}$') 
ax50.plot(x_axis,ratio_rand_upw7,'m',linewidth=3,
        label=r'${\bar{n}(z)_{\rm{v7.0},\rm{rand},\rm{upweight}}}/{\bar{n}(z)_{\rm{v7.0},\rm{mock},\rm{upweighted}}}$') 
ax50.set_xlim([0.43,0.7])
ax50.set_ylim([0.975,1.025])
ax50.set_xlabel('Redshift ($z$)',fontsize=18)
ax50.set_ylabel(r'$\bar{n}(z)_{\rm{norm}}$ Ratio',fontsize=18) 
ax50.legend(loc='best',prop={'size':16})
py.show()
