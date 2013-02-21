pro get_cmass_numden, file=file, fname=fname
	nsel = 40
	data = mrdfits(file, 1)
	zmin = min(data.z)
	if zmin lt 0.0 then begin
		zmin = 0.0
	endif
	zmax = max(data.z)
	
	z = dblarr(nsel)
	numden = dblarr(nsel)

	openw, 1, fname
	for i = 0L, nsel-2L do begin  
		z[i] = zmin + (zmax-zmin)*float(i)/float(nsel-1)
		zplus = z[i] + ((zmax-zmin)/float(nsel-1))*0.5

		indx = where(data.z ge z[i] AND data.z lt zplus)
		bin = data[indx]
		num = n_elements(bin)
		print, num 
		binz = bin.z
		for l = 0L, num-1L do begin 
			if binz[l] lt z[i] then begin
				print, 'lies'
				num = 0
			endif
		endfor 
		vol = (4.0*!PI/3.0)*(lf_comvol(zplus)-lf_comvol(z[i]))*(3429.2737/(129600.0/!PI))
		numden[i] = float(num)/vol
		zmid = 0.5*(z[i]+zplus)
		print, z[i], zmid, zplus, numden[i] 	
		printf, 1, zmid, numden[i], format='(f,f)'
		
	endfor
	close, 1
	return
end
