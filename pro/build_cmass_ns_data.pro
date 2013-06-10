pro build_cmass_ns_data,prename,endname,nzw=nzw,wcomp=wcomp
    path = get_path(/powercode)

    Ngal = mrdfits(path+'data/'+prename+'-N-'+endname+'.dat.fits',1)
    Sgal = mrdfits(path+'data/'+prename+'-S-'+endname+'.dat.fits',1)

    nzindx = where(Ngal.z ge 0.43 and Ngal.z le 0.7) 
    szindx = where(Sgal.z ge 0.43 and Sgal.z le 0.7)

    ndata = ngal[nzindx]
    sdata = sgal[szindx]

    ra = dblarr(n_elements(ndata)+n_elements(sdata))
    dec = dblarr(n_elements(ndata)+n_elements(sdata))
    z = dblarr(n_elements(ndata)+n_elements(sdata))
    weight = dblarr(n_elements(ndata)+n_elements(sdata))
    nbar = dblarr(n_elements(ndata)+n_elements(sdata))


    ra[0:n_elements(ndata)-1L] = ndata.ra
    ra[n_elements(ndata):n_elements(ndata)+n_elements(sdata)-1L] = sdata.ra
    dec[0:n_elements(ndata)-1L] = ndata.dec
    dec[n_elements(ndata):n_elements(ndata)+n_elements(sdata)-1L] = sdata.dec
    z[0:n_elements(ndata)-1L] = ndata.z
    z[n_elements(ndata):n_elements(ndata)+n_elements(sdata)-1L] = sdata.z

    if keyword_set(nzw) then begin 
        nsfname = prename+'-full-'+endname+'-nzw-zlim.dat'
        nfname = prename+'-N-'+endname+'-nzw-zlim.dat'
        sfname = prename+'-S-'+endname+'-nzw-zlim.dat'
    endif 
    if keyword_set(wcomp) then begin
        nsfname = prename+'-full-'+endname+'-wcomp.dat'
        nfname = prename+'-N-'+endname+'-wcomp.dat'
        sfname = prename+'-S-'+endname+'-wcomp.dat'
    endif

    if keyword_set(nzw) then begin
        weight[0:n_elements(ndata)-1L] = ndata.weight_fkp*ndata.weight_star*(ndata.weight_noz+ndata.weight_cp-1.0)
        weight[n_elements(ndata):n_elements(ndata)+n_elements(sdata)-1L] = sdata.weight_fkp*sdata.weight_star*(sdata.weight_noz+sdata.weight_cp-1.0)
    endif
    if keyword_set(wcomp) then begin 
        weight[0:n_elements(ndata)-1L] = ndata.weight_star*(ndata.weight_noz+ndata.weight_cp-1.0)
        weight[n_elements(ndata):n_elements(ndata)+n_elements(sdata)-1L] = sdata.weight_star*(sdata.weight_noz+sdata.weight_cp-1.0)
    endif
    nbar[0:n_elements(ndata)-1L] = ndata.nz 
    nbar[n_elements(ndata):n_elements(ndata)+n_elements(sdata)-1L] = sdata.nz
    
    openw, lun, path+'data/'+nfname, /get_lun
        for i=0L,n_elements(ndata)-1L do printf, lun, ra[i], dec[i], z[i], weight[i], nbar[i], format='(f,f,f,f,f)'
    free_lun, lun 
    openw, lun, path+'data/'+sfname, /get_lun
        for i=n_elements(ndata),n_elements(ndata)+n_elements(sdata)-1L do printf, lun, ra[i], dec[i], z[i], weight[i], nbar[i], format='(f,f,f,f,f)'
    free_lun, lun
    openw, lun, path+'data/'+nsfname, /get_lun
        for i=0L,n_elements(ra)-1L do printf, lun, ra[i], dec[i], z[i], weight[i], nbar[i], format='(f,f,f,f,f)'
    free_lun, lun 
    
    nran = mrdfits(path+'data/'+prename+'-N-'+endname+'.ran.fits',1)
    sran = mrdfits(path+'data/'+prename+'-S-'+endname+'.ran.fits',1)
    nrzindx=where(nran.z ge 0.43 and nran.z le 0.7)
    srzindx=where(sran.z ge 0.43 and sran.z le 0.7)
    nrand=nran[nrzindx]
    srand=sran[srzindx]

    rra = dblarr(n_elements(nrand)+n_elements(srand))
    rdec = dblarr(n_elements(nrand)+n_elements(srand))
    rz = dblarr(n_elements(nrand)+n_elements(srand))
    rweight = dblarr(n_elements(nrand)+n_elements(srand))
    rnbar = dblarr(n_elements(nrand)+n_elements(srand))


    rra[0:n_elements(nrand)-1L] = nrand.ra
    rra[n_elements(nrand):n_elements(nrand)+n_elements(srand)-1L] = srand.ra
    rdec[0:n_elements(nrand)-1L] = nrand.dec
    rdec[n_elements(nrand):n_elements(nrand)+n_elements(srand)-1L] = srand.dec
    rz[0:n_elements(nrand)-1L] = nrand.z
    rz[n_elements(nrand):n_elements(nrand)+n_elements(srand)-1L] = srand.z
    
    rweight = dblarr(n_elements(rra))
    if keyword_set(nzw) then begin 
        rweight[0:n_elements(nrand)-1L] = nrand.weight_fkp
        rweight[n_elements(nrand):n_elements(nrand)+n_elements(srand)-1L] = srand.weight_fkp
    endif
    if keyword_set(wcomp) then begin 
        for i=0L,n_elements(rra)-1L do rweight[i] = 1.0
    endif
    rnbar[0:n_elements(nrand)-1L] = nrand.nz
    rnbar[n_elements(nrand):n_elements(nrand)+n_elements(srand)-1L] = srand.nz
    
    if keyword_set(nzw) then begin 
        nsfname = prename+'-full-'+endname+'-nzw-zlim.ran.dat' 
        nfname = prename+'-N-'+endname+'-nzw-zlim.ran.dat'
        sfname = prename+'-S-'+endname+'-nzw-zlim.ran.dat'
    endif
    if keyword_set(wcomp) then begin 
        nsfname = prename+'-full-'+endname+'-wcomp.ran.dat'
        nfname = prename+'-N-'+endname+'-wcomp.ran.dat'
        sfname = prename+'-S-'+endname+'-wcomp.ran.dat'
    endif
    openw, lun, path+'data/'+nfname,/get_lun
        for i=0L,n_elements(nrand)-1L do printf,lun,rra[i],rdec[i],rz[i],rweight[i], rnbar[i], format='(f,f,f,f,f)'
    free_lun, lun
    openw, lun, path+'data/'+sfname,/get_lun
        for i=n_elements(nrand),n_elements(nrand)+n_elements(srand)-1L do printf,lun,rra[i],rdec[i],rz[i],rweight[i], rnbar[i], format='(f,f,f,f,f)'
    free_lun, lun
    openw, lun, path+'data/'+nsfname,/get_lun
        for i=0L,n_elements(rra)-1L do printf,lun,rra[i],rdec[i],rz[i],rweight[i], rnbar[i], format='(f,f,f,f,f)'
    free_lun, lun
end
