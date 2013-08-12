pro fibcoll_pthalo_dlos_upweighted, n, north=north, south=south
    datadir='/mount/riachuelo1/hahn/data/manera_mock/dr11/'

    if keyword_set(north) then NS='north'
    if keyword_set(south) then NS='south'

    fname='cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
    print, datadir+fname
    readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto
    dm = 3000.0*comdis(red,0.27,0.73) 
    comdis_low = 3000.0*comdis(0.43,0.27,0.73)
    comdis_high = 3000.0*comdis(0.70,0.27,0.73)

;Galaxies with up-weighted w_cp
    upcp_indx = where(w_cp gt 1) 
    ra_upcp = ra[upcp_indx]
    dec_upcp = dec[upcp_indx] 
    red_upcp = red[upcp_indx] 
    dm_upcp = dm[upcp_indx] 

    nocp_indx = where(w_cp eq 0)
    ra_nocp = ra[nocp_indx] 
    dec_nocp = dec[nocp_indx] 
    red_nocp = red[nocp_indx] 
    dm_nocp = dm[nocp_indx] 

    print,'Galaxies with wcp>=1 =', n_elements(upcp_indx)
    print,'Galaxies with wcp>=0 =', n_elements(nocp_indx)

;Angular Fiber Collision Scale: 
    fib_angscale=62.0/3600.0 
    print, fib_angscale
;    spherematch, ra_upcp, dec_upcp, ra_nocp, dec_nocp, fib_angscale, m_upcp, m_nocp, d12, maxmatch=0
    spherematch, ra_nocp, dec_nocp, ra_upcp, dec_upcp, fib_angscale, m_nocp, m_upcp, d21, maxmatch=0
    
    gal_upcp = m_upcp[uniq(m_upcp, sort(m_upcp))]
    print,'gal_upcp=',n_elements(gal_upcp)
    print,n_elements(upcp_indx)-n_elements(gal_upcp),' wcp>1 galaxies without match'
    print,'m_upcp=',n_elements(m_upcp)
    print,'uniq(m_upcp)=',n_elements(uniq(m_upcp[sort(m_upcp)]))
    print,'m_nocp=',n_elements(m_nocp) 
    print,'uniq(m_nocp)=',n_elements(uniq(m_nocp[sort(m_nocp)]))
    print,'total(w_cp)=',total(w_cp)
    print,'total(w_upcp)=',total(w_cp[upcp_indx[m_upcp[gal_upcp]]])
    print,'total(w_nocp)=',total(w_cp[nocp_indx[uniq(m_nocp[sort(m_nocp)])]])

    print,'Number of galaxies within redshift limits=',n_elements(dm[where(dm le comdis_high and dm ge comdis_low)])
    
    shuffle_count = 0 
    error_count = 0  
    for ii=0L,n_elements(gal_upcp)-1L do begin 
        ngal = gal_upcp[ii]
        collision_indx = where( m_upcp eq ngal ) 
        
        targ_indx=upcp_indx[ngal]
        targ_r = dm_upcp[ngal] 
    
        neigh_indx=nocp_indx[m_nocp[collision_indx]]

        if w_cp[targ_indx] eq n_elements(neigh_indx)+1L then begin
            if total(w_cp[neigh_indx]) gt 0 then print,total(w_cp[neigh_indx]),'neighbors repeated'
            w_cp[neigh_indx] = 1L 
            w_cp[targ_indx] = w_cp[targ_indx]-total(w_cp[neigh_indx]) 
            if min(w_boss[neigh_indx]) eq 0 then print,'w_boss=0',w_boss[neigh_indx]
            if min(w_red[neigh_indx]) eq 0 then print,'w_red=0',w_red[neigh_indx]
            w_boss[neigh_indx] = w_boss[targ_indx]
            w_red[neigh_indx] = 1L
            ra[neigh_indx] = ra[targ_indx]
            dec[neigh_indx] = dec[targ_indx]

            dm[neigh_indx] = targ_r
        
            if w_cp[targ_indx] ne 1 then begin 
                print,'w_upcp=',w_cp[targ_indx]
                print,'number of neighbors=',n_elements(neigh_indx)
                print,'total w_cp of neighbor=',total(w_cp[neigh_indx])
            endif 
            shuffle_count = shuffle_count+1L 
        endif else begin
            error_count = error_count+1L
        endelse 
    endfor
    print,'error count=',error_count    
    print,'shuffle count=',shuffle_count
    print,'Number of galaxies within redshift limits=',n_elements(dm[where(dm le comdis_high and dm ge comdis_low)])
    print,'total(w_cp)=',total(w_cp)

    outfname='upweighted_cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
    openw,lun,datadir+outfname,/get_lun 
    for i=0L,n_elements(ra)-1L do printf,lun,ra[i],dec[i],dm[i],long(ipoly[i]),long(w_boss[i]),long(w_cp[i]),long(w_red[i])$
        ,redtrue[i],long(flag[i]),m1[i],m2[i],float(veto[i]),format='(3F,4I,F,I,2F,I)'
    free_lun, lun 
end
