pro build_data_NS, data=data, random=random
    if keyword_set(data) then begin 
    path = get_path(/powercode)+'data/'
    N = mrdfits(path+'cmass-dr10v3-N-Anderson.dat.fits',1)
    ncount = n_elements(N)
    S = mrdfits(path+'cmass-dr10v3-S-Anderson.dat.fits',1)
    scount = n_elements(S)

    data = replicate({ra:0.D,dec:0.D,z:0.,weight_fkp:0.,weight_cp:0.,weight_noz:0.,weight_star:0.,nz:0.},ncount+scount)
    totcount = ncount+scount
    data[0L:ncount-1L].ra = N.ra
    data[0L:ncount-1L].dec = N.dec
    data[0L:ncount-1L].z = N.z
    data[0L:ncount-1L].weight_fkp = N.weight_fkp
    data[0L:ncount-1L].weight_cp = N.weight_cp
    data[0L:ncount-1L].weight_noz = N.weight_noz
    data[0L:ncount-1L].weight_star = N.weight_star
    data[0L:ncount-1L].nz = N.nz

    data[ncount:totcount-1L].ra = S.ra
    data[ncount:totcount-1L].dec = S.dec
    data[ncount:totcount-1L].z = S.z
    data[ncount:totcount-1L].weight_fkp = S.weight_fkp
    data[ncount:totcount-1L].weight_cp = S.weight_cp
    data[ncount:totcount-1L].weight_noz = S.weight_noz
    data[ncount:totcount-1L].weight_star = S.weight_star
    data[ncount:totcount-1L].nz = S.nz

    indx = where(data.z ge 0.0)
    output = data[indx] 
    ra = output.ra
    dec = output.dec 
    z = output.z
    w = output.weight_fkp*output.weight_star*(output.weight_cp+output.weight_noz-1.0)
    nbar = output.nz
    openw, lun, path+'cmass-dr10v3-NS-Anderson.dat', /get_lun
        for i=0L, n_elements(ra)-1L do printf, lun, ra[i],dec[i],z[i],w[i],nbar[i],format='(f,f,f,f,f)'
    free_lun, lun
    endif

    if keyword_set(random) then begin
        path = get_path(/powercode)+'data/'
        N = mrdfits(path+'cmass-dr10v3-N-Anderson.ran.fits',1)
        ncount = n_elements(N)
        S = mrdfits(path+'cmass-dr10v3-S-Anderson.ran.fits',1)
        scount = n_elements(S)
                     
        data = replicate({ra:0.D,dec:0.D,z:0.,weight_fkp:0.,nz:0.},ncount+scount)
        totcount = ncount+scount
        data[0L:ncount-1L].ra = N.ra
        data[0L:ncount-1L].dec = N.dec
        data[0L:ncount-1L].z = N.z
        data[0L:ncount-1L].weight_fkp = N.weight_fkp
        data[0L:ncount-1L].nz = N.nz

        data[ncount:totcount-1L].ra = S.ra
        data[ncount:totcount-1L].dec = S.dec
        data[ncount:totcount-1L].z = S.z
        data[ncount:totcount-1L].weight_fkp = S.weight_fkp
        data[ncount:totcount-1L].nz = S.nz
    
        indx = where(data.z ge 0.0)
        output = data[indx]
        ra = output.ra
        dec = output.dec
        z = output.z
        w = output.weight_fkp
        nbar = output.nz
        openw, lun, path+'cmass-dr10v3-NS-Anderson.ran.dat', /get_lun
            for i=0L, n_elements(ra)-1L do printf, lun, ra[i],dec[i],z[i],w[i],nbar[i],format='(f,f,f,f,f)'
        free_lun, lun
    endif
end

