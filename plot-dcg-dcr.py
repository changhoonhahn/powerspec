import numpy as np
import pylab as py
import matplotlib.pyplot as plt

path = '/mount/chichipio2/hahn/FFT/'
dcg = np.loadtxt(path+'cmass-dr10v5-N-Anderson-nzw-10grid-newassign-dcg.dat')
dcr = np.loadtxt(path+'cmass-dr10v5-N-Anderson-nzw-10grid-newassign-dcr.dat')

x=(dcg[:,0]-1)+(dcg[:,1]-1)*10+(dcg[:,2]-1)*100
gfrac = float(428201)/float(20833071)
print gfrac

py.figure(1)
py.suptitle('Imaginary',fontsize=12)
py.plot(x,dcg[:,4], 'r', label='dcg')
py.plot(x,gfrac*dcr[:,4], 'b', label='dcr')
py.xlabel('ix+10iy+100iz')
py.legend(loc='upper right',prop={'size':12})

py.figure(2)
py.suptitle('Real',fontsize=12)
py.plot(x,dcg[:,3],'r',label='dcg')
py.plot(x,gfrac*dcr[:,3],'b', label='dcr')
py.xlabel('ix+10iy+100iz')
py.legend(loc='upper right',prop={'size':12})

py.figure(3)
py.suptitle('dcg/dcr-1',fontsize=20)
y = dcg[:,3]/(gfrac*dcr[:,3])-1.0
py.plot(x,y)
py.xlim([0,1000])
py.xlabel('ix+10iy+100iz')
py.show()
