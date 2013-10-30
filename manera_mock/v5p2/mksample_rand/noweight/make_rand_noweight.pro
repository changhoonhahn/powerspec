pro make_rand_noweight,n,zseed,datadir,dataprefix,datasuffix,randprefix,output_file
    data_file   = dataprefix+strmid(strtrim(string(n+1000),1),1)+datasuffix
    rand_file   = randprefix+strmid(strtrim(string(n+1000),1),1)+datasuffix
    readcol, datadir+data_file, ra, dec, az, w_boss, w_red, w_cp, veto
    vetomask = where(veto EQ 1) 
    ra      = ra[vetomask]
    dec     = dec[vetomask]
    az      = az[vetomask] 
    w_boss  = w_boss[vetomask] 
    w_red   = w_red[vetomask] 
    w_cp    = w_cp[vetomask] 

    readcol, datadir+rand_file, rand_ra, rand_dec, rand_red, rand_ipoly, rand_w_boss, rand_w_cp,$
        rand_w_red, rand_veto
    vetomask_rand = where(rand_veto EQ 1)
    rand_ra     = rand_ra[vetomask_rand]
    rand_dec    = rand_dec[vetomask_rand]
    rand_ipoly  = rand_ipoly[vetomask_rand] 
    rand_w_boss = rand_w_boss[vetomask_rand]
    rand_w_cp   = rand_w_cp[vetomask_rand]
    rand_w_red  = rand_w_red[vetomask_rand]

    Ndata   = n_elements(ra)
    Nran    = n_elements(rand_ra)
    rand_az = fltarr(Nran)

    print,' data galaxies   =',Ndata
    print,' rand galaxies   =',Nran
    weights = fltarr(n_elements(w_boss))
    for i=0L,n_elements(w_boss)-1L do begin 
        weights[i] = 1.0
    endfor 
    data_weight_cum = total(weights,/cumulative)
    data_weight_max = max(data_weight_cum) 

    ranz = randomu(long(zseed),Nran)*data_weight_max  
    for iii=0L,Nran-1L do begin 
        xx = where(data_weight_cum GE ranz[iii],countxx) 
        if(countxx EQ 0) then begin
            print,'redshift assigning random problem'
            stop 
        endif
        zindx = min(xx)
        rand_az[iii] = az[zindx]
    endfor
    
;    output_file = randprefix+strmid(strtrim(string(n+1000),1),1)+outsuffix
    openw,lun,output_file,/get_lun
    for i=0L,Nran-1L do printf,lun,rand_ra[i],rand_dec[i],rand_az[i],rand_ipoly[i],rand_w_boss[i],rand_w_cp[i],$
        rand_w_red[i],rand_veto[i],format='(8F)'
    free_lun,lun 
end
