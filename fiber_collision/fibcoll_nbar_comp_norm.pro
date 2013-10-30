pro fibcoll_nbar_comp_norm,n,noweight=noweight,wboss=wboss,upweight=upweight,shuffle=shuffle,random=random,$
    peaknbar=peaknbar,randpeak=randpeak,cmass=cmass,dr10=dr10,combined=combined,dr11test=dr11test
    if keyword_set(dr11test) then begin 
        datadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11test/'
        version = '.v11.0'
    endif else begin 
        datadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
        version = '.v7.0'
    endelse 
    chichidir = '/mount/chichipio2/hahn/data/manera_mock/v5p2/'
    om0=0.27 
    ol0=0.73 

    zlim_nbar   =fltarr(201)
    z_mid_bound =fltarr(201)
    z_low_bound =fltarr(201) 
    z_high_bound=fltarr(201)
    zlim_comvol =fltarr(201)
    comdis_low  =fltarr(201)
    comdis_high =fltarr(201)
    
    if keyword_set(dr10) then begin 
        pthalo_file = chichidir+'nbar-dr10v5-N-Anderson.dat'
    endif else begin 
        pthalo_file = '/mount/riachuelo1/hahn/data/manera_mock/dr11/nbar-cmass-dr11may22-N-Anderson.dat'
    endelse  

    readcol, pthalo_file, z_mid,z_low,z_high,nbarz,wfkp,shell_vol,gal_tot
    for i=0L,200L do begin 
        z_low_bound[i]  = z_low[i]
        z_mid_bound[i]  = z_mid[i]
        z_high_bound[i] = z_high[i]
        zlim_comvol[i]  = shell_vol[i]
        comdis_low[i]   = 3000.0*comdis(z_low_bound[i],om0,ol0) 
        comdis_high[i]  = 3000.0*comdis(z_high_bound[i],om0,ol0) 
    endfor 
    
    if keyword_set(cmass) then begin 
        total_gals = total(gal_tot)
        print, total_gals
        for i=0L,200L do begin
            zlim_nbar[i] = nbarz[i]*zlim_comvol[i]/total_gals
        endfor 
        zlim_nbar = zlim_nbar/total(zlim_nbar[where(z_mid_bound gt 0.43 and z_mid_bound lt 0.7)])
        out_fname = 'nbar-normed-cmass-dr11may22-N-Anderson.dat'
        if keyword_set(dr10) then out_fname = 'nbar-normed-dr10v5-N-Anderson.dat'
    endif 
    
    if keyword_set(noweight) then begin 
        data_fname = datadir+'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            version+'.wghtv.txt'
        if keyword_set(dr10) then data_fname = chichidir+'cmass_dr10_north_ir4'+$
            strmid(strtrim(string(n+1000),1),1)+'.v5.2.wghtv.txt' 
        readcol, data_fname, ra, dec, az, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1,$
            m2, veto
        vetomask= where(veto EQ 1)
        az      = az[vetomask]
        w_boss  = w_boss[vetomask]
        w_cp    = w_cp[vetomask]
        w_red   = w_red[vetomask] 
        
        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            weights[i]  = 1.0 
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
;        total_gals  = total(double(w_cp+w_red-1.0))

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if (count_zlim GT 0) then zlim_count = (total(weights[zlim])/weights_max);*total_gals
           zlim_nbar[i] = zlim_count;/zlim_comvol[i] 
        endfor
        zlim_nbar = zlim_nbar/total(zlim_nbar)
        out_fname = 'nbar-normed-cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+version+'.noweight.txt'
        if keyword_set(dr10) then out_fname = 'nbar-normed-cmass_dr10_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            '.v5.2.noweight.txt'
        print,out_fname
    endif 
    
    if keyword_set(wboss) then begin 
        data_fname = datadir+'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            version+'.wghtv.txt'
        if keyword_set(dr10) then data_fname = chichidir+'cmass_dr10_north_ir4'+$
            strmid(strtrim(string(n+1000),1),1)+'.v5.2.wghtv.txt' 
        readcol, data_fname, ra, dec, az, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1,$
            m2, veto
        vetomask= where(veto EQ 1)
        az      = az[vetomask]
        w_boss  = w_boss[vetomask]
        w_cp    = w_cp[vetomask]
        w_red   = w_red[vetomask] 
        
        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            if (w_boss[i] GT 0) then begin
                weights[i]  = 1.0 
            endif else begin
                weights[i]  = 0.0 
            endelse
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if (count_zlim GT 0) then zlim_count = (total(weights[zlim])/weights_max);*total_gals
           zlim_nbar[i] = zlim_count;/zlim_comvol[i] 
        endfor
        zlim_nbar = zlim_nbar/total(zlim_nbar)
        out_fname = 'nbar-normed-cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+version+'.wboss.txt'
        if keyword_set(dr10) then out_fname = 'nbar-normed-cmass_dr10_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            '.v5.2.wboss.txt'
        print,out_fname
    endif 

    if keyword_set(upweight) then begin 
        data_fname = datadir+'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            version+'.wghtv.txt'
        if keyword_set(dr10) then data_fname = chichidir+'cmass_dr10_north_ir4'+$
            strmid(strtrim(string(n+1000),1),1)+'.v5.2.wghtv.txt' 
        readcol, data_fname, ra, dec, az, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1,$
            m2, veto
        vetomask= where(veto EQ 1)
        az     = az[vetomask]
        w_boss  = w_boss[vetomask]
        w_cp    = w_cp[vetomask]
        w_red   = w_red[vetomask] 

        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin
                weights[i]  = double(w_cp[i]+w_red[i]-1.0)
            endif else begin
                weights[i]  = 0.0
            endelse
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
;        total_gals  = total(double(w_cp+w_red-1.0))

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if (count_zlim GT 0) then zlim_count = (total(weights[zlim])/weights_max);*total_gals
           zlim_nbar[i] = zlim_count;/zlim_comvol[i] 
        endfor
        zlim_nbar = zlim_nbar/total(zlim_nbar)
        out_fname = 'nbar-normed-cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+version+'.upweight.txt'
        if keyword_set(dr10) then out_fname = 'nbar-normed-cmass_dr10_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            '.v5.2.upweight.txt'
        print,out_fname
    endif 

    if keyword_set(shuffle) then begin
        data_fname = 'shuffle_zlim_cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)$
           +version+'.wghtv.txt' 
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, dc, ipoly, w_boss, w_cp, w_red, redtrue, flag,$
           m1, m2, veto

        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin
                weights[i]  = double(w_cp[i]+w_red[i]-1.0)
            endif else begin
                weights[i]  = 0.0 
            endelse
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
        total_gals  = total(double(w_cp+w_red-1.0))

        for i=0L,200L do begin 
           zlim = where(dc ge comdis_low[i] and dc lt comdis_high[i],count_zlim)
           zlim_count = 0.0
           if count_zlim ne 0 then zlim_count = (total(weights[where(zlim)])/weights_max);*total_gals
           zlim_nbar[i] = zlim_count;/zlim_comvol[i] 
        endfor
        out_fname = 'nbar-normed-'+data_fname
    endif 
    
    if keyword_set(peaknbar) then begin
        data_fname = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)$
           +version+'.peakcorr.txt'
        print,datadir+data_fname
        readcol, datadir+data_fname, ra,dec,az,w_boss,w_red,w_cp,veto
        vetomask= where(veto EQ 1)
        az     = az[vetomask]
        w_boss  = w_boss[vetomask]
        w_cp    = w_cp[vetomask]
        w_red   = w_red[vetomask] 

        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin 
                weights[i]  = double(w_boss[i])*double(w_cp[i]+w_red[i]-1.0) 
            endif else begin 
                weights[i]  = 0.0
            endelse 
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)
        total_gals  = total(double(w_cp+w_red-1.0))

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if (count_zlim GT 0) then zlim_count = (total(weights[zlim])/weights_max);*total_gals
           zlim_nbar[i] = zlim_count;/zlim_comvol[i] 
        endfor  
        ;print, total(zlim_nbar[where(z_mid_bound gt 0.43 and z_mid_bound lt 0.7)]),total(zlim_nbar)
        zlim_nbar = zlim_nbar/total(zlim_nbar)
        out_fname = 'nbar-normed-'+data_fname
    endif 
    
    if keyword_set(random) then begin
        data_fname = datadir+'cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            version+'.wghtv.txt'
        ;if keyword_set(dr10) then data_fname = chichidir+'cmass_dr10_north_randoms_ir4'+$
        ;    strmid(strtrim(string(n+1000),1),1)+'.v5.2.wghtv.txt'
        print,data_fname

        readcol,data_fname,ra,dec,az,ipoly,w_boss,w_cp,w_red,veto
        vetomask= where(veto EQ 1)
        az     = az[vetomask]
        w_boss  = w_boss[vetomask]
        w_cp    = w_cp[vetomask]
        w_red   = w_red[vetomask] 
       
;        weights = fltarr(n_elements(w_boss))
;        for i=0L,n_elements(w_boss)-1L do begin 
;            weights[i] = 1.0
;            if (w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0) then begin 
;                weights[i]  = double(w_boss[i])
;            endif else begin 
;                weights[i]  = double(w_cp[i]+w_red[i]-1.0) 
;            endelse 
;        endfor 
        
        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin
                weights[i]  = double(w_cp[i]+w_red[i]-1.0)
            endif else begin
                weights[i]  = 0.0
            endelse
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if (count_zlim GT 0) then zlim_count = (total(weights[zlim])/weights_max);*total_gals
           zlim_nbar[i] = zlim_count;/zlim_comvol[i] 
        endfor
        zlim_nbar = zlim_nbar/total(zlim_nbar)
        ;out_fname = 'nbar-normed-cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
        ;    version+'.upweight.txt'
        out_fname = 'nbar-normed-cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            version+'.wghtv.txt'
        ;if keyword_set(dr10) then out_fname = 'nbar-normed-cmass_dr10_north_randoms_ir4'+$
        ;    strmid(strtrim(string(n+1000),1),1)+'.v5.2.wghtv.txt'
    endif 
    
    if keyword_set(randpeak) then begin
        data_fname='cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
            version+'.peakcorr.txt'
        print,datadir+data_fname

        readcol,datadir+data_fname,ra,dec,az,ipoly,w_boss,w_cp,w_red,veto
        
        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            weights[i] = 1.0
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if (count_zlim GT 0) then zlim_count = (total(weights[zlim])/weights_max);*total_gals
           zlim_nbar[i] = zlim_count;/zlim_comvol[i] 
        endfor
        zlim_nbar = zlim_nbar/total(zlim_nbar)
        out_fname = 'nbar-normed-'+data_fname
    endif 
    if keyword_set(combined) then begin 
        ;data_fname = 'cmass_dr11_north_25_randoms_ir4_combined.v7.0.wboss.txt'
        ;data_fname = 'cmass_dr11_north_25_randoms_ir4_combined.v7.0.wboss.veto.txt' 
        ;data_fname = 'cmass_dr11_north_25_randoms_ir4_combined_wghtr.v7.0.peakcorr.txt'
        data_fname = 'cmass_dr11_north_25_randoms_ir4_combined.v7.0.upweight.txt'
        print,data_fname

        readcol,datadir+data_fname,ra,dec,az,w_boss,w_cp,w_red
        
        weights = fltarr(n_elements(w_boss))
        for i=0L,n_elements(w_boss)-1L do begin 
            weights[i]  = 1.0
        endfor 
        weights_cum = total(weights,/cumulative)
        weights_max = max(weights_cum)

        for i=0L,200L do begin 
           zlim = where(az ge z_low_bound[i] and az lt z_high_bound[i],count_zlim)
           zlim_count = 0.0
           if (count_zlim GT 0) then zlim_count = (total(weights[zlim])/weights_max)
           zlim_nbar[i] = zlim_count
        endfor
        zlim_nbar = zlim_nbar/total(zlim_nbar)
        out_fname = 'nbar-normed-'+data_fname
    endif 

    openw,lun,datadir+out_fname,/get_lun 
    for i=0L,200L do printf,lun,z_mid_bound[i],z_low_bound[i],z_high_bound[i],zlim_nbar[i],$
        format='(4F)'
    free_lun,lun
end 
