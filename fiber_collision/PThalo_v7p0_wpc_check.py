import numpy as np

riadir = "/mount/riachuelo1/hahn/data/manera_mock/dr11/"

veto_frac_S = [] 
for i in range(1,601): 
    if i < 10:
        mockname='cmass_dr11_south_ir400'+str(i)+'.v7.0.wghtv.txt'
    elif i < 100:
        mockname='cmass_dr11_south_ir40'+str(i)+'.v7.0.wghtv.txt'
    else:
        mockname='cmass_dr11_south_ir4'+str(i)+'.v7.0.wghtv.txt'
    print i
    mock_data = np.loadtxt(riadir+mockname)
    w_cp = mock_data[:,5] 
    if len(w_cp) != np.sum(w_cp): 
        print 'w_cp does not match Ngal for PTHalo ', str(i), ' South'
    w_cp_veto = w_cp[ mock_data[:,11] == 1]
    sum_w_cp_veto = np.sum(w_cp_veto)
    if len(w_cp_veto) != sum_w_cp_veto: 
        print 'w_cp_veto does not match Ngal for PTHalo ', str(i), 'South'
        print 'Ngal =', len(w_cp_veto), 'sum w_cp_veto=', sum_w_cp_veto
        print float(sum_w_cp_veto)/float(len(w_cp_veto))
        veto_frac_S.append(float(sum_w_cp_veto)/float(len(w_cp_veto)))

veto_frac_N = []
for i in range(1,601): 
    if i < 10:
        mockname='cmass_dr11_north_ir400'+str(i)+'.v7.0.wghtv.txt'
    elif i < 100:
        mockname='cmass_dr11_north_ir40'+str(i)+'.v7.0.wghtv.txt'
    else:
        mockname='cmass_dr11_north_ir4'+str(i)+'.v7.0.wghtv.txt'
    print i
    mock_data = np.loadtxt(riadir+mockname)
    w_cp = mock_data[:,5] 
    if len(w_cp) != np.sum(w_cp) : 
            print 'w_cp does not match Ngal for PTHalo ', str(i), ' North'
    w_cp_veto = w_cp[ mock_data[:,11] == 1]
    sum_w_cp_veto = np.sum(w_cp_veto)
    if len(w_cp_veto) != sum_w_cp_veto: 
        print 'w_cp_veto does not match Ngal for PTHalo ', str(i), 'North'
        print 'Ngal =', len(w_cp_veto), 'sum w_cp_veto=', sum_w_cp_veto
        print float(sum_w_cp_veto)/float(len(w_cp_veto))
        veto_frac_N.append(float(sum_w_cp_veto)/float(len(w_cp_veto)))

print 'veto frac S =', np.mean(veto_frac_S), 'veto frac N =', np.mean(veto_frac_N)
#veto frac S = 0.999998142733 veto frac N = 0.999995624715
