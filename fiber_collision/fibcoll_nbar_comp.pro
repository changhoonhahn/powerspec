pro fibcoll_nbar_comp,n,upweight=upweight,shuffle=shuffle,random=random
    datadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    
    z_low = 0.000 
    z_high = 1.005
    z_low_bound=dblarr(201) 
    z_high_bound=dblarr(201)
    for i=0L,200L do begin 
        z_low_bound[i]=z_low+0.005*float(i)
        z_high_bound[i]=z_low+0.005*float(i+1)
    endfor 
    
    if keyword_set(upweight) then begin 
       data_fname = 'cmass_dr11_N_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
       print,datadir+data_fname
       readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto

       for i=0L,200L do begin 
           zlim = red ge z_low_bound[i] and red lt z_high_bound[i]
           zlim_count = n_elements(where(zlim))
           zlim_comvol = 

       endfor  
    endif 
    if keyword_Set(shuffle) then begin 
       data_fname = 'shuffle_zlim_cmass_dr11_N_ir4'+strmid(strtrim(string(n+1000),1),1)+'.7v.0.wghtv.txt' 
       print,datadir+data_fname
       readcol, datadir+fname, ra, dec, comdis, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto

    endif 
    if keyword_Set(random) then begin 

    endif 
end 
