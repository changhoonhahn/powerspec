import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm

path='/mount/chichipio2/hahn/FFT/'
fname='cmass-dr10v5-N-Anderson-nzw-10grid-ngalsys-cic'
dcg=np.loadtxt(path+fname+'-dcg.dat')
dcr=np.loadtxt(path+fname+'-dcr.dat')

fig1 = plt.figure(1)
plt.suptitle('DCG',fontsize=20)
ax1 = fig1.add_subplot(111, projection='3d')
plotz=ax1.scatter(dcg[:,0],dcg[:,1],dcg[:,2],c=dcg[:,3],cmap=cm.jet)
ax1.set_xlabel('ix')
ax1.set_ylabel('iy')
ax1.set_zlabel('iz')
fig1.colorbar(plotz, shrink=0.5,aspect=5)

Ngal=428201
Ngalsys=460041.5
gfrac = Ngalsys/float(20833071)
fig2 = plt.figure(2)
plt.suptitle('DCR',fontsize=20)
ax2 = fig2.add_subplot(111,projection='3d')
plotzz=ax2.scatter(dcr[:,0],dcr[:,1],dcr[:,2],c=gfrac*dcr[:,3],cmap=cm.jet)
ax2.set_xlabel('ix')
ax2.set_ylabel('iy')
ax2.set_zlabel('iz')
fig2.colorbar(plotzz, shrink=0.5,aspect=5)

fig3 = plt.figure(3)
plt.suptitle('DGR/DCR-1',fontsize=20)
ax3 = fig3.add_subplot(111,projection='3d')
y=dcg[:,3]/(gfrac*dcr[:,3])-1.0
for i in range(len(y)):
    if dcr[i,3] == 0:
        y[i]=0.0

print sum(y)
print sum(dcg[:,3]-gfrac*dcr[:,3])/sum(gfrac*dcr[:,3])
plotzzz=ax3.scatter(dcr[:,0],dcr[:,1],dcr[:,2],c=y,cmap=cm.jet)
ax3.set_xlabel('ix')
ax3.set_ylabel('iy')
ax3.set_zlabel('iz')
fig3.colorbar(plotzzz, shrink=0.5,aspect=5)
plt.show()
