import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate

will  = np.loadtxt('gCMASS_all.lpow')
path  = '/global/data/scr/chh327/powercode/power/'
#Nanderson = np.loadtxt(path+'cmass-dr10v3-N-Anderson_ge_POWER.dat')
#Nandersonw = np.loadtxt(path+'cmass-dr10v3-N-Anderson_POWER.dat')
#Sanderson = np.loadtxt(path+'cmass-dr10v3-S-Anderson_POWER.dat')

NS = np.loadtxt(path+'cmass-dr10v3-NS-Anderson_nzw_power_960_1920.dat')
Nrot = np.loadtxt(path+'cmass-dr10v5-N-Anderson_rot_nzw_power.dat')
Nbig = np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-1536grid-768bin.dat')
N = np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-1536grid-768bin-chichipio.dat')
#np.loadtxt(path+'cmass-dr10v5-N-Anderson_nzw_960_480_power.dat')

Srot = np.loadtxt(path+'cmass-dr10v5-S-Anderson_rot_nzw_power.dat')
S = np.loadtxt(path+'POWER-cmass-dr10v5-S-Anderson-wcomp-80000p0-960grid-480bin.dat')
###################################################################################
#Power spectra Comparison

py.figure(1,figsize=(8,8))
py.plot
plt.plot(np.log10(will[:,1]), np.log10(will[:,2]),'k--', linewidth=2, label="Percival's DR10 P(k)")
plt.plot(np.log10(N[:,0]),np.log10(N[:,1]),'r', linewidth=3, label='P(k) for N-Anderson_1536_768-chichipio (P0=20000)')
plt.plot(np.log10(Nbig[:,0]),np.log10(Nbig[:,1]),'b--', linewidth=3, label='P(k) for N-Anderson_1536_768 (P0=20000)')
py.xlim([-2.3,0.0])
py.ylim([3.2,5.3])
py.xlabel('k', fontsize=15)
py.ylabel('P(k)', fontsize=15)
plt.grid(True)
py.legend(loc='lower left', prop={'size':12})
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
py.show()

