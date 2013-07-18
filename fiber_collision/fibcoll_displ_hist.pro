pro fibcoll_displ_hist, n, north=north, south=south, rand=rand
    datadir='/global/data/scr/chh327/powercode/data/'
    if keyword_set(north) then NS='north'
    if keyword_set(south) then NS='south'

    if keyword_set(rand) then begin
        fname='cmass_dr11_'+NS+'_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print, datadir+fname
        readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, veto
    endif else begin 
        fname='cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print, datadir+fname
        readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto
    endelse 

    print, n_elements(ra)
    print, total(w_boss), total(w_cp), total(w_red)
    wboss = w_boss gt 0
    upcp = w_cp gt 1
    nocp = w_cp eq 0 
    norf = w_red gt 0 

;Galaxies with up-weighted w_cp
    ra_upcp = ra[where(wboss and upcp and norf)]
    dec_upcp = dec[where(wboss and upcp and norf)]
    red_upcp = red[where(wboss and upcp and norf)]
    
    ra_nocp = ra[where(wboss and nocp and norf)]
    dec_nocp = dec[where(wboss and nocp and norf)]
    red_nocp = red[where(wboss and nocp and norf)]

    ra_npwcp = ra[where(nocp)]

    print, n_elements(ra[where(wboss)]), n_elements(ra_upcp), n_elements(ra_nocp)
    print, n_elements(ra_npwcp)

;Angular Fiber Collision Scale: 
    fib_angscale = 0.01722
    spherematch, ra_upcp, dec_upcp, ra_nocp, dec_nocp, fib_angscale, m_upcp, m_nocp, d12, maxmatch=0

    ;uniq_upcp = m_upcp[uniq(m_upcp)]
    ;gal_upcp = uniq_upcp[sort(uniq_upcp)]
    gal_upcp = m_upcp[uniq(m_upcp, sort(m_upcp))] 
    
    print, "Number of galaxies with wcp>1 that have match:", n_elements(gal_upcp)

    disp_los = []
    disp_perp = []
    tail_red = [] 
    for i=0L,n_elements(gal_upcp)-1L do begin
        collision_indx = where( m_upcp eq gal_upcp[i] ) 
        target_ra = ra_upcp[gal_upcp[i]]
        target_dec = dec_upcp[gal_upcp[i]]
        target_red = red_upcp[gal_upcp[i]]

        neigh_ra = ra_nocp[m_nocp[collision_indx]]
        neigh_dec = dec_nocp[m_nocp[collision_indx]]
        neigh_red = red_nocp[m_nocp[collision_indx]]
        
        if n_elements(neigh_ra) eq 0 then print, "No neighbors!"

        targ_r = 3000.0*comdis(target_red,0.3,0.7)
        targ_phi = target_ra
        targ_theta = 90.0-target_dec

        neigh_r = 3000.0*comdis(neigh_red,0.3,0.7)
        neigh_phi = neigh_ra
        neigh_theta = 90.0-neigh_dec

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

        d_perp = sqrt((neigh_x-LOS_x)^2+(neigh_y-LOS_y)^2+(neigh_z-LOS_z)^2)

        for ii=0L,n_elements(d_los)-1L do begin
            if (d_los[ii] gt 10.0) then tail_red = [tail_red, neigh_red[ii]]
        endfor 

        disp_los = [disp_los, d_los] 
        disp_perp = [disp_perp, d_perp]
    endfor 

    if keyword_set(rand) then begin 
        openw, lun, 'cmass_dr11_'+NS+'_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_los.dat', /get_lun
            for i=0L,n_elements(disp_los)-1L do printf, lun, disp_los[i], format='(f)'
        free_lun, lun 
        openw, lun, 'cmass_dr11_'+NS+'_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_perp.dat', /get_lun
            for i=0L,n_elements(disp_los)-1L do printf, lun, disp_perp[i], format='(f)'
        free_lun, lun 
        openw, lun, 'cmass_dr11_'+NS+'_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_los_disttail_redshift.dat', /get_lun
            for i=0L,n_elements(tail_red)-1L do printf, lun, tail_red[i], format='(f)'
        free_lun, lun 
        hist_tail_red = histogram(tail_red, binsize=0.005, min=0.0)
        openw, lun, 'cmass_dr11_'+NS+'_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_los_disttail_redshift_hist.dat', /get_lun
            for i=0L,n_elements(hist_tail_red)-1L do printf, lun, hist_tail_red[i], format='(f)'
        free_lun, lun 
    endif else begin
        openw, lun, datadir+'cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_los.dat', /get_lun
            for i=0L,n_elements(disp_los)-1L do printf, lun, disp_los[i], format='(f)'
        free_lun, lun 
        openw, lun, datadir+'cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_perp.dat', /get_lun
            for i=0L,n_elements(disp_los)-1L do printf, lun, disp_perp[i], format='(f)'
        free_lun, lun 
        openw, lun, datadir+'cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_los_disttail_redshift.dat', /get_lun
            for i=0L,n_elements(tail_red)-1L do printf, lun, tail_red[i], format='(f)'
        free_lun, lun 
        hist_tail_red = histogram(tail_red, binsize=0.005, min=0.0)
        openw, lun, datadir+'cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'v7.0_disp_los_disttail_redshift_hist.dat', /get_lun
            for i=0L,n_elements(hist_tail_red)-1L do printf, lun, hist_tail_red[i], format='(f)'
        free_lun, lun 
    endelse
end
