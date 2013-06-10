import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/qpm_mock/'

fname0 = 'power-a0.6452_'
fname1 = '.dr10_ngc.rdzw'

fig1 = plt.figure(1, figsize=(7,8))
ax11 = fig1.add_subplot(111)

files=[]
for i in range(1,1001):
    if i < 10:
        mockname = fname0+'000'+str(i)+fname1+'_weight.grid360.P020000.box4000'
    elif i < 100:
        mockname = fname0+'00'+str(i)+fname1+'_weight.grid360.P020000.box4000'
    elif i < 1000:
        mockname = fname0+'0'+str(i)+fname1+'_weight.grid360.P020000.box4000'
    else:
        mockname = fname0+str(i)+fname1+'_weight.grid360.P020000.box4000'
    try:
        with open(dir+mockname):
            files.append(i)
    except IOError:
        print 'file ',i,' does not exist.'


for i in files:
    if i < 10:
        mockname = fname0+'000'+str(i)+fname1+'_weight.grid360.P020000.box4000'
    elif i < 100:
        mockname = fname0+'00'+str(i)+fname1+'_weight.grid360.P020000.box4000'
    elif i < 1000:
        mockname = fname0+'0'+str(i)+fname1+'_weight.grid360.P020000.box4000'
    else:
        mockname = fname0+str(i)+fname1+'_weight.grid360.P020000.box4000'

    mock = np.loadtxt(dir+mockname)
#    ax11.loglog( mock[:,0], mock[:,1], 'k--', linewidth=1 )
    if i==1:
        mock_tot = mock[:,1]
        mock_k = mock[:,0]
    else:
        mock_tot = mock_tot + mock[:,1]

mock_avg = mock_tot/float(i)
ax11.loglog( mock_k, mock_avg, color='b', linewidth=2, label=r"$\overline{P(k)}$ for QPM Mocks NGC")

cmass_data = np.loadtxt("/mount/riachuelo1/hahn/power/power-cmass-dr10v8-N-Anderson-nzw-zlim-ngalsys-360bin-180bin.dat")
ax11.loglog( cmass_data[:,0], cmass_data[:,1], color='r', linewidth=2, label=r"$P(k)$ for CMASS DR10v8 North" )

ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**3,10**6.0])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':15})
ax11.grid(True)

py.show()
