pro fibcoll_displ_shuffle, n, north=north, south=south
    datadir='/global/data/scr/chh327/powercode/data/'
    if keyword_set(north) then NS='north'
    if keyword_set(south) then NS='south'

    fname='cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
    print, datadir+fname
    readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto
    dm = 3000.0*comdis(red,0.27,0.73) 
    comdis_low = 3000.0*comdis(0.43,0.27,0.73)
    comdis_high = 3000.0*comdis(0.70,0.27,0.73)

;    w_cp = w_cp[where(veto eq 1)]  
;    ra = ra[where(veto eq 1)]
;    dec = dec[where(veto eq 1)] 
;    red = red[where(veto eq 1)] 
;    dm = dm[where(veto eq 1)]  

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
    print,'uniq(gal_upcp)=',n_elements(uniq(gal_upcp[sort(gal_upcp)]))
    print,'m_upcp=',n_elements(m_upcp)
    print,'uniq(m_upcp)=',n_elements(uniq(m_upcp[sort(m_upcp)]))
    print,'m_nocp=',n_elements(m_nocp) 
    print,'uniq(m_nocp)=',n_elements(uniq(m_nocp[sort(m_nocp)]))
    print,'total(w_cp)=',total(w_cp)
    print,'total(w_upcp)=',total(w_cp[upcp_indx[m_upcp[gal_upcp]]])
    print,'total(w_nocp)=',total(w_cp[nocp_indx[uniq(m_nocp[sort(m_nocp)])]])

    disp_los = []
    error_count = 0
    for i=0L,n_elements(gal_upcp)-1L do begin
        ngal = gal_upcp[i]
        collision_indx = where( m_upcp eq ngal ) 
        targ_phi = ra_upcp[ngal]
        targ_theta = 90.0-dec_upcp[ngal]
        targ_r = dm_upcp[ngal]

        n_neigh = m_nocp[collision_indx]
        neigh_phi = ra_nocp[n_neigh]
        neigh_theta = 90.0-dec_nocp[n_neigh]
        neigh_r = dm_nocp[n_neigh]

;If w_upcp matches the number of neighbors then calculate d_LOS:
        if w_cp[upcp_indx[ngal]] eq n_elements(n_neigh)+1L then begin
            angles_to_xyz, targ_r, targ_phi, targ_theta, targ_x, targ_y, targ_z
            angles_to_xyz, neigh_r, neigh_phi, neigh_theta, neigh_x, neigh_y, neigh_z

            targ_mag= targ_x^2+targ_y^2+targ_z^2
            targ_dot_neigh= targ_x*neigh_x+targ_y*neigh_y+targ_z*neigh_z
            proj = targ_dot_neigh/targ_mag

            LOS_x = proj*targ_x 
            LOS_y = proj*targ_y
            LOS_z = proj*targ_z
            LOS_mag = LOS_x^2+LOS_y^2+LOS_z^2

            d_los = dblarr(n_elements(LOS_mag))
            for j=0L,n_elements(LOS_mag)-1L do begin 
                if LOS_mag[j] ge targ_mag then begin                 
                    d_los[j] = sqrt((LOS_x[j]-targ_x)^2+(LOS_y[j]-targ_y)^2+(LOS_z[j]-targ_z)^2)
                endif else begin 
                    d_los[j] = -sqrt((LOS_x[j]-targ_x)^2+(LOS_y[j]-targ_y)^2+(LOS_z[j]-targ_z)^2)
                endelse 
            endfor
            disp_los = [disp_los, d_los] 
        endif else begin
            error_count = error_count + 1L 
        endelse  
    endfor
    disp_los_hist = histogram(disp_los,binsize=1.0)
    plot,disp_los_hist
    disp_los = shuffle(disp_los) 

    print,'Number of galaxies within redshift limits=',n_elements(dm[where(dm le comdis_high and dm ge comdis_low)])
    
    shuffle_count = 0 
    error_count = 0  
    dloscount=0
    out_zlim_count = 0
    for ii=0L,n_elements(gal_upcp)-1L do begin 
        ngal = gal_upcp[ii]
        collision_indx = where( m_upcp eq ngal ) 
        
        targ_indx=upcp_indx[ngal]
        targ_r = dm_upcp[ngal] 
    
        neigh_indx=nocp_indx[m_nocp[collision_indx]]

        if w_cp[targ_indx] ne n_elements(collision_indx)+1L then begin
            error_count = error_count+1L 
        endif else begin 
;            w_cp[neigh_indx]=w_cp[neigh_indx]+1L
            w_cp[neigh_indx] = 1L 
            w_cp[targ_indx] = w_cp[targ_indx]-total(w_cp[neigh_indx]) 
            if min(w_boss[neigh_indx]) eq 0.0 then print,'w_boss=0',w_boss[neigh_indx]
            if min(w_red[neigh_indx]) eq 0.0 then print,'w_red=0',w_red[neigh_indx]

            neigh_r = dblarr(n_elements(neigh_indx))
            for k=0L,n_elements(neigh_indx)-1L do begin
                neigh_r[k] = targ_r + disp_los[dloscount]
;                if neigh_r[k] gt comdis_high or neigh_r[k] lt comdis_low then begin 
;                    out_zlim_count = out_zlim_count + 1L 
;                    neigh_r[k] = targ_r - disp_los[dloscount]
;                endif 
                dloscount = dloscount+1L
            endfor
            dm[neigh_indx] = neigh_r
        
            if w_cp[targ_indx] ne 1 then begin 
                print,'w_upcp=',w_cp[targ_indx]
                print,'number of neighbors=',n_elements(neigh_indx)
                print,'total w_cp of neighbor=',total(w_cp[neigh_indx])
            endif 
            shuffle_count = shuffle_count + 1L 
        endelse 
    endfor
    print,'error count=',error_count    
    print,'shuffle count=',shuffle_count
    print,'Number of galaxies within redshift limits=',n_elements(dm[where(dm le comdis_high and dm ge comdis_low)])
    print,'total(w_cp)=',total(w_cp)
;    print, out_zlim_count

    outfname='shuffle_cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt_testing'
    openw,lun,datadir+outfname,/get_lun 
    for i=0L,n_elements(ra)-1L do printf,lun,ra[i],dec[i],dm[i],long(ipoly[i]),long(w_boss[i]),long(w_cp[i]),long(w_red[i])$
        ,redtrue[i],long(flag[i]),m1[i],m2[i],float(veto[i]),format='(3F,4I,F,I,2F,I)'
    free_lun, lun 
end
