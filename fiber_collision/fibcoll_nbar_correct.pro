pro fibcoll_nbar_correct
    dir = '/mount/riachuelo1/hahn/data/manera_mock/dr11/'
    
    name0   = 'cmass_dr11_north_ir4'
    nameend = '.v7.0.wghtv.txt'

    for i=1L,25L do begin 
        file_wboss  = 'nbar_wboss_'+name0+strmid(strtrim(string(i+1000),1),1)+nameend
        file_upw    = 'nbar_upweighted_'+name0+strmid(strtrim(string(i+1000),1),1)+nameend
        file_shfl   = 'nbar_shuffle_zlim_'+name0+strmid(strtrim(string(i+1000),1),1)+nameend

        readcol,dir+file_wboss,wboss_zmid,wboss_zlow,wboss_zhigh,wboss_nbar,f='D,D,D,D'
        readcol,dir+file_upw,upw_zmid,upw_zlow,upw_zhigh,upw_nbar,f='D,D,D,D'
        readcol,dir+file_shfl,shfl_zmid,shfl_zlow,shfl_zhigh,shfl_nbar,f='D,D,D,D'

        if (i EQ 1) then begin 
            z_values    = wboss_zmid 
            sum_wboss   = wboss_nbar
            sum_upw     = upw_nbar
            sum_shfl    = shfl_nbar
        endif else begin 
            sum_wboss   = sum_wboss+wboss_nbar
            sum_upw     = sum_upw+upw_nbar
            sum_shfl    = sum_shfl+shfl_nbar
        endelse
    endfor 
    ratio_shfl_wboss    = sum_shfl/sum_wboss    ; Still uncertain which ratio to use to correct dLOS shuffle n(z)
    ratio_shfl_upw      = sum_shfl/sum_upw 

    for i=0L,n_elements(ratio_shfl_wboss)-1L do begin
        if z_values[i] LT 0.43 or z_values[i] GT 0.7 then ratio_shfl_wboss[i] = 1.0
    endfor 

    pthalo_file = 'nbar-cmass-dr11may22-N-Anderson'
    readcol,dir+pthalo_file+'.dat',pth_zmid,pth_zlow,pth_zhigh,pth_nbar,pth_wfkp,pth_shell_vol,pth_tot_w_gals,$
        f='D,D,D,D,D,D,D'

    pth_nbar= pth_nbar*ratio_shfl_wboss
    pth_dc  = 3000.0*comdis(pth_zmid,0.27,0.73)

    corrected_pth_file  = pthalo_file+'-dlosshuffle-corrected.dat'
    openw,lun,dir+corrected_pth_file,/get_lun
    for i=0L,n_elements(pth_zmid)-1L do printf,lun,pth_zmid[i],pth_zlow[i],pth_zhigh[i],pth_dc[i],pth_nbar[i],$
        format='(5F)'
    free_lun, lun 
end 
