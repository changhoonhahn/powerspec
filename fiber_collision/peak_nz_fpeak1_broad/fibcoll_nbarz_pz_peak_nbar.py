import numpy as np
import pylab as py
import random as ran
from scipy import interpolate
import sys 

file_dir    = sys.argv[1]
file_name   = sys.argv[2] 
file_ext    = sys.argv[3]
nbar        = np.loadtxt(file_dir+file_name+file_ext)

zmid    = nbar[:,0]
nbarz   = nbar[:,3]

zmidrange   = zmid[ (zmid > 0.43) & (zmid < 0.7) ] 
nbarzrange  = nbarz[ (zmid > 0.43) & (zmid < 0.7) ] 
maxnbar     = np.max(nbarzrange) 
nbarzrange  = nbarzrange/maxnbar

outputfile  = file_dir+file_name+'-pz'+file_ext
output = open(outputfile,'w')
for i in range(len(nbarzrange)): 
    output.write(str(zmidrange[i])+'\t'+str(nbarzrange[i])+'\n')
exit()
