pro build_cmass_data,name,weight,nzw=nzw,wcomp=wcomp
    path = get_path(/powercode)

    if n_elements(weight) eq 0 then begin 
        gal = mrdfits(path+'data/'+name+'.dat.fits',1)
    endif else begin 
        gala = mrdfits(path+'data/'+name+'.dat.fits',1)
        readcol,path+'data/'+weight,w_star

        weights=replicate({wstar:0.},n_elements(w_star))
        weights.wstar=w_star

        gal = struct_addtags(gala,weights)
        print, mean(gal.weight_star - gal.wstar)
    endelse 
;    indx= where(gal.z ge 0.0)

;    if (min(gal.z) lt 0.0) then begin
;        data = gal[indx] 
;    endif
    zindx = where(gal.z ge 0.43 and gal.z le 0.7) 
    data = gal[zindx]

    ra = data.ra
    dec = data.dec
    z = data.z 
    if n_elements(weight) eq 0 then ws = data.weight_star
    if n_elements(weight) ne 0 then ws = data.wstar

    if keyword_set(nzw) then begin
        if n_elements(weight) eq 0 then fname = name+'-nzw-zlim.dat'
        if n_elements(weight) ne 0 then fname = name+'-wstar-nzw.dat'
    endif
    if keyword_set(wcomp) then fname = name+'-wcomp.dat'

    if keyword_set(nzw) then weight = data.weight_fkp*ws*(data.weight_noz+data.weight_cp-1.0)
    if keyword_set(wcomp) then weight = data.weight_star*(data.weight_noz+data.weight_cp-1.0)
    nbar = data.nz 
    
    openw, lun, path+'data/'+fname, /get_lun
        for i=0L,n_elements(ra)-1L do printf, lun, ra[i], dec[i], z[i], weight[i], nbar[i], format='(f,f,f,f,f)'
    free_lun, lun 
    
    ran = mrdfits(path+'data/'+name+'.ran.fits',1)
;    rindx= where(ran.z ge 0.0)

;    if (min(ran.z) lt 0.0) then begin
;        rand = ran[rindx]
;    endif

    rzindx=where(ran.z ge 0.43 and ran.z le 0.7)
    rand=ran[rzindx]

    rra = rand.ra
    rdec = rand.dec
    rz = rand.z
    rweight = dblarr(n_elements(rra))
    if keyword_set(nzw) then rweight = rand.weight_fkp
    if keyword_set(wcomp) then begin 
        for i=0L,n_elements(rra)-1L do rweight[i] = 1.0
    endif
    rnbar = rand.nz
    
    if keyword_set(nzw) then fname = name+'-nzw-zlim.ran.dat'
    if keyword_set(wcomp) then fname = name+'-wcomp.ran.dat'
    openw, lun, path+'data/'+fname,/get_lun
        for i=0L,n_elements(rra)-1L do printf,lun,rra[i],rdec[i],rz[i],rweight[i], rnbar[i], format='(f,f,f,f,f)'
    free_lun, lun
end
