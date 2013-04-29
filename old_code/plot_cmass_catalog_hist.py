import numpy as np
import pylab as py

mock = np.loadtxt('cmass_catalog_hist_actual.dat')
actual = np.loadtxt('cmass_catalog_hist_mock.dat')
rand = np.loadtxt('cmass_catalog_hist_rand.dat')

py.figure()
py.subplot(211)
#py.plot(rand[:,0], rand[:,1], 'k--', label='CMASS Random')
py.plot(mock[:,0], mock[:,1], 'b', label='CMASS')
py.plot(actual[:,0], actual[:,1], 'r', label='SDSS Mock Data')
py.ylabel('n(z)') 
py.legend()

py.subplot(212)
py.plot(rand[:,0], rand[:,2], 'k--',linewidth=4, label='CMASS Random')
py.plot(mock[:,0], mock[:,2], 'b', label='CMASS')
py.plot(actual[:,0], actual[:,2], 'r', label='SDSS Mock Data')
py.xlabel('Redshift (z)')
py.ylabel('n(z)/n_tot')
py.legend()
py.show()
