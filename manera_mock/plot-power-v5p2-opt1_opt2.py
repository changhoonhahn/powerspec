import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir ='/mount/chichipio2/hahn/power/manera_mock/v5p2/'

fig1 = py.figure(1,figsize=(14,8))
ax10 = fig1.add_subplot(121)
ax11 = fig1.add_subplot(122)

fname0 = "power_cmass_dr10_north_ir4"
fname1 = ".v5.2.wghtv.txt"
fname2 = ".grid240.P0"
fname3 = ".box4800"
P0="20000"
n=0
for i in range(1,101):
    if i < 10:
        f_opt2 = fname0+'00'+str(i)+fname1+"_now"+fname2+P0+fname3
        f_opt1 = fname0+'00'+str(i)+fname1+"_wboss"+fname2+P0+fname3
    elif i < 100:
        f_opt2 = fname0+'0'+str(i)+fname1+"_now"+fname2+P0+fname3
        f_opt1 = fname0+'0'+str(i)+fname1+"_wboss"+fname2+P0+fname3
    else:
        f_opt2 = fname0+str(i)+fname1+"_now"+fname2+P0+fname3
        f_opt1 = fname0+str(i)+fname1+"_wboss"+fname2+P0+fname3
    data_opt1 = np.loadtxt(dir+f_opt1)
    data_opt2 = np.loadtxt(dir+f_opt2)
    print f_opt1
    print f_opt2
    if i==1:
        option1 = data_opt1[:,1]
        option2 = data_opt2[:,1]
        opt1_k = data_opt1[:,0]
        opt2_k = data_opt2[:,0]
    else:
        option1 = option1+data_opt1[:,1]
        option2 = option2+data_opt2[:,1]
    n=n+1

print n
ax10.loglog(opt1_k,option1/float(n),'b',linewidth=3,label=r"$P_{up-weighted}$")
ax10.loglog(opt2_k,option2/float(n),'c--',linewidth=3,label=r"$P_{no-weight}$")

op1op2 = np.array( [ option1[x]/option2[x] - 1.0 for x in range(len(option1)) ] )

ax11.plot(opt2_k,op1op2,'k',linewidth=2)

ax10.set_xlim([10**-3,10**0])
ax11.set_xlim([10**-3,10**0])
ax11.set_xscale('log')

ax10.set_ylim([10**3,10**5.2])

ax10.set_xlabel('k',fontsize=15)
ax11.set_xlabel('k',fontsize=15)

ax10.set_ylabel('P(k)',fontsize=15)
ax11.set_ylabel(r"$\bf{\frac{P_{Option 1}}{P_{Option 2}}-1}$",fontsize=18)

ax10.legend(loc='best', prop={'size':14})
ax11.legend(loc='best', prop={'size':14})

ax10.grid(True)
ax11.grid(True)
py.show()
