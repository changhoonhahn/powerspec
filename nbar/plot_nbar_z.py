import numpy as np
import pylab as py
import matplotlib.pyplot as plt

nbar_N_dr10v6=np.loadtxt('nbar-DR10_v6-N-Anderson.dat')
nbar_S_dr10v6=np.loadtxt('nbar-DR10_v6-S-Anderson.dat')
nbar_N_dr10v5=np.loadtxt('nbar-dr10v5-N-Anderson.dat')
nbar_S_dr10v5=np.loadtxt('nbar-dr10v5-S-Anderson.dat')

py.figure(1, figsize=(5,5))
py.title('nbar of DR10V6 and DR10V5',fontsize=20)
plt.plot(nbar_N_dr10v6[:,0],nbar_N_dr10v6[:,3],'b',linewidth=2,label='nbar N dr10v6')
plt.plot(nbar_S_dr10v6[:,0],nbar_S_dr10v6[:,3],'k',linewidth=2,label='nbar S dr10v6')
plt.plot(nbar_N_dr10v5[:,0],nbar_N_dr10v5[:,3],'r--',linewidth=3,label='nbar N dr10v5')
plt.plot(nbar_S_dr10v5[:,0],nbar_S_dr10v5[:,3],'m--',linewidth=3,label='nbar S dr10v5')
py.xlim([0.0,1.0])
py.ylim([0.0,0.001])
py.xlabel('Redshift (z)', fontsize=15)
py.ylabel('n bar', fontsize=15)
py.legend()
plt.show()
