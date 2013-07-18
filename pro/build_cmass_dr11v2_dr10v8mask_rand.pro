pro build_cmass_dr11v2_dr10v8mask_rand
    dr11v2_data = mrdfits('/global/data/scr/chh327/powercode/data/cmass-dr11v2-S-Anderson.ran.fits',1)

    read_mangle_polygons, '/global/data/scr/chh327/powercode/data/mask-cmass-dr10v8-S-Anderson.ply', dr10v8_S
    
    dr11v2_data_wind = is_in_window(ra=dr11v2_data.ra,dec=dr11v2_data.dec, dr10v8_S)

    wind_indx = dr11v2_data_wind eq 1
    
    data_mask = dr11v2_data[where(wind_indx)]

    ra = data_mask.ra
    dec = data_mask.dec
    z = data_mask.z
    weight = data_mask.weight_fkp
    nbar = data_mask.nz

    openw, lun, '/global/data/scr/chh327/powercode/data/cmass-dr11v2-S-Anderson-nzw-zlim-dr10v8mask.ran.dat', /get_lun
        for i=0L,n_elements(data_mask)-1L do printf, lun, ra[i], dec[i], z[i], weight[i], nbar[i], format='(f,f,f,f,f)'
    free_lun, lun
end
