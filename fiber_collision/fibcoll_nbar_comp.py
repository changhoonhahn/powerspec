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
for i in range(1,11): 
    fname_std   = 'nbar_'+name0+str(i+1000)[1:4]+nameend
    fname_upw   = 'nbar_upweighted_'+name0+str(i+1000)[1:4]+nameend
    fname_shfl  = 'nbar_shuffle_zlim_'+name0+str(i+1000)[1:4]+nameend

    data_std    = np.loadtxt(dir+fname_std)
    data_upw    = np.loadtxt(dir+fname_upw)
    data_shfl   = np.loadtxt(dir+fname_shfl)

    if i==1: 
        x_axis  = data_std[:,0]
        sum_std = data_std[:,3]
        sum_upw = data_upw[:,3]
        sum_shfl= data_shfl[:,3]
    else: 
        sum_std = sum_std+data_std[:,3]
        sum_upw = sum_upw+data_upw[:,3]
        sum_shfl= sum_shfl+data_shfl[:,3]

ratio_upw_std   = sum_upw/sum_std
ratio_shfl_std  = sum_shfl/sum_std

fig1 = py.figure(1,figsize=(8,5)) 
ax10 = fig1.add_subplot(111) 
ax10.plot(x_axis,sum_upw,'b',linewidth=2,label='Up weighted') 
ax10.plot(x_axis,sum_std,'k--',linewidth=2,label='No weights') 
ax10.scatter(x_axis,sum_shfl,color='g',label='Shuffle')
ax10.set_xlim([0.4,0.75])
ax10.set_xlabel('Redshift ($z$)',fontsize=14) 
ax10.set_ylabel('$\overline{n}(z)$',fontsize=14)
ax10.legend(loc='best') 

fig2 = py.figure(2,figsize=(8,5))
ax20 = fig2.add_subplot(111)
ax20.plot(x_axis,ratio_upw_std,'b',linewidth=2,label='${\overline{n}(z)_{upweight}}/{\overline{n}(z)_{noweight}}$')
ax20.plot(x_axis,ratio_shfl_std,'g',linewidth=2,label='${\overline{n}(z)_{shuffle}}/{\overline{n}(z)_{noweight}}$')
ax20.set_xlim([0.43,0.7])
ax20.set_ylim([0.5,1.5])
ax20.set_xlabel('Redshift ($z$)',fontsize=14)
ax20.set_ylabel('$\overline{n}(z)$ Ratio',fontsize=14) 
ax20.legend(loc='best')
py.show()
