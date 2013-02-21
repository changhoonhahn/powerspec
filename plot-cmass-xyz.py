import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from matplotlib import cm

path='/mount/chichipio2/hahn/data/'
gal=np.loadtxt(path+'cmass-dr10v5-N-xyz.dat')
rand=np.loadtxt(path+'cmass-dr10v5-N-xyz.ran.dat')

fig1 = plt.figure(1)
ax1 = fig1.add_subplot(111, projection='3d')
plotz=ax1.scatter(gal[:,0],gal[:,1],gal[:,2],c='b')
plotzz=ax1.scatter(rand[:,0],rand[:,1],rand[:,2],c='r')
ax1.set_xlabel('x')
ax1.set_ylabel('y')
ax1.set_zlabel('z')

plt.show()
