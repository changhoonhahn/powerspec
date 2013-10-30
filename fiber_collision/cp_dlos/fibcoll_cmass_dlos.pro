pro fibcoll_cmass_dlos, north=north, south=south
    riadir  = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    if keyword_set(north) then NS='N'
    if keyword_set(south) then NS='S'
    data = mrdfits(riadir+'cmass-dr11v2-'+NS+'-Anderson.dat.fits',1)
    cmass_data = data[where(data.z gt 0.43 and data.z lt 0.7)] 

    ;Currently running it for the CMASS data, which only include galaxies with imatch=1,2
    ;In other words, only galaxies with spectroscopic redshift. 
    ;Our sample as it stands now only contains D1 and D2'.

    ra  = cmass_data.ra
    dec = cmass_data.dec
    red = cmass_data.z
    dm  = 3000.0*comdis(red,0.27,0.73)
    w_cp = cmass_data.weight_cp
    w_noz = cmass_data.weight_noz

    upcp_indx = where(w_cp gt 1) 
    ra_upcp     = ra[upcp_indx]
    dec_upcp    = dec[upcp_indx] 
    red_upcp    = red[upcp_indx] 
    dm_upcp     = dm[upcp_indx]

    ra_nocp     = ra
    dec_nocp    = dec
    red_nocp    = red
    dm_nocp     = dm

    print,'Number of galaxies with w_cp > 1=',n_elements(upcp_indx) 
    print,'Number of galaxies with w_cp = 0=',n_elements(nocp_indx) 

    fib_angscale = 62.0/3600.0  ;Angular fiber collision scale
    if (n_elements(upcp_indx) GT n_elements(nocp_indx)) then begin 
        spherematch, ra_upcp, dec_upcp, ra_nocp, dec_nocp, fib_angscale, m_upcp, m_nocp, d12, maxmatch=0
    endif else begin 
        spherematch, ra_nocp, dec_nocp, ra_upcp, dec_upcp, fib_angscale, m_nocp, m_upcp, d12, maxmatch=0
    endelse 

    gal_upcp = m_upcp[uniq(m_upcp,sort(m_upcp))]

    disp_los = [] 
    disp_perp = [] 
    for i=0L,n_elements(gal_upcp)-1L do begin
        ngal = gal_upcp[i]
        collision_indx = where( m_upcp eq ngal )
        
        target_phi  = ra_upcp[ngal]
        target_theta= 90.0-dec_upcp[ngal]
        target_r    = dm_upcp[ngal]

        neigh_phi   = ra[m_nocp[collision_indx]]
        neigh_theta = 90.0-dec[m_nocp[collision_indx]]
        neigh_r     = dm[m_nocp[collision_indx]]

        ;Converting spherical to cartesian: 
        angles_to_xyz, target_r, target_phi, target_theta, target_x, target_y, target_z
        angles_to_xyz, neigh_r, neigh_phi, neigh_theta, neigh_x, neigh_y, neigh_z

        target_mag          = target_x^2+target_y^2+target_z^2
        target_dot_neigh    = target_x*neigh_x+target_y*neigh_y+target_z*neigh_z
        proj                = target_dot_neigh/target_mag

        LOS_x = proj*target_x
        LOS_y = proj*target_y
        LOS_z = proj*target_z
        LOS_mag = LOS_x^2+LOS_y^2+LOS_z^2 

        d_los = dblarr(n_elements(LOS_mag))
        for j=0L,n_elements(LOS_mag)-1L do begin 
            if LOS_mag[j] ge target_mag then begin
                d_los[j] = sqrt((LOS_x[j]-target_x)^2+(LOS_y[j]-target_y)^2+(LOS_z[j]-target_z)^2)
            endif else begin
                d_los[j] = -sqrt((LOS_x[j]-target_x)^2+(LOS_y[j]-target_y)^2+(LOS_z[j]-target_z)^2)
            endelse
        endfor 
        disp_los    = [disp_los, d_los]        
        disp_perp   = [disp_perp, sqrt((neigh_x-LOS_x)^2+(neigh_y-LOS_y)^2+(neigh_z-LOS_z)^2)] 
    endfor
    disp_los = disp_los[where(disp_los GT 0.0)]
; d_LOS: 
    openw, lun, riadir+'cmass-dr11v2-'+NS+'-Anderson_dlos.dat', /get_lun 
        for i=0L, n_elements(disp_los)-1L do printf, lun, disp_los[i], format='(f)'
    free_lun, lun
; d_perp
    openw, lun, riadir+'cmass-dr11v2-'+NS+'-Anderson-dperp.dat', /get_lun 
        for i=0L, n_elements(disp_perp)-1L do printf, lun, disp_perp[i], format='(f)'
    free_lun, lun
end 
