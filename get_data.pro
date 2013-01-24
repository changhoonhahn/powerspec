pro get_data, name, nzw=nzw, wcomp=wcomp
    path = get_path(/powercode)

    gal = mrdfits(path+'data/'+name+'.dat.fits',1)
    indx= where(gal.z ge 0.0)

    if (min(gal.z) lt 0.0) then begin
        data = gal[indx] 
    endif
    ra = data.ra
    dec = data.dec
    z = data.z 
    if keyword_set(nzw) then weight = data.weight_fkp*data.weight_star*(data.weight_noz+data.weight_cp-1.0)
    if keyword_set(wcomp) then weight = data.weight_star*(data.weight_noz+data.weight_cp-1.0)
    nbar = data.nz 

    if keyword_set(nzw) then fname = name+'-nzw.dat'
    if keyword_set(wcomp) then fname = name+'-wcomp.dat'
    openw, lun, path+'data/'+fname, /get_lun
        for i=0L,n_elements(ra)-1L do printf, lun, ra[i], dec[i], z[i], weight[i], nbar[i], format='(f,f,f,f,f)'
    free_lun, lun 
    
    ran = mrdfits(path+'data/'+name+'.ran.fits',1)
    rindx= where(ran.z ge 0.0)

    if (min(ran.z) lt 0.0) then begin
        rand = ran[rindx]
    endif

    rra = rand.ra
    rdec = rand.dec
    rz = rand.z
    rweight = dblarr(n_elements(rra))
    if keyword_set(nzw) then rweight = rand.weight_fkp
    if keyword_set(wcomp) then begin 
        for i=0L,n_elements(rra)-1L do rweight[i] = 1.0
    endif
    rnbar = rand.nz
    
    if keyword_set(nzw) then fname = name+'-nzw.ran.dat'
    if keyword_set(wcomp) then fname = name+'-wcomp.ran.dat'
    openw, lun, path+'data/'+fname,/get_lun
        for i=0L,n_elements(rra)-1L do printf,lun,rra[i],rdec[i],rz[i],rweight[i], rnbar[i], format='(f,f,f,f,f)'
    free_lun, lun
end
