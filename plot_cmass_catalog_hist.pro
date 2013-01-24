pro plot_cmass_catalog_hist

	readcol, '/global/data/scr/chh327/powercode/cmass-dr10v2-N.dat', ra1, dec1, z1 
	max_z1 = ceil(10.0*max(z1))/10.0
	hist1 = HISTOGRAM(z1, BINSIZE=0.01, min=0, max = 1.01)
	tot1 = TOTAL(hist1)
	frac1 = hist1/tot1
	nbin1 = N_ELEMENTS(hist1)
	xval1 = DBLARR(nbin1)
	for i = 0L, nbin1-1L, 1L do begin
		xval1[i] = 0.01*float(i)
	endfor
	
	readcol, '/global/data/scr/chh327/powercode/cmass-dr10v2-N.ran.dat', ra2, dec2, z2
	max_z2 = CEIL(10.0*MAX(z2))/10.0
	hist2 = HISTOGRAM(z2, BINSIZE=0.01, min=0, max= max_z2)
	tot2 = TOTAL(hist2)
	frac2 = hist2/tot2
	nbin2 = N_ELEMENTS(hist2)
	xval2 = DBLARR(nbin2)
	for i = 0L, nbin2-1L, 1L do begin
		xval2[i] = 0.1*float(i+1)
	endfor

;readcol, '/global/data/scr/chh327/powercode/sdssmock_gamma_lrgFull_zm_oriana01a_no.real.rdcz.dat', mockra, mockdec, mockz
;mockz = mockz/(299800.0)
;print, max(mockz)
;hist_mock = HISTOGRAM(mockz, BINSIZE=0.01, min=0, max=0.44)
;tot_mock  = TOTAL(hist_mock)
;frac_mock = hist_mock/tot_mock
;	nbin_mock = N_ELEMENTS(hist_mock)
;	xval_mock = DBLARR(nbin_mock)
;	for i = 0L, nbin_mock-1L, 1L do begin
;		xval_mock[i] = 0.01*float(i)
;	endfor 

	openw, lun, 'cmass-dr10v2_hist_actual.dat', /get_lun
	for i=0L, n_elements(xval1)-1L do printf, lun, xval1[i], hist1[i],frac1[i], format='(f,f,f)'
	free_lun, lun 

	openw, lun, 'cmass-dr10v2_hist_rand.dat', /get_lun 
	for i=0L, n_elements(xval2)-1L do printf, lun, xval2[i], hist2[i],frac2[i], format='(f,f,f)'
	free_lun, lun 

;	openw, lun, 'cmass_catalog_hist_mock.dat', /get_lun
;	for i=0L, n_elements(xval_mock)-1L do printf, lun, xval_mock[i], hist_mock[i], frac_mock[i], format='(f,f,f)'
;	free_lun, lun

;	set_plot, 'ps'
;	device, file='plot_cmass_dr10_hist.ps'
	plot, xval1, frac1, title= 'Histogram of CMASS catalog', xtitle='Redshift (z)', ytitle='(# of galaxies in redshift bin)/(total # of galaxies)',background=255, color=0
	oplot, xval2, frac2, LINESTYLE=2, color=0
	legend, ['Actual Catalog','Random Catalog'], linestyle=[0,2], /right_legend
	write_png, 'plot_cmass_sdssmock_hist.png', tvrd()
;	device, /close
end
