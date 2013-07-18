pro cmass_ntile_assign, north=north, south=south
    prismdir = '/global/data/scr/chh327/powercode/data/'
    if keyword_set(north) then NS = 'N'
    if keyword_set(south) then NS = 'S' 
    cmass_fulldata = mrdfits(prismdir+'cmass-dr11v2-'+NS+'-Anderson-full.dat.fits',1)
    cmass_maskdata = mrdfits(prismdir+'mask-cmass-dr11v2-'+NS+'-Anderson.fits',1)

; Organizes the unique sectors with the corresponding ntiles:
    sector = cmass_maskdata.sector
    ntiles = cmass_maskdata.ntiles
    
    list_sector = sector[uniq(sector, sort(sector))] 
    
    list_sector_ntiles = ntiles[uniq(sector, sort(sector))]

    for i=0L,n_elements(cmass_fulldata)-1L do begin 
        print, i
        sector_index = list_sector eq cmass_fulldata[i].isect 
        cmass_fulldata[i].ntiles = uint(list_sector_ntiles[where(sector_index)])
    endfor 

    mwrfits, cmass_fulldata, prismdir+'cmass-dr11v2-'+NS+'-Anderson-full-ntiles.dat.fits', /create
end
