pro sdssmock_cmass_radecmask
	
;	readcol,'sdssmock_gamma_lrgFull_zm_oriana01a_no.real.rdcz.dat', mockra, mockdec, mockcz
	readcol, '/global/data/scr/chh327/powercode/sdssmock_gamma_lrgFull.rand_100x_no.rdcz.dat', mockra, mockdec, mockcz
	moc = {ra:0., dec:0.,z:0.}
	mock = replicate(moc, n_elements(mockra))
	mock.ra = mockra
	mock.dec = mockdec
	mock.z = mockcz
	indx0 = where(mock.dec le 48.0 OR mock.ra le 153.0) 
	mock0 = mock[indx0]
	indx1 = where(mock0.dec le 60.0 OR mock0.ra ge 146.0 ) 
	mock1 = mock0[indx1]
	indx2 = where(mock1.dec le 65.0)
	mock2 = mock1[indx2] 
	indx3 = where(mock2.dec ge 32.0 OR mock2.dec le 24.0 OR mock2.ra le 135.0 OR mock2.ra ge 180.0)
	mock3 = mock2[indx3]
	indx4 = where(mock3.ra le 238.0 OR mock3.dec ge 5.0)
	mock4 = mock3[indx4]
	

	ra = mock4.ra
	dec = mock4.dec
	cz = mock4.z
	print, float(n_elements(mock4))/float(n_elements(mock)	)
	openw, lun, 'sdssmock_cmass_radecmask.ran.dat', /get_lun
	for i = 0L, n_elements(mock4)-1L do printf, lun, ra[i], dec[i], cz[i], format='(f,f,f)'
	free_lun, lun

end 
