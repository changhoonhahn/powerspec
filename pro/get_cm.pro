function get_cm, fname
    path=get_path(/powercode)
    data=mrdfits(path+'data/'+fname+'.ran.fits',1)
    
    ra=data.ra
    dec=data.dec
    z=data.z

;    readcol,path+'data/'+fname+'_nzw.ran.dat',ra,dec,z,fkp,nbar

    N = n_elements(ra)
    rad=3000.0*comdis(z,0.27,0.73)
;    rad=1.0    

    r = dblarr(3,N)
    r_cm = dblarr(3)
    sph_cm = dblarr(3)
    rr = dblarr(3)

    r[0,*]=rad*cos(dec)*cos(ra)
    r[1,*]=rad*cos(dec)*sin(ra)
    r[2,*]=rad*sin(dec)
    
    r_cm[0]= total(r[0,*])/N
    r_cm[1]= total(r[1,*])/N
    r_cm[2]= total(r[2,*])/N
    print, 'r_cm=',r_cm

    xyz_to_angles,r_cm[0],r_cm[1],r_cm[2],rad,theta,phi
    sph_cm[0]=theta*(!PI/180.0)
    sph_cm[1]=phi*(!PI/180.0)
    sph_cm[2]=rad

    rr[0]= cos(sph_cm[0])*cos(sph_cm[1])*r_cm[0]+sin(sph_cm[0])*cos(sph_cm[1])*r_cm[1]-sin(sph_cm[1])*r_cm[2]
    rr[1]= -sin(sph_cm[0])*r_cm[0]+cos(sph_cm[0])*r_cm[1]
    rr[2]= cos(sph_cm[0])*sin(sph_cm[1])*r_cm[0]+sin(sph_cm[0])*sin(sph_cm[1])*r_cm[1]+cos(sph_cm[1])*r_cm[2]
    print, 'rr=',rr
    return, sph_cm
end
