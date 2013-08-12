pro fibcoll_displ_testing, n, north=north, south=south, rand=rand
    datadir='/global/data/scr/chh327/powercode/data/'
    if keyword_set(north) then NS='north'
    if keyword_set(south) then NS='south'

    fname='cmass_dr11_'+NS+'_ir4'+strmid(strtrim(string(n+1000),1),1)+'.v7.0.wghtv.txt'
    print, datadir+fname
    readcol, datadir+fname, ra, dec, red, ipoly, w_boss, w_cp, w_red, redtrue, flag, m1, m2, veto
    dm = 3000.0*comdis(red,0.27,0.73) 

;Galaxies with up-weighted w_cp
    upcp_indx = where(w_cp gt 0) 
    ra_upcp = ra[upcp_indx]
    dec_upcp = dec[upcp_indx] 
    red_upcp = red[upcp_indx] 
    dm_upcp = dm[upcp_indx] 

    nocp_indx = where(w_cp eq 0)
    ra_nocp = ra[nocp_indx] 
    dec_nocp = dec[nocp_indx] 
    red_nocp = red[nocp_indx] 
    dm_nocp = dm[nocp_indx] 

    print,'Galaxies with wcp>0 =', n_elements(upcp_indx)
    print,'Galaxies with wcp=0 =', n_elements(nocp_indx)

;Angular Fiber Collision Scale: 
    fib_angscale=62.0/3600.0 
    spherematch, ra_upcp, dec_upcp, ra_nocp, dec_nocp, fib_angscale, m_upcp, m_nocp, d12, maxmatch=0
    ;spherematch, ra_nocp, dec_nocp, ra_upcp, dec_upcp, fib_angscale, m_nocp, m_upcp, d21, maxmatch=0
   
    print,'uniq(m_nocp)=',n_elements(uniq(m_nocp(sort(m_nocp))))
    print, 'm_nocp=',n_elements(m_nocp)

    match_fname='spherematch_'+fname 
    openw,lun,datadir+match_fname,/get_lun
    for i=0L,n_elements(m_upcp)-1L do printf,lun,m_upcp[i],m_nocp[i],format='(2I)'
    free_lun, lun
    
    gal_upcp = m_upcp[uniq(m_upcp, sort(m_upcp))]
    print,'Gal_UPCP=',n_elements(uniq(gal_upcp[sort(gal_upcp)])),n_elements(gal_upcp)
    indx_list=[]
    for k=0L,n_elements(gal_upcp)-1L do begin
        indx=where(m_upcp eq gal_upcp[k])
        indx_list=[indx_list,indx]
    endfor 
    print, n_elements(m_nocp),n_elements(indx_list)
    print, n_elements(uniq(indx_list[sort(indx_list)])),n_elements(indx_list)
    m_nocp_list=m_nocp[indx_list]
    print, n_elements(uniq(m_nocp_list[sort(m_nocp_list)])),n_elements(m_nocp_list)
    
end
