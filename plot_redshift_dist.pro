pro plot_redshift_dist, file= file
	data = mrdfits(file, 1)

 	filename = strtrim(file, 2)
	fname = strjoin(['plot_redshift_dist_',filename,'.ps'])
	set_plot, 'ps'
	device, file= fname
		cgHistoplot, data.z, BINSIZE=0.01, /FILL	

	device, /close
	return
end
