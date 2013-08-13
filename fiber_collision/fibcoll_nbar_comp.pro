pro fibcoll_nbar_comp,n,noweight=noweight,upweight=upweight,shuffle=shuffle,random=random
    datadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    
    om0=0.27 
    ol0=0.73 

    z_low=0.000 
    z_high=1.005
    zlim_nbar   =dblarr(201)
    z_mid_bound =dblarr(201)
    z_low_bound =dblarr(201) 
    z_high_bound=dblarr(201)
    zlim_comvol =dblarr(201)
    comdis_low  =dblarr(201)
    comdis_high =dblarr(201)
    for i=0L,200L do begin 
        z_low_bound[i]  = z_low+0.005*float(i)
        z_high_bound[i] = z_low+0.005*float(i+1)
        z_mid_bound[i]  = (z_low_bound[i]+z_high_bound[i])/2.0
        zlim_comvol[i]  = 4.0*!PI/3.0*(lf_comvol(z_high_bound[i])-lf_comvol(z_low_bound[i]))
        comdis_low[i]   = 3000.0*comdis(z_low_bound[i],om0,ol0) 
        comdis_high[i]  = 3000.0*comdis(z_high_bound[i],om0,ol0) 
    endfor 
    
    if keyword_set(noweight) then begin 
        data_fname = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto
        for i=0L,200L do begin 
           zlim = red ge z_low_bound[i] and red lt z_high_bound[i]
           zlim_count   = n_elements(where(zlim))
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
        endfor

        out_fname = 'nbar_'+data_fname
        openw, lun, datadir+out_fname,/get_lun 
        for i=0L,200L do printf,lun,z_mid_bound[i],z_low_bound[i],z_high_bound[i],zlim_nbar[i],$
           format='(4F)'
        free_lun, lun
    endif 

    if keyword_set(upweight) then begin 
        data_fname = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto
        weights = w_boss*(w_cp+w_red-1.0)

        for i=0L,200L do begin 
           zlim = red ge z_low_bound[i] and red lt z_high_bound[i]
           zlim_count = total(weights[where(zlim)])
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
        endfor

        out_fname = 'nbar_upweighted_'+data_fname
        openw, lun, datadir+out_fname,/get_lun 
        for i=0L,200L do printf,lun,z_mid_bound[i],z_low_bound[i],z_high_bound[i],zlim_nbar[i],$
           format='(4F)'
        free_lun, lun
    endif 

    if keyword_Set(shuffle) then begin
        data_fname = 'shuffle_zlim_cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)$
           +'.v7.0.wghtv.txt' 
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, dc, ipoly, w_boss, w_cp, w_red, redtrue, flag,$
           m1, m2, veto

        for i=0L,200L do begin 
           zlim = dc ge comdis_low[i] and dc lt comdis_high[i]
           zlim_count = n_elements(where(zlim))
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
        endfor

        out_fname = 'nbar_'+data_fname
        openw, lun, datadir+out_fname,/get_lun 
        for i=0L,200L do printf,lun,z_mid_bound[i],z_low_bound[i],z_high_bound[i],zlim_nbar[i],$
           format='(4F)'
        free_lun, lun
    endif 
    
    if keyword_Set(random) then begin
        data_fname='cmass_dr11_north_randoms_ir4_combined_wboss.v7.0.wghtv.txt'
        print,datadir+data_fname
        readcol,datadir+data_fname,ra,dec,red

       for i=0L,200L do begin 
           zlim = red ge z_low_bound[i] and red lt z_high_bound[i]
           zlim_count = n_elements(where(zlim))
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
       endfor
       out_fname = 'nbar_'+data_fname
       openw, lun, datadir+out_fname,/get_lun 
       for i=0L,200L do printf,lun,z_mid_bound[i],z_low_bound[i],z_high_bound[i],zlim_nbar[i],$
           format='(4F)'
       free_lun, lun
    endif 
end 
