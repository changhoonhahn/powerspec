import numpy as np
import pylab as py
import matplotlib.pyplot as plt

dir ='/mount/chichipio2/hahn/power/manera_mock/'
n=0
P0 = [0, 10000, 20000, 30000, 40000]
color = ['k','m','b','g','r']
py.figure(figsize=(8,8))
for j in range(len(P0)):
    for i in range(1,2):
        """if i == 28:
            "bleh"
        elif i == 110:
            "bleh"
        elif i == 577:
            "bleh"
        else: """
        if i < 10:
            powername='power_cmass_dr10_north_ir400'+str(i)+'.v5.1.wght.txtP0'+str(P0[j])
        elif i < 100:
            powername='power_cmass_dr10_north_ir40'+str(i)+'.v5.1.wght.txtP0'+str(P0[j])
        else:
            powername='power_cmass_dr10_north_ir4'+str(i)+'.v5.1.wght.txtP0'+str(P0[j])
        data = np.loadtxt(dir+powername)
        plt.plot(np.log10(data[:,0]),np.log10(data[:,1]),color[j])
        """if np.min(np.log10(data[:,1])) > 4.0:
            print powername"""

#py.xlim([-2.3,0.0])
#py.ylim([3.2,5.3])
py.xlabel('k',fontsize=15)
py.ylabel('P(k)',fontsize=15)
plt.grid(True)
py.show()
