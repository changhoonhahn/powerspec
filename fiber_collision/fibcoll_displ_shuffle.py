import numpy as np

datadir = '/global/data/scr/chh327/powercode/data/'
fname = 'cmass_dr11_north_ir4001.v7.0.wghtv.txt'

pthalo_data = np.loadtxt(datadir+fname)
ra = pthalo_data[:,0]
dec = pthalo_data[:,1]
w_cp = pthalo_data[:,5]

ra_upcp = ra[ w_cp > 0 ] 
dec_upcp = dec[ w_cp > 0 ] 

ra_nocp = ra[ w_cp == 0 ]
dec_nocp = dec[ w_cp == 0 ] 

print len(ra_upcp), len(ra_nocp)

spherematch=np.loadtxt(datadir+'spherematch_'+fname)
m_upcp = spherematch[:,0]
m_nocp = spherematch[:,1]
print 'm_upcp=',len(m_upcp),len(set(m_upcp))
print 'm_nocp=',len(m_nocp),len(set(m_nocp))

gal_upcp = sorted(set(m_upcp)) 
print 'len(gal_upcp)=',len(gal_upcp)

m_nocp_list = []
for i in range(len(gal_upcp)): 
    m_nocp_list = np.append(m_nocp_list, m_nocp[m_upcp == gal_upcp[i]])

print len(m_nocp),len(set(m_nocp))
print len(m_nocp_list),len(set(m_nocp_list))
