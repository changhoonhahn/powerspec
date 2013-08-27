pro fibcoll_nbar_comp,n,noweight=noweight,upweight=upweight,shuffle=shuffle,random=random,peaknbar=peaknbar
    datadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    om0=0.27 
    ol0=0.73 

    zlim_nbar   =fltarr(201)
    z_mid_bound =fltarr(201)
    z_low_bound =fltarr(201) 
    z_high_bound=fltarr(201)
    zlim_comvol =fltarr(201)
    comdis_low  =fltarr(201)
    comdis_high =fltarr(201)

    pthalo_file = 'nbar-cmass-dr11may22-N-Anderson.dat'
    readcol, datadir+pthalo_file, z_mid,z_low,z_high,nbarz,wfkp,shell_vol,gal_tot
    for i=0L,200L do begin 
        z_low_bound[i]  = z_low[i]
        z_mid_bound[i]  = z_mid[i]
        z_high_bound[i] = z_high[i]
        zlim_comvol[i]  = shell_vol[i]
        comdis_low[i]   = 3000.0*comdis(z_low_bound[i],om0,ol0) 
        comdis_high[i]  = 3000.0*comdis(z_high_bound[i],om0,ol0) 
    endfor 
    
    if keyword_set(noweight) then begin 
        data_fname = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1,$
            m2, veto
        weights = w_boss
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
        total_gals  = total(weights) 

        for i=0L,200L do begin 
           zlim = where(red ge z_low_bound[i] and red lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if count_zlim NE 0 then zlim_count = (total(weights[where(zlim)])/weights_max)*total_gals
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
        endfor
        out_fname = 'nbar-'+'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wboss.txt'
    endif 

    if keyword_set(upweight) then begin 
        data_fname = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1,$
            m2, veto

        weights = fltarr(n_elements(w_boss))
        gals    = double(w_boss)*double(w_cp+w_red-1.0)
        for i=0L,n_elements(w_boss)-1L do begin 
            if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin
                weights[i]  = double(w_cp[i]+w_red[i]-1.0)
            endif else begin
                weights[i]  = 0.0 
            endelse
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
        total_gals  = total(gals) 
        print, total_gals

        for i=0L,200L do begin 
           zlim = where(red ge z_low_bound[i] and red lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if count_zlim NE 0 then zlim_count = (total(weights[where(zlim)])/weights_max)*total_gals
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
        endfor
        out_fname = 'nbar-'+'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.upweight.txt'
    endif 

    if keyword_set(shuffle) then begin
        data_fname = 'shuffle_zlim_cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)$
           +'.v7.0.wghtv.txt' 
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, dc, ipoly, w_boss, w_cp, w_red, redtrue, flag,$
           m1, m2, veto

        weights = fltarr(n_elements(w_boss))
        gals    = double(w_boss)*double(w_cp+w_red-1.0)
        for i=0L,n_elements(w_boss)-1L do begin 
            if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin
                weights[i]  = double(w_cp[i]+w_red[i]-1.0)
            endif else begin
                weights[i]  = 0.0 
            endelse
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
        total_gals  = total(gals) 

        for i=0L,200L do begin 
           zlim = where(dc ge comdis_low[i] and dc lt comdis_high[i],count_zlim)
           zlim_count = 0.0
           if count_zlim ne 0 then zlim_count = (total(weights[where(zlim)])/weights_max)*total_gals
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
        endfor
        out_fname = 'nbar-'+data_fname
    endif 
    
    if keyword_set(peaknbar) then begin
        data_fname = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)$
           +'.v7.0.peakcorr.txt'
        print,datadir+data_fname
        readcol, datadir+data_fname, ra,dec,az,w_boss,w_red,w_cp

        weights = fltarr(n_elements(w_boss))
        gals    = double(w_boss)*double(w_cp+w_red-1.0)
        for i=0L,n_elements(w_boss)-1L do begin 
            if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin 
                weights[i]  = double(w_cp[i]+w_red[i]-1.0) 
            endif else begin 
                weights[i]  = 0.0
            endelse 
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
        total_gals  = total(gals) 

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if count_zlim GT 0.0 then zlim_count = (total(weights[where(zlim)])/weights_max)*total_gals
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
        endfor  
        out_fname = 'nbar-'+data_fname
    endif 
    
    if keyword_set(random) then begin
        if keyword_set(peaknbar) then begin 
            data_fname='cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
                '.v7.0.peakcorr.txt'
        endif else begin  
            data_fname='cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
                '.v7.0.wghtv.txt'
        endelse     
        print,datadir+data_fname
        readcol,datadir+data_fname,ra,dec,az

       for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = count_zlim 
           zlim_nbar[i] = zlim_count/zlim_comvol[i] 
       endfor
       out_fname = 'nbar-'+data_fname
    endif 

    openw,lun,datadir+out_fname,/get_lun 
    for i=0L,200L do printf,lun,z_mid_bound[i],z_low_bound[i],z_high_bound[i],zlim_nbar[i],$
        format='(4F)'
    free_lun,lun
end 
