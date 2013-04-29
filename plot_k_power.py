import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate
from matplotlib import rc

newwill = np.loadtxt('gCMASS_Pf20000_all.lpow')

path  = '/global/data/scr/chh327/powercode/power/'

N_zlim_galsys=np.loadtxt(path+'power-cmass-dr10v5-N-Anderson-nzw-zlim-960grid-480bin.dat')
N_fran=np.loadtxt(path+'ps_cmass-dr10v5-N-Anderson.4000.1200.500.pw20000.masTSC.corr2.dat')
N_dr10v6=np.loadtxt(path+'power-CMASS-DR10_v6-N-Anderson-nzw-zlim-960grid-480bin.dat')
N_gI22=np.loadtxt(path+'power-CMASS-DR10_v6-N-Anderson-nzw-zlim-gI22-960grid-480bin.dat')

S_zlim_galsys=np.loadtxt(path+'power-cmass-dr10v5-S-Anderson-nzw-zlim-960grid-480bin.dat')
S_fran=np.loadtxt(path+'ps_cmass-dr10v5-S-Anderson.4000.1200.500.pw20000.masTSC.corr2.dat')
S_dr10v6=np.loadtxt(path+'power-CMASS-DR10_v6-S-Anderson-nzw-zlim-960grid-480bin.dat')
S_gI22=np.loadtxt(path+'power-CMASS-DR10_v6-S-Anderson-nzw-zlim-gI22-960grid-480bin.dat')

full_zlim_galsys=np.loadtxt(path+'power-cmass-dr10v5-full-Anderson-nzw-zlim-960grid-480bin.dat')
full_wstaronly=np.loadtxt(path+'power-cmass-dr10v5-full-Anderson-nzw-zlim-wstaronly-960grid-480bin.dat')
full_fran=np.loadtxt(path+'ps_cmass-dr10v5-full-Anderson.4000.1200.500.pw20000.masTSC.corr2.dat')
full_dr10v6=np.loadtxt(path+'power-CMASS-DR10_v6-full-Anderson-nzw-zlim-960grid-480bin.dat')
full_cic=np.loadtxt(path+'power-CMASS-DR10_v6-full-Anderson-nzw-zlim-cicassign-960grid-480bin.dat')
full_gI22=np.loadtxt(path+'power-CMASS-DR10_v6-full-Anderson-nzw-zlim-gI22-960grid-480bin.dat')
###################################################################################
#Power spectra Comparison

rc('text', usetex=True)
rc('font', family='serif')

py.figure(1,figsize=(10,10))
#plt.loglog(newwill[:,1],newwill[:,2],'k',linewidth=1, label="Will's P(k) Version 1920")
plt.loglog(N_zlim_galsys[:,0],N_zlim_galsys[:,1],'r',linewidth=1,label=r'$P(k)$ dr10v5 N 960,480+nzw+Ngalsys+zlim')
plt.loglog(N_dr10v6[:,0],N_dr10v6[:,1],'c',linewidth=3,label=r'$P(k)$ dr10v6 N 960,480+nzw+Ngalsys+zlim')
plt.loglog(N_gI22[:,0],N_gI22[:,1],'m',linewidth=3,label=r'$P(k)$ dr10v6 N 960,480+nzw+Ngalsys+zlim+gI22')
plt.loglog(N_fran[:,0],N_fran[:,1],'b--',linewidth=1,label=r'$P(k)$ dr10v5 N Francesco')
py.xlim([10**-3,10**0])
py.ylim([10**3,10**5.2])
py.xlabel(r'$\bf{k}$', fontsize=20)
py.ylabel(r'$\bf{P(k)}$', fontsize=20)
plt.grid(True)
py.legend(loc='lower left', prop={'size':12})

py.figure(2,figsize=(10,10))
#plt.loglog(newwill[:,1], newwill[:,2],'k', linewidth=1, label="Percival's DR10 P(k) Version 1920")
plt.loglog(S_zlim_galsys[:,0],S_zlim_galsys[:,1],'r',linewidth=1,label='P(k) S 960,480+nzw+Ngalsys+zlim')
plt.loglog(S_dr10v6[:,0],S_dr10v6[:,1],'c',linewidth=3,label='P(k) dr10v6 S 960,480+nzw+Ngalsys+zlim')
plt.loglog(S_gI22[:,0],S_gI22[:,1],'m',linewidth=3,label='P(k) dr10v6 S 960,480+nzw+Ngalsys+zlim+gI22')
plt.loglog(S_fran[:,0],S_fran[:,1],'b--',linewidth=1,label='P(k) dr10v5 S Francesco')
py.xlim([10**-3,10**0])
py.ylim([10**3,10**5.2])
py.xlabel(r'$k$', fontsize=20)
py.ylabel(r'$P(k)$', fontsize=20)
plt.grid(True)
py.legend(loc='lower left', prop={'size':12})

py.figure(3,figsize=(10,10))
#plt.loglog(newwill[:,1],newwill[:,2],'k', linewidth=1, label="Percival's DR10 P(k) Version 1920")
#plt.loglog(full_zlim_galsys[:,0],full_zlim_galsys[:,1],'r',linewidth=1,label='P(k) dr10v5 full 960,480+nzw+Ngalsys+zlim')
plt.loglog(full_dr10v6[:,0],full_dr10v6[:,1],'c',linewidth=3,label='P(k) dr10v6 full 960,480+nzw+Ngalsys+zlim')
plt.loglog(full_cic[:,0],full_cic[:,1],'r--',linewidth=3,label='P(k) dr10v6 full 960,480+nzw+Ngalsys+zlim+cic')
#plt.loglog(full_gI22[:,0],full_gI22[:,1],'m',linewidth=3,label='P(k) dr10v6 full 960,480+nzw+Ngalsys+zlim+gI22')
plt.loglog(full_fran[:,0],full_fran[:,1],'b--',linewidth=1,label='P(k) dr10v5 full Francesco')
py.xlim([10**-3,10**0])
py.ylim([10**3,10**5.2])
py.xlabel(r'$k$', fontsize=20)
py.ylabel(r'$P(k)$', fontsize=20)
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

py.figure(4,figsize=(16,8))
intpolwill = interpolate.interp1d(newwill[:,1],newwill[:,2],kind='quadratic')(full_gI22[:,0])
#intpolfran = interpolate.interp1d(full_fran[:,0],full_fran[:,1],kind='quadratic')(full_zlim_galsys[:,0])

#py.subplot(121)
plt.plot(np.log10(full_gI22[:,0]),intpolwill/full_gI22[:,1],linewidth=3,label='full.960,480.')
#py.xlim([-2.3,0.0])
py.ylim([0.0,2.0])
py.xlabel('k', fontsize=15)
py.ylabel("(Will's P(k))/(P(k) full-dr10v6.960,480.Ngalsys.z-lim.gI22)",fontsize=15)
py.legend(loc='lower right', prop={'size':12})
py.show()

py.subplot(122)
plt.plot(np.log10(full_zlim_galsys[:,0]),intpolfran/full_zlim_galsys[:,1],linewidth=3,label='full.960,480')
#py.xlim([-2.3,0.0])
py.ylim([0.0,2.0])
py.xlabel('k', fontsize=15)
py.ylabel("(Francesco's P(k))/(P(k) full-dr10v5.960,480.Ngalsys.z-lim)",fontsize=15)
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
