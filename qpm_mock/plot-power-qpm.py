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
n = 0
#nrange = range(1,1001)
#nrange = range(1,501)+range(601,1001)
nrange = range(1,542)+[543]+range(545,1000)
#nrange = range(1,543)+range(545,1001)
for i in nrange:
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

n = len(files)
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
    if mock[0,1] > 10**6:
        print 'Unusual P(k),', i, mock[0,1]
    if i==files[0]:
        mock_tot = mock[:,1]
        mock_k = mock[:,0]
    else:
        mock_tot = mock_tot + mock[:,1]
print n
mock_avg = mock_tot/float(n)
ax11.loglog( mock_k, mock_avg, color='b', linewidth=2, label=r"$\overline{P(k)}$ for QPM Mocks NGC")

cmass_data = np.loadtxt("/mount/riachuelo1/hahn/power/power-cmass-dr10v8-N-Anderson-nzw-zlim-ngalsys-360bin-180bin.dat")
ax11.loglog( cmass_data[:,0], cmass_data[:,1], color='r', linewidth=2, label=r"$P(k)$ for CMASS DR10v8 North" )

ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**3,10**6.0])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':15})
ax11.grid(True)

figdir = '/home/users/hahn/figures/boss/powerspectrum/qpm_mock/'
fig1.savefig(figdir+'cmass-dr10v8-N-qpmmock-1_1000-minus542_544-pbar.png')
#py.show()
