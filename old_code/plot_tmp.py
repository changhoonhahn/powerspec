import numpy as np
import pylab as py

data=np.loadtxt('nbar-cmass-dr10v2-N.dat')

py.figure()
py.plot(data[:,0], data[:,3])
py.xlabel('Redshift (z)')
py.ylabel('Nbar')
py.ylim([0.0, 0.001])
py.show()
