import numpy as np
import pylab as py
from scipy.integrate import simps
from scipy.optimize import curve_fit
from matplotlib import rc

rc('text', usetex=True)
rc('font', family='serif')

disp_los = np.loadtxt('cmass_dr11_north_ir4467v7.0_disp_los.dat')
disp_perp = np.loadtxt('cmass_dr11_north_ir4467v7.0_disp_perp.dat')
disp_los_disttail_red = np.loadtxt('cmass_dr11_north_ir4467v7.0_disp_los_disttail_redshift.dat')
disp_los_disttail_red_hist = np.loadtxt('cmass_dr11_north_ir4467v7.0_disp_los_disttail_redshift_hist.dat')
data = np.loadtxt('/global/data/scr/chh327/powercode/data/cmass_dr11_north_ir4467.v7.0.wghtv.txt')


mpc_bin = 0.1*np.array(range(10000))
mpc_bin_perp = 0.05*np.array(range(20))
red_bin = 0.005*np.array(range(len(disp_los_disttail_red_hist)))+0.005

fig4 = py.figure(4)
dump = fig4.add_subplot(111)

fig1 = py.figure(1)
ax1 = fig1.add_subplot(111)

fig3 = py.figure(3)
ax12 = fig3.add_subplot(111)
hist_disp_los = dump.hist(disp_los,mpc_bin, log='True',label='Line of Sight Displacement Histogram')
hist_disp_perp = ax12.hist(disp_perp,mpc_bin_perp, log='True',label=r'Histogram of $d_{\perp}$')

def gauss(x,sig):
    return np.max(hist_disp_los[0])*np.exp(-0.5*x**2/sig**2)
popt, pcov = curve_fit(gauss, mpc_bin[0:20], hist_disp_los[0][0:20])
print popt

disp_los_x = [ (hist_disp_los[1][i] + hist_disp_los[1][i+1])/2.0 for i in range(len(hist_disp_los[1])-1) ]
disp_perp_x = [ (hist_disp_perp[1][i] + hist_disp_perp[1][i+1])/2.0 for i in range(len(hist_disp_perp[1])-1) ]

ax1.plot(disp_los_x, hist_disp_los[0],linewidth=3, label=r'Histogram of $d_{LOS}$')
#ax1.plot(mpc_bin, gauss(mpc_bin, popt[0]), 'r', linewidth=3, label=r'Gaussian distribution with $\sigma=$'+str(popt))
ax1.set_yscale('log')
ax1.set_xlim([0,600])
ax1.set_xlabel('Displacement (Mpc)')
ax1.set_ylabel('Number of Galaxies')
ax1.legend(loc='best')

ax12.set_xlim([0.0,1.0])
ax12.set_xlabel('Displacement (Mpc)')
ax12.set_ylabel('Number of Galaxies')
ax12.legend(loc='best')
""""
for d in [1, 2, 3, 4]:
    RMSfrac = float(len(disp_los[disp_los<d]))/float(len(disp_los))*100.0
    print RMSfrac
    caption = r''+str(np.int(RMSfrac))+"$\%$"
    ax1.annotate(caption, (float(d),100), xycoords='data', xytext=(float(d), 500), textcoords='data',
            arrowprops=dict(arrowstyle="fancy", facecolor='blue', connectionstyle="angle3,angleA=0,angleB=-90"),
            fontsize=20, horizontalalignment='center', verticalalignment='top')
"""
fig2 = py.figure(2,figsize=(10,10))
ax2 = fig2.add_subplot(111)
hist_disttail_red = ax2.hist(disp_los_disttail_red,red_bin, normed=1, label=r'Redshift Distribution of Galaxies with $d_{LOS} > 10$')
hist_data_red = ax1.hist(data[:,2], red_bin, normed=1,label='Redshift Distribution of Galaxies for data')
hist_data_red_x = [ (hist_data_red[1][i] + hist_data_red[1][i+1])/2.0 for i in range(len(hist_data_red[1])-1) ]
#print len(hist_data_red[1]), len(hist_data_red[0])
ax2.plot(hist_data_red_x, hist_data_red[0],'r', linewidth=3, label='Redshift Distribution of Galaxies for PTHalo v7.0 467 NGC')
ax2.set_xlim([0.4, 0.8])
ax2.set_ylim([0.0, 8.0])
ax2.set_xlabel('Redshift (z)')
ax2.set_ylabel('Galaxies')
ax2.legend(loc='best')

fig1.savefig('/home/users/hahn/figures/boss/fiber_collision/fibercollision-manera-dr11-ir4467-v7p0-ngc-displ_los_hist_0-600lsqfit.png')
fig2.savefig('/home/users/hahn/figures/boss/fiber_collision/fibercollision-manera-dr11-ir4467-v7p0-ngc-nz_dlos10.png')
fig3.savefig('/home/users/hahn/figures/boss/fiber_collision/fibercollision-manera-dr11-ir4467-v7p0-ngc-displ_perp_hist.png')
#py.show()
