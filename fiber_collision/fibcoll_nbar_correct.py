import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'

name0   = 'cmass_dr11_north_ir4'
nameend = '.v7.0.wghtv.txt'
for i in range(1,26): 
    fname_wboss = 'nbar_wboss_'+name0+str(i+1000)[1:4]+nameend
    fname_upw   = 'nbar_upweighted_'+name0+str(i+1000)[1:4]+nameend
    fname_shfl  = 'nbar_shuffle_zlim_'+name0+str(i+1000)[1:4]+nameend

    data_wboss  = np.loadtxt(dir+fname_wboss)
    data_upw    = np.loadtxt(dir+fname_upw)
    data_shfl   = np.loadtxt(dir+fname_shfl)

    if i==1: 
        x_axis      = data_wboss[:,0]
        sum_wboss   = data_wboss[:,3]
        sum_upw     = data_upw[:,3]
        sum_shfl    = data_shfl[:,3]
    else: 
        sum_wboss   = sum_wboss+data_wboss[:,3]
        sum_upw     = sum_upw+data_upw[:,3]
        sum_shfl    = sum_shfl+data_shfl[:,3]

ratio_upw_wboss     = sum_upw/sum_wboss
ratio_shfl_wboss    = sum_shfl/sum_wboss
ratio_shfl_upw      = sum_shfl/sum_upw

for i in range(len(ratio_shfl_wboss)): 
    if x_axis[i] < 0.43 or x_axis[i] > 0.7: 
        ratio_shfl_wboss[i] = 1.0

pthalo_fname    = 'nbar-cmass-dr11may22-N-Anderson'
pthalo_data     = np.loadtxt(dir+pthalo_fname+'.dat')

pthalo_data[:,3] = ratio_shfl_wboss*pthalo_data[:,3]

corrected_fname = pthalo_fname+'-dlosshuffle-corrected'
np.savetxt(dir+corrected_fname+'.dat',pthalo_data)

#fig1 = py.figure(1) 
#ax01 = fig1.add_subplot(111) 
#ax01.plot(x_axis, ratio_shfl_upw)
#ax01.set_xlim([0.43,0.7])
#ax01.set_ylim([0.8,1.2])
#py.show()
