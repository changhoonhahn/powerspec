pro fibcoll_pthalo_dlos, n 
    datadir = '/mount/chichipio2/hahn/data/manera_mock/v5p2/' 
    fname   = 'cmass_dr10_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v5.2.wghtv.txt'
    print,datadir+fname

    readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto
    dm  = 3000.0*comdis(red,0.27,0.73)

    print,' Total number of PTHalo galaxies=',n_elements(ra)
    print,' total(wboss)=',total(w_boss),'total(wcp)=',total(w_cp),'total(wred)=',total(w_red)
    upcp = w_cp gt 1
    nocp = w_cp eq 0 

;Galaxies with up-weighted w_cp
    upcp_indx   = where(w_cp gt 1)
    ra_upcp     = ra[upcp_indx]
    dec_upcp    = dec[upcp_indx]
    red_upcp    = red[upcp_indx]
    dm_upcp     = dm[upcp_indx]

    
    nocp_indx   = where(w_cp eq 0)
    ra_nocp     = ra[nocp_indx]
    dec_nocp    = dec[nocp_indx]
    red_nocp    = red[nocp_indx]
    dm_nocp     = dm[nocp_indx]

    print,' number of upcp=',n_elements(upcp_indx) 
    print,' number of nocp=',n_elements(nocp_indx)

;Angular Fiber Collision Scale: 
    fib_angscale = 62.0/3600.0 
    if (n_elements(upcp_indx) GT n_elements(nocp_indx)) then begin 
        spherematch, ra_upcp, dec_upcp, ra_nocp, dec_nocp, fib_angscale, m_upcp, m_nocp, d12, maxmatch=0
    endif else begin 
        spherematch, ra_nocp, dec_nocp, ra_upcp, dec_upcp, fib_angscale, m_nocp, m_upcp, d12, maxmatch=0
    endelse 

    gal_upcp = m_upcp[uniq(m_upcp, sort(m_upcp))] 
    print,' gal_upcp=',n_elements(gal_upcp)
    print,' uniq(gal_upcp)=',n_elements(uniq(gal_upcp[sort(gal_upcp)]))
    print,' m_upcp=',n_elements(m_upcp)
    print,' uniq(m_upcp)=',n_elements(uniq(m_upcp[sort(m_upcp)]))
    print,' m_nocp=',n_elements(m_nocp)
    print,' uniq(m_nocp)=',n_elements(uniq(m_nocp[sort(m_nocp)]))
    print,' total(w_cp)=',total(w_cp)
    print,' total(w_upcp)=',total(w_cp[upcp_indx[m_upcp[gal_upcp]]])
    print,' total(w_nocp)=',total(w_cp[nocp_indx[uniq(m_nocp[sort(m_nocp)])]])
    Ncorr=0
    error_count=0
    disp_los = []
    for i=0L,n_elements(gal_upcp)-1L do begin
        ngal=gal_upcp[i]
        collision_indx = where( m_upcp eq ngal ) 
       
        targ_indx   = upcp_indx[ngal] 
        targ_phi    = ra_upcp[ngal]
        targ_theta  = 90.0-dec_upcp[ngal]
        targ_r      = dm_upcp[ngal]
       
        neigh_indx  = nocp_indx[m_nocp[collision_indx]]
        neigh_phi   = ra_nocp[m_nocp[collision_indx]]
        neigh_theta = 90.0-dec_nocp[m_nocp[collision_indx]]
        neigh_r     = dm_nocp[m_nocp[collision_indx]]
        neigh_red   = red_nocp[m_nocp[collision_indx]]
        
        if w_cp[targ_indx] eq n_elements(neigh_indx)+1L then begin 
            angles_to_xyz, targ_r, targ_phi, targ_theta, targ_x, targ_y, targ_z
            angles_to_xyz, neigh_r, neigh_phi, neigh_theta, neigh_x, neigh_y, neigh_z

            targ_mag        = targ_x^2+targ_y^2+targ_z^2
            targ_dot_neigh  = targ_x*neigh_x+targ_y*neigh_y+targ_z*neigh_z
            proj            = targ_dot_neigh/targ_mag

            LOS_x   = proj*targ_x 
            LOS_y   = proj*targ_y
            LOS_z   = proj*targ_z
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
            Ncorr = Ncorr+1L
        endif else begin 
            error_count=error_count+1L 
        endelse 
    endfor 
    print, 'Ncorr=',Ncorr
    print, 'w_cp mismatch=',error_count

    openw,lun,datadir+'cmass_dr10_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'v5.2_dlos.dat',$
       /get_lun
    for i=0L,n_elements(disp_los)-1L do printf,lun,disp_los[i],format='(f)'
    free_lun,lun 
end
