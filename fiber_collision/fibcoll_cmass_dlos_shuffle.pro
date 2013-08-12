pro fibcoll_cmass_dlos_shuffle, north=north, south=south
    prismdir = '/global/data/scr/chh327/powercode/data/'
    if keyword_set(north) then NS='N'
    if keyword_set(south) then NS='S'
    data = mrdfits(prismdir+'cmass-dr11v2-'+NS+'-Anderson.dat.fits',1)
    ; Imposing redshift limits: 
    cmass_data = data[where(data.z gt 0.43 and data.z lt 0.7)] 
    print,'Number of galaxies=',n_elements(cmass_data)
    ;Currently running it for the CMASS data, which only include galaxies with imatch=1,2
    ;In other words, only galaxies with spectroscopic redshift. 
    ;Our sample as it stands now only contains D1 and D2'.

    ra = cmass_data.ra
    dec = cmass_data.dec
    red = cmass_data.z
    dm = 3000.0*comdis(red,0.27,0.73) 
    w_cp = cmass_data.weight_cp
    w_noz = cmass_data.weight_noz

    upcp_indx = where(w_cp gt 1) 
    ra_upcp = ra[upcp_indx]
    dec_upcp = dec[upcp_indx] 
    dm_upcp = dm[upcp_indx] 

    nocp_indx = where(w_cp le 1) 
    ra_nocp = ra[nocp_indx] 
    dec_nocp = dec[nocp_indx] 
    dm_nocp = dm[nocp_indx] 

    print,'Number of galaxies with w_cp > 1=',n_elements(upcp_indx) 
    print,'Number of galaxies with w_cp = 0=',n_elements(nocp_indx) 

    fib_angscale = 0.01722  ;Angular fiber collision scale
    spherematch, ra_nocp, dec_nocp, ra_upcp, dec_upcp, fib_angscale, m_nocp, m_upcp, d12, maxmatch=0
    
    print,'Number of matches=',n_elements(m_nocp)
    print,'Number of repeated multiple collided nocp galaxies=',n_elements(uniq(m_nocp[sort(m_nocp)]))


    gal_upcp = m_upcp[uniq(m_upcp,sort(m_upcp))]
    error_count = 0
    disp_los = [] 
    indx_list = [] 
    for i=0L,n_elements(gal_upcp)-1L do begin
        ngal = gal_upcp[i]
        collision_indx = where( m_upcp eq ngal )
        indx_list = [indx_list, collision_indx]     ;To make sure that all the indexes in m_nocp,m_upcp are covered
        targ_phi = ra_upcp[ngal]
        targ_theta = 90.0-dec_upcp[ngal]
        targ_dm = dm_upcp[ngal]
        
        nneigh = m_nocp[collision_indx] 
        neigh_phi = ra_nocp[nneigh]
        neigh_theta = 90.0-dec_nocp[nneigh]
        neigh_dm = dm_nocp[nneigh]
        
        if n_elements(nneigh) eq 0 then print, "No neighbors!"
        if w_cp[upcp_indx[ngal]] ne n_elements(nneigh)+1L then begin 
            print,ngal,' wcp does not match number of neighbors',w_cp[upcp_indx[ngal]],n_elements(nneigh)
            error_count = error_count + 1L 
        endif 

        ;Converting spherical to cartesian: 
        angles_to_xyz, targ_dm, targ_phi, targ_theta, targ_x, targ_y, targ_z
        angles_to_xyz, neigh_dm, neigh_phi, neigh_theta, neigh_x, neigh_y, neigh_z

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
    endfor
    print,'Number of discrepancies between w_upcp and number of neighbors=',error_count
    print,'Index check=',n_elements(indx_list),n_elements(uniq(indx_list[sort(indx_list)]))
end 
