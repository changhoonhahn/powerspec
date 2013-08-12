pro fibcoll_nbar_comp,n,upweight=upweight,shuffle=shuffle,random=random
    datadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'

    if keyword_set(upweight) then begin 
       data_fname = 'cmass_dr11_N_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
       print,datadir+data_fname
       readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto

    endif 
    if keyword_Set(shuffle) then begin 
       data_fname = 'shuffle_zlim_cmass_dr11_N_ir4'+strmid(strtrim(string(n+1000),1),1)+'.7v.0.wghtv.txt' 
       print,datadir+data_fname
       readcol, datadir+fname, ra, dec, comdis, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto

    endif 
    if keyword_Set(random) then begin 

    endif 
end 
