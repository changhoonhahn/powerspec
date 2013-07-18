pro fibcoll_cmass_imatch, north=north, south=south
    prismdir = '/global/data/scr/chh327/powercode/data/'
    if keyword_set(north) then NS='N'
    if keyword_set(south) then NS='S'
    cmass_data = mrdfits(prismdir+'cmass-dr11v2-'+NS+'-Anderson-full.dat.fits',1)

    ; Full data contains galaxies with imatch = 0-8. 
    ; Of interest are mostly galaxies with imatch = 3 or 6. 

    ra = cmass_data.ra
    dec = cmass_data.dec
    red = cmass_data.z
    imatch = cmass_data.imatch
    w_cp = cmass_data.weight_cp
    w_noz = cmass_data.weight_noz

    fib_angscale = 0.01722  ;Angular fiber collision scale
    spherematch, ra, dec, ra, dec, fib_angscale, m1, m2, d12, maxmatch=0

    uniq_m1 = m1[uniq(m1)]
    gal_m1 = uniq_m1[sort(uniq_m1)]

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

        d_los = sqrt((LOS_x-targ_x)^2+(LOS_y-targ_y)^2+(LOS_z-targ_z)^2)
        d_perp = sqrt((neigh_x-LOS_x)^2+(neigh_y-LOS_y)^2+(neigh_z-LOS_z)^2)

        for ii=0L,n_elements(d_los)-1L do begin
            if (d_los[ii] gt 10.0) then tail_red = [tail_red, neigh_red[ii]]
        endfor

        disp_los = [disp_los, d_los]
        disp_perp = [disp_perp, d_perp]
    endfor 
    save, disp_los, disp_perp, tail_red, filename=prismdir+'fibcoll_cmass_disp.save'
end 
