import numpy as np
import pylab as py

dir='/mount/riachuelo1/hahn/data/manera_mock/dr11/'
nbar=np.loadtxt(dir+'nbar-cmass-dr11may22-N-Anderson.dat')

i=0
while (nbar[i,0]<0.35):
    i=i+1

print i

output = py.column_stack((nbar[i:201,0],nbar[i:201,3]/max(nbar[i:201,3])))
py.savetxt(dir+'cp-redshift-nbar-dr11may22-N-Anderson.dat',output)

py.figure(1)
py.plot(output[:,0], output[:,1])
py.xlabel('Redshift (z)')
py.ylabel('Normalized n(z)')
py.show()
