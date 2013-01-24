pro build_data_cmass, North=North, South=South, NS=NS, data=data, random=random, nzw=nzw, weight=weight
    path = get_path(/powercode)+'data/'
    if n_elements(data) eq 1 and n_elements(nzw) eq 0 and n_elements(weight) eq 0 then print, 'Specify NZW or Weight!'
    if keyword_set(data) then begin 
        N = mrdfits(path+'cmass-dr10v3-N-Anderson.dat.fits',1)
        ncount = n_elements(N)
        S = mrdfits(path+'cmass-dr10v3-S-Anderson.dat.fits',1)
        scount = n_elements(S)
        datum = {ra:0.D,dec:0.D,z:0.,weight_fkp:0.,weight_cp:0.,weight_noz:0.,weight_star:0.,nz:0.}

        if keyword_set(North) then begin
            Ndata = replicate(datum, ncount)
            Ndata.ra = N.ra
            Ndata.dec = N.dec
            Ndata.z = N.z
            Ndata.weight_fkp = N.weight_fkp
            Ndata.weight_cp = N.weight_cp
            Ndata.weight_noz = N.weight_noz
            Ndata.weight_star = N.weight_star
            Ndata.nz = N.nz
            zlim = where(Ndata.z ge 0.0)
            output = Ndata[zlim]
            ra = output.ra
            dec = output.dec
            z = output.z
;            w = output.weight_star*(output.weight_cp+output.weight_noz-1.0)
            if keyword_set(nzw) then begin
                w = output.weight_fkp*outputoutput.weight_star*(output.weight_cp+output.weight_noz-1.0)
                fname = 'cmass-dr10v3-N-Anderson_nzw.dat'
            endif 
            if keyword_set(weight) then begin
                w = output.weight_star*(output.weight_cp+output.weight_noz-1.0)
                fname = 'cmass-dr10v3-N-Anderson_weight.dat'
            endif
            nbar = output.nz

            openw, lun, path+fname, /get_lun
                for i=0L, n_elements(ra)-1L do printf, lun, ra[i],dec[i],z[i],w[i],nbar[i],format='(f,f,f,f,f)'
            free_lun, lun
        endif

        if keyword_set(South) then begin
            Sdata = replicate(datum, scount)
            Sdata.ra = S.ra
            Sdata.dec = S.dec
            Sdata.z = S.z
            Sdata.weight_fkp = S.weight_fkp
            Sdata.weight_cp = S.weight_cp
            Sdata.weight_noz = S.weight_noz
            Sdata.weight_star = S.weight_star
            Sdata.nz = S.nz
            zlim = where(Sdata.z ge 0.0)
            output = Sdata[zlim]
            ra = output.ra
            dec = output.dec
            z = output.z
            if keyword_set(nzw) then begin
                w = output.weight_fkp*output.weight_star*(output.weight_cp+output.weight_noz-1.0)
                fname = 'cmass-dr10v3-S-Anderson_nzw.dat'
            endif
            if keyword_set(weight) then begin
                w = output.weight_star*(output.weight_cp+output.weight_noz-1.0)
                fname = 'cmass-dr10v3-S-Anderson_weight.dat'
            endif
            nbar = output.nz
            openw, lun, path+fname, /get_lun
                for i=0L, n_elements(ra)-1L do printf, lun, ra[i],dec[i],z[i],w[i],nbar[i],format='(f,f,f,f,f)'
            free_lun, lun
        endif

        if keyword_set(NS) then begin 
            data = replicate(datum,ncount+scount)
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
            print, 'Fraction of data included within z-cut:', float(n_elements(output))/float(totcount)
            ra = output.ra
            dec = output.dec 
            z = output.z
            if keyword_set(nzw) then begin
                w = output.weight_fkp*output.weight_star*(output.weight_cp+output.weight_noz-1.0)
                fname = 'cmass-dr10v3-NS-Anderson_nzw.dat'
            endif
            if keyword_set(weight) then begin
                w = output.weight_star*(output.weight_cp+output.weight_noz-1.0)
                fname = 'cmass-dr10v3-NS-Anderson_weight.dat'
            endif
            nbar = output.nz
            openw, lun, path+fname, /get_lun
                for i=0L, n_elements(ra)-1L do printf, lun, ra[i],dec[i],z[i],w[i],nbar[i],format='(f,f,f,f,f)'
            free_lun, lun
        endif
    endif

    if keyword_set(random) then begin
        path = get_path(/powercode)+'data/'
        N = mrdfits(path+'cmass-dr10v3-N-Anderson.ran.fits',1)
        ncount = n_elements(N)
        S = mrdfits(path+'cmass-dr10v3-S-Anderson.ran.fits',1)
        scount = n_elements(S)
        datum = {ra:0.D,dec:0.D,z:0.,weight_fkp:0.,nz:0.}

        if keyword_set(North) then begin
            data = replicate(datum,ncount)
            data.ra = N.ra
            data.dec = N.dec
            data.z = N.z
            data.weight_fkp = N.weight_fkp
            data.nz = N.nz
            
            indx = where(data.z ge 0.0)
            output = data[indx]
            ra = output.ra
            dec = output.dec
            z = output.z
            w = output.weight_fkp
            nbar = output.nz
            openw, lun, path+'cmass-dr10v3-N-Anderson.ran.dat', /get_lun
                for i=0L, n_elements(ra)-1L do printf, lun, ra[i],dec[i],z[i],w[i],nbar[i],format='(f,f,f,f,f)'
            free_lun, lun
        endif
        if keyword_set(South) then begin
            data = replicate(datum,scount)
            data.ra = S.ra
            data.dec = S.dec
            data.z = S.z
            data.weight_fkp = S.weight_fkp
            data.nz = S.nz
                                                                              
            indx = where(data.z ge 0.0)
            output = data[indx]
            ra = output.ra
            dec = output.dec
            z = output.z
            w = output.weight_fkp
            nbar = output.nz
            openw, lun, path+'cmass-dr10v3-S-Anderson.ran.dat', /get_lun
                for i=0L, n_elements(ra)-1L do printf, lun, ra[i],dec[i],z[i],w[i],nbar[i],format='(f,f,f,f,f)'
            free_lun, lun
        endif
        if keyword_set(NS) then begin
            data = replicate(datum,ncount+scount)
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
    endif
end

