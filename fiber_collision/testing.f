        implicit none
        integer Nmax,nlines,i
        PARAMETER(Nmax=2*10**8)
        REAL zt,nbart,stest
        REAL, ALLOCATABLE :: z(:),nbar(:),sec(:)
        CHARACTER nbarfile*200
        EXTERNAL stest

        nlines=0 
        ALLOCATE(z(Nmax),nbar(Nmax),sec(Nmax))
        nbarfile='/mount/riachuelo1/hahn/data/manera_mock/dr11/'//
     &  'nbar-dr11may22-N-Anderson-pz.dat'
        OPEN(UNIT=6,file=nbarfile,status='old',form='formatted')
        do i=1,Nmax
            read(6,*,end=12) zt,nbart
            z(i)=zt
            nbar(i)=nbart
            nlines=nlines+1
        ENDDO 
  12    CONTINUE
        CLOSE(6)
        CALL spline(z,nbar,nlines,3e30,3e30,sec)
        
        WRITE(*,*) stest(0.43,nlines,z,nbar,sec)
        WRITE(*,*) stest(0.5,nlines,z,nbar,sec)
        WRITE(*,*) stest(0.6,nlines,z,nbar,sec)
        WRITE(*,*) stest(0.7,nlines,z,nbar,sec)
        END


!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL FUNCTION stest(QQ,N,z,nbar,sec)
!^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        INTEGER N
        REAL z(N),nbar(N),sec(N) 
        REAL QQ,arg,self
        arg=QQ
        CALL splint(z,nbar,sec,N,arg,self)
        stest=self
        RETURN
        END 
!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        include '/home/users/hahn/powercode/spline.f'
        include '/home/users/hahn/powercode/splint.f'
