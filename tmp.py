import numpy as np
import pylab as py

cmass = np.loadtxt('cmass-dr10-N.dat')
mock=np.loadtxt('sdssmock_cmass_radecmask.dat')
	
py.figure()
py.scatter(mock[:,0], mock[:,1], label='RA Dec Mask')
py.scatter(cmass[:,0],cmass[:,1],c='k', label='CMASS DR10 N')
py.xlabel('RA')
py.ylabel('Dec')
#py.scatter(rand[:,0], rand[:,1], label='Random')
py.legend()
py.show()
