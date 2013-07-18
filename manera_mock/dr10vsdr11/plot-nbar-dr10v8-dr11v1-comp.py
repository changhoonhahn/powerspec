import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
from scipy.integrate import simps
rc('text', usetex=True)
rc('font', family='serif')

prismdir = "/global/data/scr/chh327/powercode/data/"

nbar_dr10v8 = np.loadtxt(prismdir+'nbar-cmass-dr10v8-S-Anderson.dat')
nbar_dr11v0 = np.loadtxt(prismdir+'nbar-cmass-dr11v0-S-Anderson.dat')
nbar_dr11v1 = np.loadtxt(prismdir+'nbar-cmass-dr11v1-S-Anderson.dat')

fig1 = py.figure(1)
ax00 = fig1.add_subplot(111)

ax00.plot( nbar_dr10v8[:,0], nbar_dr10v8[:,3], 'k', linewidth=2, label=r"$\bar{n}(z)$ for DR10v8 SGC" )
ax00.plot( nbar_dr11v0[:,0], nbar_dr11v0[:,3], 'm', linewidth=2, label=r"$\bar{n}(z)$ for DR11v0 SGC" )
ax00.plot( nbar_dr11v1[:,0], nbar_dr11v1[:,3], 'b--', linewidth=2, label=r"$\bar{n}(z)$ for DR11v1 SGC" )

ax00.set_xlim([0.3,0.8])
ax00.set_ylim([0.0,0.0005])
ax00.legend(loc='upper right')

py.show()
