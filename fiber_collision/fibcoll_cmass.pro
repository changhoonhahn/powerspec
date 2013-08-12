pro fibcoll_cmass, north=north, south=south
    prismdir = '/global/data/scr/chh327/powercode/data/'
    if keyword_set(north) then NS='N'
    if keyword_set(south) then NS='S'
    data = mrdfits(prismdir+'cmass-dr11v2-'+NS+'-Anderson.dat.fits',1)
    ; Imposing redshift limits: 
    cmass_data = data[where(data.z gt 0.43 and data.z lt 0.7)] 

    ;Currently running it for the CMASS data, which only include galaxies with imatch=1,2
    ;In other words, only galaxies with spectroscopic redshift. 
    ;Our sample as it stands now only contains D1 and D2'.

    ra = cmass_data.ra
    dec = cmass_data.dec
    red = cmass_data.z
    w_cp = cmass_data.weight_cp
    w_noz = cmass_data.weight_noz

    upcp_indx = where(w_cp gt 1) 
    ra_upcp = ra[upcp_indx]
    dec_upcp = dec[upcp_indx] 
    red_upcp = red[upcp_indx] 

    nocp_indx = where(w_cp eq 0) 
    ra_nocp = ra[nocp_indx] 
    dec_nocp = dec[nocp_indx] 
    red_nocp = red[nocp_indx] 

    print,'Number of galaxies with w_cp > 1=',n_elements(upcp_indx) 
    print,'Number of galaxies with w_cp = 0=',n_elements(nocp_indx) 

    fib_angscale = 0.01722  ;Angular fiber collision scale
    spherematch, ra_nocp, dec_nocp, ra_upcp, de_upcp, fib_angscale, m_nocp, m_upcp, d12, maxmatch=0

    gal_upcp = m_upcp[uniq(m_upcp,sort(m_upcp))]

    disp_los = [] 
    disp_perp = [] 
    tail_red = []
    for i=0L,n_elements(gal_m1)-1L do begin
        collision_indx = where( m1 eq gal_m1[i] )
        target_ra = ra[gal_m1[i]]
        target_dec = dec[gal_m1[i]]
        target_red = red[gal_m1[i]]

        neigh_ra = ra[m2[collision_indx]]
        neigh_dec = dec[m2[collision_indx]]
        neigh_red = red[m2[collision_indx]]
        
        if n_elements(neigh_ra) eq 0 then print, "No neighbors!"

        targ_r = 3000.0*comdis(target_red,0.3,0.7)
        targ_phi = target_ra
        targ_theta = 90.0-target_dec 

        neigh_r = 3000.0*comdis(neigh_red,0.3,0.7)
        neigh_phi = neigh_ra
        neigh_theta = 90.0-neigh_dec

        ;Converting spherical to cartesian: 
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
        ;d_los = sqrt((LOS_x-targ_x)^2+(LOS_y-targ_y)^2+(LOS_z-targ_z)^2)
        d_perp = sqrt((neigh_x-LOS_x)^2+(neigh_y-LOS_y)^2+(neigh_z-LOS_z)^2)

        for ii=0L,n_elements(d_los)-1L do begin
            if (d_los[ii] gt 30.0 or d_los[ii] lt -30.0) then tail_red = [tail_red, neigh_red[ii]]
        endfor

        disp_los = [disp_los, d_los]
        disp_perp = [disp_perp, d_perp]
    endfor

    disp_los = disp_los[where(disp_los ne 0.0)] 
    disp_perp = disp_perp[where(disp_perp ne 0.0)] 
     
;Outputting to files: 
;Line-of-Sight Displacemenet: 
;    openw, lun, prismdir+'cmass-dr11v2-'+NS+'-Anderson-disp_los.dat', /get_lun 
    openw, lun, prismdir+'cmass-dr11v2-'+NS+'-Anderson-disp_los_pm.dat', /get_lun 
        for i=0L, n_elements(disp_los)-1L do printf, lun, disp_los[i], format='(f)'
    free_lun, lun
;Perpendicular Displacement:
;    openw, lun, prismdir+'cmass-dr11v2-'+NS+'-Anderson-disp_perp.dat', /get_lun 
;        for i=0L, n_elements(disp_perp)-1L do printf, lun, disp_perp[i], format='(f)'
;    free_lun, lun
;Redshift of Tail of LOS Displacement: 
;    openw, lun, prismdir+'cmass-dr11v2-'+NS+'-Anderson-tail_red.dat', /get_lun 
;        for i=0L, n_elements(tail_red)-1L do printf, lun, tail_red[i], format='(f)'
;    free_lun, lun
end 
