import numpy as np
import pylab as py
import matplotlib.pyplot as plt

dir ='/mount/chichipio2/hahn/power/las_damas/'
n=0
letters = [ 'a', 'b', 'c', 'd' ]
P0 = [0, 10000, 20000, 30000, 40000]
color = ['k','m','b','g','r']
py.figure(figsize=(8,8))
for j in range(len(P0)):
    for i in range(1,41):
        for letter in letters:
            if i < 10:
                powername='power_sdssmock_gamma_lrgFull_zm_oriana0'+str(i)+letter+'_no.rdcz.datP0'+str(P0[j])
            else:
                powername='power_sdssmock_gamma_lrgFull_zm_oriana'+str(i)+letter+'_no.rdcz.datP0'+str(P0[j])
            data = np.loadtxt(dir+powername)
            print color[j], powername
            plt.plot(np.log10(data[:,0]),np.log10(data[:,1]))

py.xlim([-2.3,0.0])
py.ylim([3.2,5.3])
py.xlabel('k',fontsize=15)
py.ylabel('P(k)',fontsize=15)
plt.grid(True)
py.show()
