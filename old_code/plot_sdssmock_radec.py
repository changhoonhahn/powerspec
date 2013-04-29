import numpy as np
import pylab as py
import matplotlib.pyplot as plt

cmass = np.loadtxt('/global/data/scr/chh327/powercode/sdssmock_gamma_lrgFull_zm_oriana01a_no.real.rdcz.dat')
radecmask = np.loadtxt('sdssmock_cmass_radecmask.dat')

py.figure() 
py.scatter(cmass[:,0], cmass[:,1],'k')
py.scatter(radecmask[:,0], radecmask[:,1],'b')
py.title('SDSS MOCK DATA RA DEC', fontsize =15)
py.xlabel('RA', fontsize=15)
py.ylabel('Dec', fontsize=15)

py.show()
