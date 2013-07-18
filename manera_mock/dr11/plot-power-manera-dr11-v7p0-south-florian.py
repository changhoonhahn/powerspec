import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'

fname0 = 'power_cmass_dr11_south_ir4'
fname1 = '.v7.0.wghtv.txt'

fig1 = plt.figure(1, figsize=(16,10))
ax11 = fig1.add_subplot(111)

files=[]
n = 0
nrange = range(1,61)
for i in nrange:
    if i < 10:
        mockname = fname0+'00'+str(i)+fname1+'_wboss_florian.grid360.P020000.box3600'
    elif i < 100:
        mockname = fname0+'0'+str(i)+fname1+'_wboss_florian.grid360.P020000.box3600'
    else:
        mockname = fname0+str(i)+fname1+'_wboss_florian.grid360.P020000.box3600'
    try:
        with open(dir+mockname):
            files.append(i)
    except IOError:
        print 'file ',i,' does not exist.'

n = len(files)
for i in files:
    if i < 10:
        mockname = fname0+'00'+str(i)+fname1+'_wboss_florian.grid360.P020000.box3600'
    elif i < 100:
        mockname = fname0+'0'+str(i)+fname1+'_wboss_florian.grid360.P020000.box3600'
    else:
        mockname = fname0+str(i)+fname1+'_wboss_florian.grid360.P020000.box3600'

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
ax11.scatter( mock_k, mock_avg, color='b', s=8, label=r"$\overline{P(k)}$ for PTHalo DR11 v7.0 South")

cmass_data = np.loadtxt("/mount/riachuelo1/hahn/power/power-cmass-dr11v0-S-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat")
cmass_dr11v1 = np.loadtxt("/mount/riachuelo1/hahn/power/power-cmass-dr11v1-S-Anderson-nzw-zlim-florian-ngalsys-3600lbox-360bin-180bin.dat")
ax11.scatter( cmass_data[:,0], cmass_data[:,1], color='r', s=8, label=r"$P(k)$ for CMASS DR11v0 South" )
ax11.set_yscale('log')
ax11.set_xlim([0.0,0.2])
ax11.set_ylim([10**3,10**5.2])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':15})
ax11.grid(True)

py.show()
