pro fibcoll_rand_nbar_scale
    datadir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    
    om0=0.27 
    ol0=0.73 

    z_low=0.000 
    z_high=1.005
    zlim_nbar   =dblarr(201)
    z_mid_bound =dblarr(201)
    z_low_bound =dblarr(201) 
    z_high_bound=dblarr(201)
    zlim_comvol =dblarr(201)
    comdis_low  =dblarr(201)
    comdis_high =dblarr(201)
    for i=0L,200L do begin 
        z_low_bound[i]  = z_low+0.005*float(i)
        z_high_bound[i] = z_low+0.005*float(i+1)
        z_mid_bound[i]  = (z_low_bound[i]+z_high_bound[i])/2.0
        zlim_comvol[i]  = 4.0*!PI/3.0*(lf_comvol(z_high_bound[i])-lf_comvol(z_low_bound[i]))
        comdis_low[i]   = 3000.0*comdis(z_low_bound[i],om0,ol0) 
        comdis_high[i]  = 3000.0*comdis(z_high_bound[i],om0,ol0) 
    endfor 
    
    for n=1L,25L do begin 
        rand_fname='cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print,datadir+rand_fname
        readcol,datadir+rand_fname,rand_ra,rand_dec,rand_red, rand_ipoly, rand_w_boss, rand_w_cp,$
            rand_w_red,rand_veto 
        rand_tot_weights = total(rand_w_boss)

        data_fname = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
        print,datadir+data_fname
        readcol, datadir+data_fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1,$
            m2, veto
        tot_weights = total(w_boss)

        alpha       = tot_weights/rand_tot_weights

        for i=0L,200L do begin 
            zlim = rand_red ge z_low_bound[i] and rand_red lt z_high_bound[i]
            zlim_count      = total(rand_w_boss[where(zlim)]) 
            zlim_nbar[i]    = alpha*(zlim_count/zlim_comvol[i])
        endfor

        out_fname = 'nbar_cmass_dr11_north_randoms_'+strmid(strtrim(string(n+1000),1),1)+'scaled.v7.0.wghtv.txt'
        openw, lun, datadir+out_fname,/get_lun 
        for i=0L,200L do printf,lun,z_mid_bound[i],z_low_bound[i],z_high_bound[i],zlim_nbar[i],$
           format='(4F)'
        free_lun, lun
    endfor 
end 
