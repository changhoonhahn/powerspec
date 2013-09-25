import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate
import sys

rc('text', usetex=True)
rc('font', family='serif')

dir = '/mount/riachuelo1/hahn/power/manera_mock/dr11/'

fname0 = 'power_cmass_dr11_north_ir4'
fname1 = '.v7.0.wghtv.txt'

files=[]

nrange_end = int(sys.argv[1])+1
nrange = range(1,nrange_end)
n = len(nrange)
for i in nrange:
    mockname_wb     = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.wboss.grid360.P020000.box3600'
    mockname_up     = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.upweight.grid360.P020000.box3600'
    mockname_peak   = fname0+str(i+1000)[1:4]+'.v7.0.'+str(n)+'randoms.peakcorr.grid360.P020000.box3600'
    
    mock_wb     = np.loadtxt(dir+mockname_wb)
    mock_up     = np.loadtxt(dir+mockname_up)
    mock_peak   = np.loadtxt(dir+mockname_peak)

    if i==1:
        mock_k = mock_up[:,0]
        mock_wb_tot         = mock_wb[:,1]
        mock_up_tot         = mock_up[:,1]
        mock_peak_tot       = mock_peak[:,1]
    else:
        mock_wb_tot         = mock_wb_tot + mock_wb[:,1]
        mock_up_tot         = mock_up_tot + mock_up[:,1]
        mock_peak_tot       = mock_peak_tot+mock_peak[:,1]
mock_wb_avg         = mock_wb_tot/float(n)
mock_up_avg         = mock_up_tot/float(n)
mock_peak_avg       = mock_peak_tot/float(n)

fig1 = plt.figure(1, figsize=(7,8))
ax11 = fig1.add_subplot(111)
ax11.loglog( mock_k, mock_wb_avg, color='k', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w_{BOSS}$")
ax11.loglog( mock_k, mock_up_avg, color='b', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 $w_{upweighted}$")
ax11.loglog( mock_k, mock_peak_avg, color='g', linewidth=2, 
        label=r"$\overline{P(k)}$ PTHalo NGC DR11 v7.0 Peak$+\bar{n}(z)$ Corrected")
ax11.set_xlim([10**-3,10**0])
ax11.set_ylim([10**2.75,10**5.1])
ax11.set_xlabel('k',fontsize=20)
ax11.set_ylabel('P(k)',fontsize=20)
ax11.legend(loc='best',prop={'size':12})
ax11.grid(True)
py.show()
