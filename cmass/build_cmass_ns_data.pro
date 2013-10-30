pro build_cmass_ns_data,dr_version,north=north,south=south,nzw=nzw,weights=weights
    path = '/global/data/scr/chh327/powercode/data/'

    if keyword_set(north) then NSstr = 'N'
    if keyword_set(south) then NSstr = 'S'
    data = mrdfits(path+'cmass-'+dr_version+'-'+NSstr+'-Anderson.dat.fits',1)

    zindx   = where(data.z ge 0.43 and data.z le 0.7) 
    gal     = data[zindx] 

    ra      = dblarr(n_elements(gal))
    dec     = dblarr(n_elements(gal))
    z       = dblarr(n_elements(gal))
    weight  = dblarr(n_elements(gal))
    nbar    = dblarr(n_elements(gal))

    ra  = gal.ra
    dec = gal.dec
    z   = gal.z
    
    riadir = '/mount/riachuelo1/hahn/data/'
    if keyword_set(nzw) then begin 
        file = riadir+'cmass-'+dr_version+'-'+NSstr+'-Anderson-nzw-zlim.dat'
    endif 
    if keyword_set(weights) then begin
        file = riadir+'cmass-'+dr_version+'-'+NSstr+'-Anderson-weights-zlim.dat'
    endif

    if keyword_set(nzw) then begin
        weight = gal.weight_fkp*gal.weight_star*(gal.weight_noz+gal.weight_cp-1.0)
    endif
    if keyword_set(weights) then begin
        w_star  = gal.weight_star
        w_noz   = gal.weight_noz
        w_cp    = gal.weight_cp 
    endif
    nbar = gal.nz 
    
    if keyword_set(nzw) then begin  
        openw, lun, file, /get_lun
            for i=0L,n_elements(gal)-1L do printf, lun, ra[i], dec[i], z[i], w[i], nbar[i], format='(f,f,f,f,f)'
        free_lun, lun 
    endif 
    if keyword_set(weights) then begin 
        openw, lun, file, /get_lun 
            for i=0L,n_elements(gal)-1L do printf, lun, ra[i], dec[i], z[i], w_star[i], w_noz[i],$
                w_cp[i], nbar[i], format='(f,f,f,f,f,f,f)'
        free_lun, lun 
    endif 
    
    ran_data= mrdfits(path+'cmass-'+dr_version+'-'+NSstr+'-Anderson.ran.fits',1)
    zindx   = where(ran_data.z ge 0.43 and ran_data.z le 0.7) 
    ran_gal = ran_data[zindx]

    rra     = dblarr(n_elements(ran_gal))
    rdec    = dblarr(n_elements(ran_gal))
    rz      = dblarr(n_elements(ran_gal))
    rweight = dblarr(n_elements(ran_gal))
    rnbar   = dblarr(n_elements(ran_gal))

    rra     = ran_gal.ra
    rdec    = ran_gal.dec
    rz      = ran_gal.z
    rnbar   = ran_gal.nz
    if keyword_set(nzw) then begin 
        rweight = ran_gal.weight_fkp
    endif
    if keyword_set(weights) then begin 
        for i=0L,n_elements(rra)-1L do rweight[i] = 1.0
    endif
    
    if keyword_set(nzw) then begin 
        ran_file    = riadir+'cmass-'+dr_version+'-'+NSstr+'-Anderson-nzw-zlim.ran.dat' 
        openw, lun, ran_file,/get_lun
            for i=0L,n_elements(ran_gal)-1L do printf,lun,rra[i],rdec[i],rz[i],rweight[i], rnbar[i], format='(f,f,f,f,f)'
        free_lun, lun
    endif
    if keyword_set(weights) then begin 
        ran_file    = riadir+'cmass-'+dr_version+'-'+NSstr+'-Anderson-weights-zlim.ran.dat'
        openw, lun, ran_file,/get_lun
            for i=0L,n_elements(ran_gal)-1L do printf,lun,rra[i],rdec[i],rz[i],rnbar[i], format='(f,f,f,f)'
        free_lun, lun
    endif
end
