pro plot_k_power, fname
    path = '/global/data/scr/chh327/powercode/power/'

	readcol,'gCMASS_all.lpow', n, k_p, Pk_p, arb
    readcol, path+fname+'.dat', k, Pk

;    psopen, 'plot_'+fname+'.eps', /color, xs=9, ys=10
    !p.font=0
    !p.thick=2
    !x.margin=[10,3]
    !y.margin=[4,2]
    plot, k, Pk, psym=-7, LINESTYLE=0, /XLOG, /YLOG, XTITLE='k', YTITLE='P(k)'
    oplot, k_p, Pk_p, psym=-4,LINESTYLE=2
    legend, ['Pg', 'Pr'], linestyle=[0,2], /right_legend
;	write_png, 'plot_'+fname+'.png', tvrd()
;    psclose

	return
end
