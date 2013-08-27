pro fibcoll_make_rand_dloscorr,n,zseed
    datadir     = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    data_file   = 'shuffle_zlim_cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
        '.v7.0.wghtv.txt'
    rand_file   = 'cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
        '.v7.0.wghtv.txt'
    
    readcol, datadir+data_file, ra, dec, dc, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2,$
        veto 
    readcol, datadir+rand_file, rand_ra, rand_dec, rand_red, rand_ipoly, rand_w_boss, rand_w_cp,$
        rand_w_red, rand_veto
    Ndata   = n_elements(ra)
    Nran    = n_elements(rand_ra)
    rand_dc = dblarr(Nran)

    print,' data galaxies   =',Ndata
    print,' rand galaxies   =',Nran
    data_weight = dblarr(n_elements(w_boss))
    for i=0L,n_elements(w_boss)-1L do begin 
        if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin 
            data_weight[i] = w_boss[i]*(w_cp[i] + w_red[i] -1.0)
        endif else begin 
            data_weight[i] = 0.0
        endelse 
    endfor  
    data_weight_cum = total(data_weight, /cumulative)
    data_weight_max = max(data_weight_cum) 

    ranz = randomu(long(zseed),Nran)*data_weight_max  

    for iii=0L,Nran-1L do begin 
        xx = where(data_weight_cum GE ranz[iii],countxx) 
        if(countxx EQ 0) then begin
            print,'redshift assigning random problem'
            stop 
        endif
        zindx = min(xx)
        rand_dc[iii] = dc[zindx]
    endfor
    
    output_file = 'cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
        '_dlosshfl_corr.v7.0.wghtv.txt'
    openw,lun,datadir+output_file,/get_lun
    for i=0L,Nran-1L do printf,lun,rand_ra[i],rand_dec[i],rand_dc[i],rand_w_boss[i],rand_w_cp[i],$
        rand_w_red[i],rand_veto[i],format='(7F)'
    free_lun,lun 
end
