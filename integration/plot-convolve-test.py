import numpy as np
import pylab as py


data = np.loadtxt('testingtesting.dat')

py.figure()
py.plot(data[:,0],data[:,1],'b',linewidth=3,label='Convolution of two Gaussians')
py.plot(data[:,0],data[:,2],'k--',linewidth=3,label='Gaussian')
py.xlim([-10.0,10.0])
py.legend(loc='upper left')
py.show()
