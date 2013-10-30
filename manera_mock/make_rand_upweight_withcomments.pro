pro make_rand_upweight,n,zseed

      ### -- Marc 1 
      ### -- I assume this would be changed to v11.0 (data) v11.1 (randoms)

    datadir     = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    data_file   = 'cmass_dr11_north_ir4'+strmid(strtrim(string(n+1000),1),1)+$
        '.v7.0.wghtv.txt'
    rand_file   = 'cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
        '.v7.0.wghtv.txt'
  
      ### -- Marc 2
      ### -- You seem to be missing here ipoly column, please chec, 

    readcol, datadir+data_file, ra, dec, az, w_boss, w_red, w_cp, veto

      ### -- Marc 3
      ### -- Selection should be more constrained  -> veto EQ 1 AND w_boss GT 0 AND w_red GT 0 AND w_cp GT 0 

    vetomask = where(veto EQ 1) 
    ra      = ra[vetomask]
    dec     = dec[vetomask]
    az      = az[vetomask] 
    w_boss  = w_boss[vetomask] 
    w_red   = w_red[vetomask] 
    w_cp    = w_cp[vetomask] 

    readcol, datadir+rand_file, rand_ra, rand_dec, rand_red, rand_ipoly, rand_w_boss, rand_w_cp,$
        rand_w_red, rand_veto

      ### -- Marc 4
      ### -- Selection should be more constrained  
      ### -- -> rand_veto EQ 1 AND rand_w_boss GT 0 AND rand_w_red GT 0 AND rand_w_cp GT 0 

    vetomask_rand = where(rand_veto EQ 1 AND rand_w_boss GT 0)
    rand_ra     = rand_ra[vetomask_rand]
    rand_dec    = rand_dec[vetomask_rand]
    rand_ipoly  = rand_ipoly[vetomask_rand] 
    rand_w_boss = rand_w_boss[vetomask_rand]
    rand_w_cp   = rand_w_cp[vetomask_rand]
    rand_w_red  = rand_w_red[vetomask_rand]

    Ndata   = n_elements(ra)
    Nran    = n_elements(rand_ra)
    rand_az = fltarr(Nran)

    print,' data galaxies   =',Ndata
    print,' rand galaxies   =',Nran
    weights = fltarr(n_elements(w_boss))

      ### -- Marc 5
      ### -- Selection should be more constrained  
      ### -- -> veto EQ 1 AND w_boss GT 0 AND w_red GT 0 AND w_cp GT 0 
 
      ### -- Marc 6
      ### -- The problem with the below is allowing weights = 0
      ### -- I think that then the inverse mapping allow for redshifts that are exlcuded
      ### -- and these can be a soure of extra clustering  

    for i=0L,n_elements(w_boss)-1L do begin 
        if w_boss[i] GT 0 AND w_red[i] GT 0 AND w_cp[i] GT 0 then begin 
            weights[i] = double(w_cp[i]+w_red[i]-1.0)
        endif else begin 

           ### -- Marc 7 again you want to check no case comes here
            weights[i] = 0.0
        endelse 
    endfor 
    data_weight_cum = total(weights,/cumulative)
    data_weight_max = max(data_weight_cum) 

    ranz = randomu(long(zseed),Nran)*data_weight_max  
    for iii=0L,Nran-1L do begin 
        xx = where(data_weight_cum GE ranz[iii],countxx) 
        if(countxx EQ 0) then begin
            print,'redshift assigning random problem'
            stop 
        endif
        zindx = min(xx)
        rand_az[iii] = az[zindx]
    endfor
    
    output_file = 'cmass_dr11_north_randoms_ir4'+strmid(strtrim(string(n+1000),1),1)+$
        '.v7.0.upweight.makerandom.txt'
    openw,lun,datadir+output_file,/get_lun
    for i=0L,Nran-1L do printf,lun,rand_ra[i],rand_dec[i],rand_az[i],rand_ipoly[i],rand_w_boss[i],rand_w_cp[i],$
        rand_w_red[i],rand_veto[i],format='(8F)'
    free_lun,lun 
end
