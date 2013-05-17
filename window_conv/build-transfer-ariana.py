import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from scipy import interpolate
from matplotlib import rc

rc('text',usetex=True)
rc('font',family='serif')

dir ='/mount/chichipio2/hahn/power/manera_mock/v5p2/'
n=0
P0 = [20000]

opt2pivot=np.empty(len(P0))
opt1pivot=np.empty(len(P0))
A2=np.empty(len(P0))
A1=np.empty(len(P0))

transfer=np.loadtxt('input_transfer_Ariana.dat')
P = transfer[:,0]**0.95*transfer[:,1]**2

fig0 = py.figure(1,figsize=(14,8))
ax00 = fig0.add_subplot(121)
ax01 = fig0.add_subplot(122)
fig1 = py.figure(2,figsize=(7,8))
ax1 = fig1.add_subplot(111)

fname0 = "power_cmass_dr10_north_ir4"
fname1 = ".v5.2.wghtv.txt"
fname2 = ".grid240.P0"
fname3 = ".box4800"
for j in range(len(P0)):
    option1=np.zeros([120])
    option2=np.zeros([120])
    n=0
    for i in range(1,101):
        if i < 10:
            f_opt2 = fname0+'00'+str(i)+fname1+"_now"+fname2+str(P0[j])+fname3
            f_opt1 = fname0+'00'+str(i)+fname1+"_wboss"+fname2+str(P0[j])+fname3
        elif i < 100:
            f_opt2 = fname0+'0'+str(i)+fname1+"_now"+fname2+str(P0[j])+fname3
            f_opt1 = fname0+'0'+str(i)+fname1+"_wboss"+fname2+str(P0[j])+fname3
        else:
            f_opt2 = fname0+str(i)+fname1+"_now"+fname2+str(P0[j])+fname3
            f_opt1 = fname0+str(i)+fname1+"_wboss"+fname2+str(P0[j])+fname3
        data_opt1 = np.loadtxt(dir+f_opt1)
        data_opt2 = np.loadtxt(dir+f_opt2)

        option1 = option1+data_opt1[:,1]
        option2 = option2+data_opt2[:,1]
        n=n+1

    opt2_maxindx = np.argmax(option2)
    opt1_maxindx = np.argmax(option1)
    print data_opt2[opt2_maxindx,0], data_opt1[opt1_maxindx,0]
    opt2pivot[j]=interpolate.interp1d(data_opt2[:,0],option2/float(n),kind='quadratic')(data_opt2[opt2_maxindx,0])
    opt1pivot[j]=interpolate.interp1d(data_opt1[:,0],option1/float(n),kind='quadratic')(data_opt1[opt1_maxindx,0])
    opt2transfpivot=interpolate.interp1d(transfer[:,0],P,kind='quadratic')(data_opt2[opt2_maxindx,0])
    opt1transfpivot=interpolate.interp1d(transfer[:,0],P,kind='quadratic')(data_opt1[opt1_maxindx,0])

    A2[j]=opt2pivot[j]/opt2transfpivot
    A1[j]=opt1pivot[j]/opt1transfpivot
    ax00.loglog(data_opt2[:,0],option2/float(n),'b',linewidth=3,label="P0="+str(P0[j])+" Option 2")
    ax01.loglog(data_opt1[:,0],option1/float(n),'b',linewidth=3,label="P0="+str(P0[j])+' Option 1')

opt2_transfy=interpolate.interp1d(transfer[:,0],A2[0]*P,kind='quadratic')(data_opt2[:,0])
opt1_transfy=interpolate.interp1d(transfer[:,0],A1[0]*P,kind='quadratic')(data_opt1[:,0])

ax00.loglog(transfer[:,0],A2[0]*P,'k--',linewidth=2,label='Transfer function pivoted at k='+str(data_opt2[opt2_maxindx,0]))
ax01.loglog(transfer[:,0],A1[0]*P,'k--',linewidth=2,label='Transfer function pivoted at k='+str(data_opt1[opt1_maxindx,0]))

opt2_transfratio = [ (option2[i]/n)/opt2_transfy[i] for i in range(0,len(option2)) ]
opt1_transfratio = [ (option1[i]/n)/opt1_transfy[i] for i in range(0,len(option1)) ]
ax1.plot(data_opt2[:,0],opt2_transfratio,'b',label=r"$\frac{P_{Opt2}(k)}{transfunc(k)}$")
ax1.plot(data_opt1[:,0],opt1_transfratio,'r',label=r"$\frac{P_{Opt1}(k)}{transfunc(k)}$")

ax1.set_xscale('log')

ax00.set_xlim([10**-3,10**0])
ax01.set_xlim([10**-3,10**0])
ax1.set_xlim([10**-3,10**0])

ax00.set_ylim([10**3,10**5.2])
ax01.set_ylim([10**3,10**5.2])

ax00.set_xlabel('k',fontsize=15)
ax01.set_xlabel('k',fontsize=15)
ax1.set_xlabel('k',fontsize=15)
ax00.set_ylabel('P(k)',fontsize=15)
ax01.set_ylabel('P(k)',fontsize=15)
ax1.set_ylabel(r"$\frac{P(k)}{transfunc(k)}$",fontsize=15)

ax00.legend(loc='best')
ax01.legend(loc='best')
ax1.legend(loc='best')

ax00.grid(True)
ax01.grid(True)
#py.show()

klimlo = transfer[:,0] >= min(data_opt2[:,0])
klimhi = transfer[:,0] <= max(data_opt2[:,0])

transfk = (transfer[:,0])[klimlo & klimhi]
transfp = (A2[0]*P)[klimlo & klimhi]

outfname = "transfunc-ariana-opt2-peakpivot.dat"
outputfile = open(outfname,'w')
for j in range(0,len(transfk)):
    outputfile.write(str(transfk[j])+'\t'+str(transfp[j])+'\n')
