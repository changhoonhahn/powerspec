import numpy as np
import pylab as py
import matplotlib.pyplot as plt
from matplotlib import rc
from scipy import interpolate

rc('text', usetex=True)
rc('font', family='serif')

dir ='/mount/chichipio2/hahn/power/manera_mock/'
n=0
#P0 = [0,10000,20000,30000,40000]
P0 = [20000]
#P0 = [0]
#color = ['k','m','b','g','r']
color=['b']
fig=plt.figure(1,figsize=(14,8))
fig1=plt.figure(2,figsize=(14,16))
fig2=plt.figure(3, figsize=(10,10))
fig3=plt.figure(4, figsize=(10,10))
tzfig=plt.figure(5, figsize=(7,8))
ax=fig.add_subplot(121)
ax1=fig.add_subplot(122)
ax2=fig1.add_subplot(221)
ax3=fig1.add_subplot(222)
ax31=fig1.add_subplot(223)
ax32=fig1.add_subplot(224)

ax4=fig2.add_subplot(111)
ax5=fig3.add_subplot(111)
tzax=tzfig.add_subplot(111)
line=[]
line1=[]
leg=[]
leg1=[]
opt2pivot=np.empty(len(P0))
opt1pivot=np.empty(len(P0))
truezpivot1=np.empty(len(P0))
truezpivot2=np.empty(len(P0))
A2=np.empty(len(P0))
A1=np.empty(len(P0))
Atz1=np.empty(len(P0))
Atz2=np.empty(len(P0))

transfer=np.loadtxt('input_transfer_Ariana.dat')
P = transfer[:,0]**0.95*transfer[:,1]**2
transfpivot=interpolate.interp1d(transfer[:,0],P,kind='quadratic')(0.05)

for j in range(len(P0)):
    option1=np.zeros([120])
    option2=np.zeros([120])
    cpcorr=np.zeros([120])
    truered1=np.zeros([120])
    truered2=np.zeros([120])
    n=0
    for i in range(1,11):
        if i < 10:
            powername='power_cmass_dr10_north_ir400'+str(i)+'.v5.1.wght.txt_now.grid240.P0'+str(P0[j])+'.box4800'
            powername1='power_cmass_dr10_north_ir400'+str(i)+'.v5.1.wght.txt_wboss.grid240.P0'+str(P0[j])+'.box4800'
            powercp='power_cmass_dr10_north_ir400'+str(i)+'.v5.1.wght.txt_wboss_cp.grid240.P0'+str(P0[j])+'.box4800'
            powertruered1='power_cmass_dr10_north_ir400'+str(i)+'.v5.1.wght.txt_truered_rsdnbar.grid240.P0'+str(P0[j])+'.box4800'
            powertruered2='power_cmass_dr10_north_ir400'+str(i)+'.v5.1.wght.txt_truered.grid240.P0'+str(P0[j])+'.box4800'
        elif i < 100:
            powername='power_cmass_dr10_north_ir40'+str(i)+'.v5.1.wght.txt_now.grid240.P0'+str(P0[j])+'.box4800'
            powername1='power_cmass_dr10_north_ir40'+str(i)+'.v5.1.wght.txt_wboss.grid240.P0'+str(P0[j])+'.box4800'
            powercp='power_cmass_dr10_north_ir40'+str(i)+'.v5.1.wght.txt_wboss_cp.grid240.P0'+str(P0[j])+'.box4800'
            powertruered='power_cmass_dr10_north_ir40'+str(i)+'.v5.1.wght.txt_truered_rsdnbar.grid240.P0'+str(P0[j])+'.box4800'
        else:
            powername='power_cmass_dr10_north_ir4'+str(i)+'.v5.1.wght.txt_now.grid240.P0'+str(P0[j])+'.box4800'
            powername1='power_cmass_dr10_north_ir4'+str(i)+'.v5.1.wght.txt_wboss.grid240.P0'+str(P0[j])+'.box4800'
            powercp='power_cmass_dr10_north_ir4'+str(i)+'.v5.1.wght.txt_wboss_cp.grid240.P0'+str(P0[j])+'.box4800'
            powertruered='power_cmass_dr10_north_ir4'+str(i)+'.v5.1.wght.txt_truered_rsdnbar.grid240.P0'+str(P0[j])+'.box4800'
        data = np.loadtxt(dir+powername)
        data1 = np.loadtxt(dir+powername1)
        datacp = np.loadtxt(dir+powercp)
        datatruered1 = np.loadtxt(dir+powertruered1)
        datatruered2 = np.loadtxt(dir+powertruered2)

        option1 = option1+data1[:,1]
        option2 = option2+data[:,1]
        cpcorr = cpcorr+datacp[:,1]
        truered1 = truered1+datatruered1[:,1]
        truered2 = truered2+datatruered2[:,1]
        n=n+1

        l=ax.loglog(data[:,0],data[:,1],color[j],linewidth=3,label="P0="+str(P0[j])+' Option 2')
        l=ax.loglog(datacp[:,0],datacp[:,1],color[j],linewidth=2,label="P0="+str(P0[j])+' Close Pair Corrected')
        l1=ax1.loglog(data1[:,0],data1[:,1],color[j]+'--',linewidth=2,label="P0="+str(P0[j])+" Option 1")

        if i==1:
            line.append(l)
            leg.append("P0="+str(P0[j])+' Close Pair Corrected')
            line1.append(l1)
            leg1.append("P0="+str(P0[j])+' Option 1')
        """if np.min(np.log10(data[:,1])) > 4.0:
            print powername"""
    ax2.loglog(data1[:,0],option2/float(n),color[j],linewidth=3,label="P0="+str(P0[j])+" Option 2")
    ax3.loglog(data1[:,0],option2/float(n),color[j],linewidth=3,label="P0="+str(P0[j])+" Option 2")
    ax31.loglog(data1[:,0],option2/float(n),color[j],linewidth=3,label="P0="+str(P0[j])+" Option 2")
    ax32.loglog(data1[:,0],option2/float(n),color[j],linewidth=3,label="P0="+str(P0[j])+" Option 2")
    ax3.loglog(data[:,0],option1/float(n),'c--',linewidth=3,label="P0="+str(P0[j])+' Option 1')
    ax31.loglog(datacp[:,0],cpcorr/float(n),'m',linewidth=3,label="P0="+str(P0[j])+" Close Pair Corrected")
    ax32.loglog(datatruered1[:,0],truered1/float(n),'r',linewidth=3,label="P0="+str(P0[j])+" Real z RSD nbar")
    ax32.loglog(datatruered2[:,0],truered2/float(n),'g',linewidth=3,label="P0="+str(P0[j])+" Real z")

    tzax.loglog(datatruered1[:,0],truered1/float(n),'r',linewidth=2,label="P0="+str(P0[j])+" Real z RSD nbar")
    tzax.loglog(datatruered2[:,0],truered2/float(n),'g',linewidth=3,label="P0="+str(P0[j])+" Real z")

    opt2pivot[j]=interpolate.interp1d(data[:,0],option2/float(n),kind='quadratic')(0.05)
    opt1pivot[j]=interpolate.interp1d(data[:,0],option1/float(n),kind='quadratic')(0.05)
    truezpivot1[j]=interpolate.interp1d(data[:,0],truered1/float(n),kind='quadratic')(0.05)
    truezpivot2[j]=interpolate.interp1d(data[:,0],truered2/float(n),kind='quadratic')(0.05)
    A2[j]=opt2pivot[j]/transfpivot
    A1[j]=opt1pivot[j]/transfpivot
    Atz1[j]=truezpivot1[j]/transfpivot
    Atz2[j]=truezpivot2[j]/transfpivot

    transfint2=interpolate.interp1d(transfer[:,0],P,kind="quadratic")(data[:,0])
    transfint1=interpolate.interp1d(transfer[:,0],P,kind="quadratic")(data1[:,0])
    transfinttz1=interpolate.interp1d(transfer[:,0],P,kind="quadratic")(datatruered1[:,0])
    transfinttz2=interpolate.interp1d(transfer[:,0],P,kind="quadratic")(datatruered2[:,0])
    transfintcp=interpolate.interp1d(transfer[:,0],P,kind="quadratic")(datacp[:,0])
    y2=(option2/float(n))/(A2[j]*transfint2)-1.0
    y1=(option1/float(n))/(A1[j]*transfint1)-1.0
    ytz1=(truered1/float(n))/(Atz1[j]*transfinttz1)-1.0
    ytz2=(truered2/float(n))/(Atz2[j]*transfinttz2)-1.0

    ax4.plot(data[:,0],y2,'c',linewidth=2,label=r"$y_{2}={P_{Opt 2}}/{P_{transfer}}-1, P_0=$"+str(P0[j]))
    ax4.plot(data1[:,0],y1,color[j],linewidth=2,label=r"$y_{1}={P_{Opt 1}}/{P_{transfer}}-1, P_0=$"+str(P0[j]))
    ax4.plot(datatruered1[:,0],ytz1,'r--',linewidth=3,label=r"$y_{tz}={P_{real z}}/{P_{transfer}}-1, P_0=$"+str(P0[j]))

    op1op2 = option1/option2 - 1
    cpop2 = cpcorr/option2 - 1
    red1op2 = truered1/option2 - 1
    red2op2 = truered2/option2 - 1

    ax5.plot(data[:,0],op1op2,'c',linewidth=2,label=r"$\frac{P_{Option 1}}{P_{Option 2}}-1, P_0=$"+str(P0[j]))
    ax5.plot(data[:,0],cpop2,'m',linewidth=2,label=r"$\frac{P_{cp corr}}{P_{Option 2}}-1, P_0=$"+str(P0[j]))
    ax5.plot(data[:,0],red1op2,'r',linewidth=2,label=r"$\frac{P_{realz rsdnbar}}{P_{Option 2}}-1, P_0=$"+str(P0[j]))
    ax5.plot(data[:,0],red2op2,'g',linewidth=2,label=r"$\frac{P_{realz}}{P_{Option 2}}-1, P_0=$"+str(P0[j]))

ax2.loglog(transfer[:,0],A2[0]*P,'k--',linewidth=2,label='Transfer function')
ax3.loglog(transfer[:,0],A1[0]*P,'k--',linewidth=2,label='Transfer function')
ax31.loglog(transfer[:,0],A1[0]*P,'k--',linewidth=2,label='Transfer function')
ax32.loglog(transfer[:,0],A1[0]*P,'k--',linewidth=2,label='Transfer function')

#ax.set_title("Power spectra for Manera Mocks Option 2")
ax.set_title("Power spectra for Manera Mocks Close Pair Corrected")
ax1.set_title("Power spectra for Manera Mocks Option 1")

ax4.tick_params(labelsize=14)
ax5.tick_params(labelsize=14)

ax.set_xlim([10**-3,10**0])
ax1.set_xlim([10**-3,10**0])
ax2.set_xlim([10**-3,10**0])
ax3.set_xlim([10**-3,10**0])
ax31.set_xlim([10**-3,10**0])
ax32.set_xlim([10**-3,10**0])
ax4.set_xlim([10**-3,10**0])
ax4.set_xscale('log')
ax5.set_xscale('log')
tzax.set_xlim([10**-3,10**0])

ax.set_ylim([10**3,10**5.2])
ax1.set_ylim([10**3,10**5.2])
ax2.set_ylim([10**3,10**5.2])
ax3.set_ylim([10**3,10**5.2])
ax31.set_ylim([10**3,10**5.2])
ax32.set_ylim([10**3,10**5.2])
tzax.set_ylim([10**3,10**5.2])

ax.set_xlabel('k',fontsize=15)
ax1.set_xlabel('k',fontsize=15)
#ax2.set_xlabel('k',fontsize=15)
ax31.set_xlabel('k',fontsize=15)
ax32.set_xlabel('k',fontsize=15)
ax4.set_xlabel('k',fontsize=15)
ax5.set_xlabel('k',fontsize=15)
tzax.set_xlabel('k',fontsize=15)

ax.set_ylabel('P(k)',fontsize=15)
ax1.set_ylabel('P(k)',fontsize=15)
ax2.set_ylabel('P(k)',fontsize=15)
ax31.set_ylabel('P(k)',fontsize=15)
tzax.set_ylabel('P(k)',fontsize=15)
ax4.set_ylabel(r"$\bf{y_{i}}$",fontsize=18)
ax5.set_ylabel(r"$\bf{\frac{P_{method}}{P_{Option 2}}-1}$",fontsize=18)

#py.legend(loc='lower left', prop={'size':12})
ax.legend(line,leg,loc='lower left',prop={'size':12})
ax1.legend(line1,leg1,loc='lower left',prop={'size':12})
ax2.legend(loc='lower left', prop={'size':12})
ax3.legend(loc='lower left', prop={'size':12})
ax31.legend(loc='lower left', prop={'size':12})
ax32.legend(loc='lower left', prop={'size':12})
ax4.legend(loc='best',prop={'size':16})
ax5.legend(loc='best',prop={'size':16})
tzax.legend(loc='best',prop={'size':14})

ax.grid(True)
ax1.grid(True)
ax2.grid(True)
ax3.grid(True)
ax31.grid(True)
ax32.grid(True)
tzax.grid(True)
ax5.grid(True)
py.show()
