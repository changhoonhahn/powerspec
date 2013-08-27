import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
n   = int(sys.argv[1])

name0   = 'cmass_dr11_north_ir4'
nameend = '.v7.0.wghtv.txt'
for i in range(1,n+1): 
    fname_wboss = 'nbar_wboss_'+name0+str(i+1000)[1:4]+nameend
    fname_upw   = 'nbar_upweighted_'+name0+str(i+1000)[1:4]+nameend
    fname_peak  = 'nbar_'+name0+str(i+1000)[1:4]+'.v7.0.peakcorr.txt'
    fname_rand  = 'nbar_cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+'_peak_nbar_corr.v7.0.wghtv.txt'

    data_wboss  = np.loadtxt(dir+fname_wboss)
    data_upw    = np.loadtxt(dir+fname_upw)
    data_peak   = np.loadtxt(dir+fname_peak)
    data_rand   = np.loadtxt(dir+fname_rand)

    if i==1: 
        x_axis      = data_wboss[:,0]
        sum_wboss   = data_wboss[:,3]
        sum_upw     = data_upw[:,3]
        sum_peak    = data_peak[:,3]
        sum_rand    = data_rand[:,3]
    else: 
        sum_wboss   = sum_wboss+data_wboss[:,3]
        sum_upw     = sum_upw+data_upw[:,3]
        sum_peak    = sum_peak+data_peak[:,3]
        sum_rand    = sum_rand+data_rand[:,3]

ratio_upw_wboss     = sum_upw/sum_wboss
ratio_peak_wboss    = sum_peak/sum_wboss
ratio_peak_upw      = sum_peak/sum_upw

for i in range(len(ratio_peak_wboss)): 
    if x_axis[i] < 0.43 or x_axis[i] > 0.7: 
        ratio_peak_wboss[i] = 1.0

pthalo_fname    = 'nbar-cmass-dr11may22-N-Anderson'
pthalo_data     = np.loadtxt(dir+pthalo_fname+'.dat')

pthalo_data[:,3] = ratio_peak_wboss*pthalo_data[:,3]

corrected_fname = dir+pthalo_fname+'-peaknbar-corrected.dat'
#corrected_file  = open(corrected_fname,'w')
#for i in range(len(pthalo_data[:,3])): 
#    corrected_file.write(str(pthalo_data[i,0])+'\t'+str(pthalo_data[i,1])+'\t'+str(pthalo_data[i,2])+'\t'+str(pthalo_data[i,3])+'\n')
#np.savetxt(dir+corrected_fname+'.dat',pthalo_data)
#exit()

fig1 = py.figure(1)
ax10 = fig1.add_subplot(111)
ax10.plot(x_axis,ratio_peak_wboss)

py.show()
