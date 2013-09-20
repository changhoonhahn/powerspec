import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
n   = int(sys.argv[1])

name0   = 'cmass_dr11_north_ir4'
nameend = '.v7.0.'
for i in range(1,n+1): 
    fname_wboss = 'nbar-normed-'+name0+str(i+1000)[1:4]+nameend+'wboss.txt'
    fname_upw   = 'nbar-normed-'+name0+str(i+1000)[1:4]+nameend+'upweight.txt'
    fname_peak  = 'nbar-normed-'+name0+str(i+1000)[1:4]+nameend+'peakcorr.txt'
    fname_rand  = 'nbar-normed-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameend+'wghtv.txt'
    fname_randp = 'nbar-normed-cmass_dr11_north_randoms_ir4'+str(i+1000)[1:4]+nameend+'peakcorr.txt'

    data_wboss  = np.loadtxt(dir+fname_wboss)
    data_upw    = np.loadtxt(dir+fname_upw)
    data_peak   = np.loadtxt(dir+fname_peak)
    data_rand   = np.loadtxt(dir+fname_rand)
    data_randp  = np.loadtxt(dir+fname_randp)

    if i==1: 
        x_axis      = data_wboss[:,0]
        sum_wboss   = data_wboss[:,3]
        sum_upw     = data_upw[:,3]
        sum_peak    = data_peak[:,3]
        sum_rand    = data_rand[:,3]
        sum_randp   = data_randp[:,3]
    else: 
        sum_wboss   = sum_wboss+data_wboss[:,3]
        sum_upw     = sum_upw+data_upw[:,3]
        sum_peak    = sum_peak+data_peak[:,3]
        sum_rand    = sum_rand+data_rand[:,3]
        sum_randp   = sum_randp+data_randp[:,3]
ratio_peak_upw      = sum_peak/sum_upw

for i in range(len(ratio_peak_upw)): 
    if x_axis[i] < 0.43 or x_axis[i] > 0.7: 
        ratio_peak_upw[i] = 1.0

pthalo_fname    = 'nbar-dr10v5-N-Anderson'
pthalo_data     = np.loadtxt(dir+pthalo_fname+'.dat')

pthalo_data[:,3] = ratio_peak_upw*pthalo_data[:,3]

corrected_fname = pthalo_fname+'-peaknbarcorr.dat'
corrected_file  = open(dir+corrected_fname,'w')
for i in range(len(pthalo_data[:,3])): 
    corrected_file.write(str(pthalo_data[i,0])+'\t'+str(pthalo_data[i,1])+'\t'+str(pthalo_data[i,2])+'\t'+str(pthalo_data[i,3])+'\n')
exit()
