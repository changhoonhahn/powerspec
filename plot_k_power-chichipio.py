import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate

will  = np.loadtxt('gCMASS_all.lpow')

path = '/mount/chichipio2/hahn/power/'

N = np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-960grid-480bin.dat')
Nzlim = np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-zlim-960grid-480bin.dat')
Nzlimngalsys = np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-zlim-ngalsys-960grid-480bin.dat')

###################################################################################
#Power spectra Comparison

py.figure(1,figsize=(16,8))
plt.plot(np.log10(will[:,1]), np.log10(will[:,2]),'k--', linewidth=2, label="Percival's DR10 P(k)")
#plt.plot(np.log10(N[:,0]),np.log10(N[:,1]),'r', linewidth=3, label='P(k) for N-Anderson 960,480')
plt.plot(np.log10(Nzlimngalsys[:,0]),np.log10(Nzlimngalsys[:,1]),'b--', linewidth=3, label='P(k) for N-Anderson 960,480 Original Assign+Ngalsys+z-lim')
plt.plot(np.log10(Nzlim[:,0]),np.log10(Nzlim[:,1]),'r--', linewidth=3, label='P(k) for N-Anderson 960,480 Original Assign+z-lim')

#plt.plot(np.log10(N[:,0]),np.log10(N[:,4]),'g', linewidth=3, label='P_r(k) for N-Anderson 960,480')
#plt.plot(np.log10(Nmod[:,0]),np.log10(Nmod[:,1]),'b--', linewidth=3, label='P(k) for N-Anderson 960,480 Modified Power code')
#py.xlim([-2.3,0.0])
#py.ylim([3.2,5.3])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)', fontsize=15)
plt.grid(True)
py.legend(loc='lower left', prop={'size':12})


py.figure(2,figsize=(16,8))
intpolwill = interpolate.interp1d(will[:,1],will[:,2],kind='quadratic')(Nzlim[:,0])
#intpolSw = interpolate.interp1d(Sw[:,0],Sw[:,1],kind='quadratic')(S[:,0])

#py.subplot(121)
plt.plot(np.log10(Nzlim[:,0]),intpolwill/Nzlim[:,1],linewidth=3,label='N-Anderson 960,480')
py.xlim([-2.3,0.0])
#py.ylim([0.75,1.10])
py.xlabel('k', fontsize=15)
py.ylabel("(Will's P(k))/(P(k),original assign,z-lim",fontsize=15)
py.legend(loc='lower right', prop={'size':12})
py.show()
"""
py.subplot(122)
plt.plot(np.log10(S[:,0]),intpolSw/S[:,1],linewidth=3,label='S-Anderson 960,480')
py.xlim([-2.3,0.0])
py.ylim([0.75,1.10])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)-wstar/P(k)',fontsize=15)
py.legend(loc='lower right', prop={'size':12})

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
