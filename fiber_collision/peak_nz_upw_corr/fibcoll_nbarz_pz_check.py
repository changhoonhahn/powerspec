import numpy as np
import pylab as py
import random as ran
from scipy import interpolate
import sys 

dir     = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
fname   = 'nbar-normed-cmass_dr11_north_25_randoms_ir4_combined.v7.0.upweight'
nbar    = np.loadtxt(dir+fname+'.txt')

zmid    = nbar[:,0]
nbarz   = nbar[:,3]

zmidrange   = zmid[ (zmid > 0.43) & (zmid < 0.7) ] 
nbarzrange  = nbarz[ (zmid > 0.43) & (zmid < 0.7) ] 
maxnbar     = np.max(nbarzrange) 
nbarzrange  = nbarzrange/maxnbar

#fig1 = py.figure(1)
#ax10 = fig1.add_subplot(111)
#ax10.plot(zmidrange,nbarzrange)

outputfile  = dir+fname+'-pz.txt'
output = open(outputfile,'w')
for i in range(len(nbarzrange)): 
    output.write(str(zmidrange[i])+'\t'+str(nbarzrange[i])+'\n')

#zval=[]
#for n in range(10000): 
#    ran1 = ran.random()
#    ran2 = ran.random()
#    ran1 = np.min(zmidrange)+ran1*(np.max(zmidrange)-np.min(zmidrange))
#    pr = interpolate.interp1d(zmidrange,nbarzrange,kind='cubic')(ran1)
#    while pr <= ran2: 
#        ran1 = ran.random()
#        ran2 = ran.random()
#        ran1 = np.min(zmidrange)+ran1*(np.max(zmidrange)-np.min(zmidrange))
#        pr = interpolate.interp1d(zmidrange,nbarzrange,kind='cubic')(ran1)
#    zval.append(ran1)
#
#fig2 = py.figure(2)
#ax20 = fig2.add_subplot(111)
#zbin = 0.43+0.27/10.0*np.array(range(10))
#hist_zval = ax20.hist(zval,zbin) 
#zbin_mid = np.array([(hist_zval[1][i]+hist_zval[1][i+1])/2.0 for i in range(len(hist_zval[1])-1)])
#ax10.plot(zbin_mid,hist_zval[0]/float(np.max(hist_zval[0])))
#py.show()
