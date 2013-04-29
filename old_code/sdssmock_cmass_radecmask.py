import numpy as np
import pylab as py
import matplotlib.pyplot as plt

cmass = np.loadtxt('cmass-dr10-N.dat')
sdssmock = np.loadtxt('sdssmock_cmass_radecmask.dat')

py.figure()
py.scatter(sdssmock[:,0], sdssmock[:,1], c='b')
py.scatter(cmass[:,0], cmass[:,1], c='k')
py.xlabel('RA', fontsize = 15)
py.ylabel('Dec', fontsize = 15)


py.show() 
