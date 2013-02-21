import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate

will  = np.loadtxt('gCMASS_all.lpow')

path  = '/global/data/scr/chh327/powercode/power/'
#Nanderson = np.loadtxt(path+'cmass-dr10v3-N-Anderson_ge_POWER.dat')
#Nandersonw = np.loadtxt(path+'cmass-dr10v3-N-Anderson_POWER.dat')
#Sanderson = np.loadtxt(path+'cmass-dr10v3-S-Anderson_POWER.dat')

N_zlim_galsys=np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-zlim-960grid-480bin.dat')
#np.loadtxt(path+'cmass-dr10v5-N-Anderson_nzw_960_480_power.dat')

S_zlim_galsys=np.loadtxt(path+'power-cmass-dr10v5-S-Anderson-nzw-zlim-960grid-480bin.dat')
###################################################################################
#Power spectra Comparison

py.figure(1,figsize=(16,8))
#py.subplot(121)
plt.plot(np.log10(will[:,1]), np.log10(will[:,2]),'k--', linewidth=2, label="Percival's DR10 P(k)")
#plt.plot(np.log10(N[:,0]),np.log10(N[:,1]),'r', linewidth=3, label='P(k) for N-Anderson 960,480')
#plt.plot(np.log10(Nw[:,0]),np.log10(Nw[:,1]),'b--', linewidth=3, label='P(k) for N-Anderson 960,480 w_star')
#plt.plot(np.log10(Nmod[:,0]),np.log10(Nmod[:,1]),'r', linewidth=3, label='P(k) for N-Anderson 960,480')
plt.plot(np.log10(N_zlim_galsys[:,0]),np.log10(N_zlim_galsys[:,1]),'r',linewidth=3,label='P(k) N 960,480+nzw+Ngalsys+zlim')
#py.xlim([-2.3,0.0])
py.ylim([3.2,5.3])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)', fontsize=15)
plt.grid(True)
py.legend(loc='lower left', prop={'size':12})

py.figure(2,figsize=(16,8))
plt.plot(np.log10(will[:,1]), np.log10(will[:,2]),'k--', linewidth=2, label="Percival's DR10 P(k)")
plt.plot(np.log10(S_zlim_galsys[:,0]),np.log10(S_zlim_galsys[:,1]),'r',linewidth=3,label='P(k) S 960,480+nzw+Ngalsys+zlim')
py.ylim([3.2,5.3])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)', fontsize=15)
plt.grid(True)
py.legend(loc='lower left', prop={'size':12})
py.show()
"""
py.subplot(122)
plt.plot(np.log10(will[:,1]), np.log10(will[:,2]),'k--', linewidth=2, label="Percival's DR10 P(k)")
plt.plot(np.log10(S[:,0]),np.log10(S[:,1]),'g', linewidth=3, label='P(k) for S-Anderson 960,480')
plt.plot(np.log10(Sw[:,0]),np.log10(Sw[:,1]),'m--', linewidth=3, label='P(k) for S-Anderson 960,480 w_star')
py.xlim([-2.3,0.0])
py.ylim([3.2,5.3])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)', fontsize=15)
plt.grid(True)
py.legend(loc='lower left', prop={'size':12})

py.figure(2,figsize=(16,8))
intpolNw = interpolate.interp1d(Nw[:,0],Nw[:,1],kind='quadratic')(N[:,0])
intpolSw = interpolate.interp1d(Sw[:,0],Sw[:,1],kind='quadratic')(S[:,0])

py.subplot(121)
plt.plot(np.log10(N[:,0]),intpolNw/N[:,1],linewidth=3,label='N-Anderson 960,480')
py.xlim([-2.3,0.0])
py.ylim([0.75,1.10])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)-wstar/P(k)',fontsize=15)
py.legend(loc='lower right', prop={'size':12})

py.subplot(122)
plt.plot(np.log10(S[:,0]),intpolSw/S[:,1],linewidth=3,label='S-Anderson 960,480')
py.xlim([-2.3,0.0])
py.ylim([0.75,1.10])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)-wstar/P(k)',fontsize=15)
py.legend(loc='lower right', prop={'size':12})

py.show()
###################################################################################
#Anisotropy of NS

py.figure(2,figsize=(8,8))
py.subplot(311)
plt.plot(NS[:,0],NS[:,5]/NS[:,4], label='dr10v3-NS')
py.ylabel('P_w^(2)/P_w^(0)',fontsize=15)
py.legend(loc='upper right', prop={'size':12})

py.subplot(312)
plt.plot(NS[:,0],np.log10(NS[:,5]))
py.ylabel('log(P_w^2(k))',fontsize=15)

py.subplot(313)
plt.plot(NS[:,0],np.log10(NS[:,4]))
py.xlabel('k',fontsize=15)
py.ylabel('log(P_w^0(k))',fontsize=15)
py.legend(loc='lower left', prop={'size':12})
###################################################################################
#Anisotropy of North

py.figure(3,figsize=(8,8))
py.subplot(311)
py.title('DR10v5-North_960_480 (Rotated)')
plt.plot(N[:,0],N[:,5]/N[:,4],c='k',label='dr10v5-N')
plt.plot(Nrot[:,0],Nrot[:,5]/Nrot[:,4],c='m',label='dr10v5-N-rotated')
py.ylabel('P_w^(2)/P_w^(0)',fontsize=15)
py.legend(loc='upper right', prop={'size':12})

py.subplot(312)
plt.plot(N[:,0],np.log10(N[:,5]),c='k')
plt.plot(Nrot[:,0],np.log10(Nrot[:,5]),c='m')
py.ylabel('log(P_w^2(k))',fontsize=15)

py.subplot(313)
plt.plot(N[:,0],np.log10(N[:,4]),c='k')
plt.plot(Nrot[:,0],np.log10(Nrot[:,4]),c='m')
py.xlabel('k',fontsize=15)
py.ylabel('log(P_w^0(k))',fontsize=15)
py.legend(loc='lower left', prop={'size':12})
###################################################################################
#Anistropy of South

py.figure(4,figsize=(8,8))
py.subplot(311)
py.title('DR10v5-South_960_480 (Rotated)')
plt.plot(S[:,0],S[:,5]/S[:,4],c='k',label='dr10v5-S')
plt.plot(Srot[:,0],Srot[:,5]/Srot[:,4],c='m',label='dr10v5-S-rotated')
py.ylabel('P_w^(2)/P_w^(0)',fontsize=15)
py.legend(loc='upper right', prop={'size':12})

py.subplot(312)
plt.plot(S[:,0],np.log10(S[:,5]),c='k')
plt.plot(Srot[:,0],np.log10(Srot[:,5]),c='m')
py.ylabel('log(P_w^2(k))',fontsize=15)

py.subplot(313)
plt.plot(S[:,0],np.log10(S[:,4]),c='k')
plt.plot(Srot[:,0],np.log10(Srot[:,4]),c='m')
py.xlabel('k',fontsize=15)
py.ylabel('log(P_w^0(k))',fontsize=15)
py.legend(loc='lower left', prop={'size':12})
"""