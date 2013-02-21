PRO cmass_xyz
    path='/global/data/scr/chh327/powercode/data/'
    gal=mrdfits(path+'cmass-dr10v5-N-Anderson.dat.fits',1)
    rand=mrdfits(path+'cmass-dr10v5-N-Anderson.ran.fits',1)

    print, max(gal.z), max(rand.z)
    galmaxz=max(gal.z)   
    rrad=3000.0*comdis(rand.z,0.27,0.73)

    zindx = rand.z gt galmaxz

    randxyz=replicate({x:0.,y:0.,z:0.},n_elements(rand))
    xindx = randxyz.x gt 0.0 or randxyz.z lt -2345.244
    yindx = randxyz.y gt 1872.209 or randxyz.y lt -2072.302
    zindx = randxyz.z gt 1968.855 or randxyz.z lt -119.64
    randxyz.x=rrad*cos(rand.dec)*cos(rand.ra)
    randxyz.y=rrad*cos(rand.dec)*sin(rand.ra)
    randxyz.z=rrad*sin(rand.dec)

    outsidebox = randxyz[where(xindx or yindx or zindx)]
    
    print, n_elements(outsidebox), n_elements(outsidebox)/n_elements(rand)
END
