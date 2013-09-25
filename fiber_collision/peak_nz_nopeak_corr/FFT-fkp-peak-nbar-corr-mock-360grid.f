      implicit none  !as FFT_FKP_SDSS_LRG_new but removes some hard-cored choices
      integer i,j,k,ii,jj,kk,n,nn
      integer Nran,iwr,Ngal,Nmax,kx,ky,kz,Lm,Ngrid,ix,iy,iz
      integer Nnz,Ntail,wNgal
      integer Ng,Nr,iflag,ic,Nbin,l,ipoly,wb,wcp,wred,flag
      integer veto
      integer*8 planf
      real pi,cspeed,Om0,OL0,redtru,m1,m2
      REAL zt,zlo,zhi,garb1,garb2,garb3
      real cpz,cpnbarz
      REAL sigma,peakfrac
      PARAMETER(sigma=0.403852182,peakfrac=0.0)
      parameter(Nmax=2*10**8,Ngrid=360,Nbin=151,pi=3.141592654)
      parameter(Om0=0.27,OL0=0.73)
      integer grid
      dimension grid(3)
      parameter(cspeed=299800.0)
      integer, allocatable :: ig(:),ir(:)
      real dum,gfrac
      real peakrt,peakprt,pr
      real Rbox,wsys,wwsys,wsysr
      real, allocatable :: nbg(:),nbr(:),rg(:,:),rr(:,:),wg(:),wr(:)
      real, allocatable :: wwg(:)
      REAL, ALLOCATABLE :: z(:),selfun(:),sec(:)
      REAL, ALLOCATABLE :: dm(:),selfunchi(:),secchi(:)
      REAL, ALLOCATABLE :: tailz(:),tailnbarz(:),tailsec(:)
      REAL az,ra,dec,rad,numden,wbr,wcpr,wredr
      REAL dlosrt,dlosprt
      real alpha,P0,nb,weight,ar,akf,Fr,Fi,Gr,Gi
      real*8 I10,I12,I22,I13,I23,I33
      real kdotr,vol,xscale,rlow,rm(2)
      real ran1,ran2,ran3,pz
      real chi,nbar,nbarchi,peakpofr,tailnbar
      complex, allocatable :: dcg(:,:,:),dcr(:,:,:)
c      complex dcg(Ngrid,Ngrid,Ngrid),dcr(Ngrid,Ngrid,Ngrid)
      character selfunfile*200,lssfile*200,randomfile*200,filecoef*200
      CHARACTER peakfile*200,nbarfile*200,tailnbarfile*200
      character fname*200,fftname*200
      character Rboxstr*200,iflagstr*200,P0str*200
      external nbar,chi,nbar2,PutIntoBox,assign2,fcomb
      external peakpofr,nbarchi,tailnbar
      include '/home/users/hahn/powercode/fftw_f77.i'

      grid(1) = Ngrid
      grid(2) = Ngrid
      grid(3) = Ngrid
      call fftwnd_f77_create_plan(planf,3,grid,FFTW_BACKWARD,
     $     FFTW_ESTIMATE + FFTW_IN_PLACE)

      CALL getarg(1,Rboxstr)
      READ(Rboxstr,*) Rbox
      CALL getarg(2,iflagstr)
      READ(iflagstr,*) iflag
      CALL getarg(3,P0str) 
      READ(P0str,*) P0

      Lm=Ngrid
      xscale=2.*RBox
      rlow=-Rbox
    
      rm(1)=float(Lm)/xscale
      rm(2)=1.-rlow*rm(1)
      WRITE(*,*) 'Ngrid=',Ngrid,'Box=',xscale,'P0=',P0
     
      Nnz=0 
      ALLOCATE(z(Nmax),selfun(Nmax),sec(Nmax))
      ALLOCATE(dm(Nmax),selfunchi(Nmax),secchi(Nmax))
      CALL getarg(4,nbarfile)
      open(unit=3,file=nbarfile,status='old',form='formatted')
      do l=1,Nmax
            read(3,*,end=12) zt,zlo,zhi,numden,garb1,garb2,garb3
            z(l)= zt
            dm(l)= chi(zt)
            selfun(l)=numden
            selfunchi(l)=numden
            Nnz=Nnz+1
      enddo
 12   continue
      close(3)
      call spline(z,selfun,Nnz,3e30,3e30,sec)
      call spline(dm,selfunchi,Nnz,3e30,3e30,secchi)

      Ntail=0
      ALLOCATE(tailz(Nmax),tailnbarz(Nmax),tailsec(Nmax))
      CALL getarg(5,tailnbarfile)
      OPEN(UNIT=6,FILE=tailnbarfile,STATUS='old',FORM='FORMATTED')
      DO kk=1,Nmax
            READ(6,*,END=115) cpz,cpnbarz
            tailz(kk)=cpz
            tailnbarz(kk)=cpnbarz   
            Ntail=Ntail+1
      ENDDO  
 115  CONTINUE 
      CLOSE(6) 
      CALL spline(tailz,tailnbarz,Ntail,3e30,3e30,tailsec)
      
      if (iflag.eq.0) then ! run on mock
         CALL getarg(6,lssfile)
         allocate(rg(3,Nmax),nbg(Nmax),ig(Nmax),wg(Nmax),wwg(Nmax))
         open(unit=4,file=lssfile,status='old',form='formatted')

         Ngal=0 
         wNgal=0
         wsys=0.0
         CALL RANDOM_SEED
         DO i=1,Nmax
            READ(4,*,END=13)ra,dec,az,wb,wcp,wred,veto
            ra=ra*(pi/180.)
            dec=dec*(pi/180.)
            IF (wcp.gt.0 .and. wb.gt.0 .and. wred.gt.0 .and. veto.gt.0) 
     &      THEN 
                rad=chi(az)
                wg(Ngal+1)=float(wb)*(float(wcp)+float(wred)-1.0)
                rg(1,Ngal+1)=rad*cos(dec)*cos(ra)
                rg(2,Ngal+1)=rad*cos(dec)*sin(ra)
                rg(3,Ngal+1)=rad*sin(dec)
                nbg(Ngal+1)=nbar(az,Nnz,z,selfun,sec)
                wsys=wsys+wg(Ngal+1)
                Ngal=Ngal+1
            ELSE 
                ra=ra*(pi/180.)
                dec=dec*(pi/180.)
                rad=chi(az)
                wg(Ngal+1)=0.0
                rg(1,Ngal+1)=rad*cos(dec)*cos(ra)
                rg(2,Ngal+1)=rad*cos(dec)*sin(ra)
                rg(3,Ngal+1)=rad*sin(dec)
                nbg(Ngal+1)=nbar(az,Nnz,z,selfun,sec)
                wsys=wsys+wg(Ngal+1)
                Ngal=Ngal+1
            ENDIF
         enddo
 13      continue
         close(4)

         WRITE(*,*) 'Wsys=',wsys,'Ngal=',Ngal
         WRITE(*,*) 'Ngal,sys=',wsys/float(Ngal)
         
         call PutIntoBox(Ngal,rg,Rbox,ig,Ng,Nmax)
         gfrac=100. *float(Ng)/float(Ngal)
         WRITE(*,*) 'Ngal,box=',Ng,'Ngal=',Ngal,gfrac,'percent'

         allocate(dcg(Ngrid,Ngrid,Ngrid))
         call assign(Ngal,rg,rm,Lm,dcg,P0,nbg,ig,wg)
         call fftwnd_f77_one(planf,dcg,dcg)      
         call fcomb(Lm,dcg,Ng)

         call getarg(7,filecoef)
         open(unit=6,file=filecoef,status='unknown',form='unformatted')
         write(6)(((dcg(ix,iy,iz),ix=1,Lm/2+1),iy=1,Lm),iz=1,Lm)
         write(6)P0,Ng,wsys 
         close(6)

       elseif (iflag.eq.1) then 
         call getarg(6,randomfile)
         allocate(rr(3,Nmax),nbr(Nmax),ir(Nmax),wr(Nmax))
         open(unit=4,file=randomfile,status='old',form='formatted')
         Nran=0 
         wsysr=0.0
         do i=1,Nmax
            read(4,*,end=15)ra,dec,az,wbr,wcpr,wredr
            ra=ra*(pi/180.)
            dec=dec*(pi/180.)
            rad=chi(az)
            wr(i)=1.0
            wsysr=wsysr+1.0
            Nran=Nran+1
            rr(1,i)=rad*cos(dec)*cos(ra)
            rr(2,i)=rad*cos(dec)*sin(ra)
            rr(3,i)=rad*sin(dec)
            nbr(i)=nbar(az,Nnz,z,selfun,sec)
         enddo
 15      continue
         close(4)
      
         call PutIntoBox(Nran,rr,Rbox,ir,Nr,Nmax)
         gfrac=100. *float(Nr)/float(Nran)

         I10=0.d0
         I12=0.d0
         I22=0.d0
         I13=0.d0
         I23=0.d0
         I33=0.d0
         do i=1,Nr
            nb=nbr(i)  
            weight=1.d0/(1.d0+nb*P0) 
            I10=I10+1.d0
            I12=I12+dble(weight**2)
            I22=I22+dble(nb*weight**2)
            I13=I13+dble(weight**3)
            I23=I23+dble(nb*weight**3 )
            I33=I33+dble(nb**2 *weight**3)
         enddo

         allocate(dcr(Ngrid,Ngrid,Ngrid))
         call assign(Nran,rr,rm,Lm,dcr,P0,nbr,ir,wr)
         call fftwnd_f77_one(planf,dcr,dcr)      
         call fcomb(Lm,dcr,Nr)

         call getarg(7,filecoef)
         open(unit=6,file=filecoef,status='unknown',form='unformatted')
         write(6)(((dcr(ix,iy,iz),ix=1,Lm/2+1),iy=1,Lm),iz=1,Lm)
         write(6)real(I10),real(I12),real(I22),real(I13),real(I23),
     &   real(I33)
         write(6)P0,Nr,wsysr
         close(6)
      endif
      end
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      Subroutine PutIntoBox(Ng,rg,Rbox,ig,Ng2,Nmax)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      implicit none
      integer Nmax
c      parameter(Nmax=2*10**7)
      integer Ng,Ng2,j,i,ig(Nmax)
      real rg(3,Nmax),Rbox,acheck
      j=0
      do i=1,Ng
         acheck=abs(rg(1,i))+abs(rg(2,i))+abs(rg(3,i))
         if (acheck.gt.0.) then 
            if (abs(rg(1,i)).lt.Rbox .and. abs(rg(2,i)).lt.Rbox .and. 
     $           abs(rg(3,i)).lt.Rbox) then !put into box
               j=j+1
               ig(i)=1
            else
               ig(i)=0
            endif
         else
            ig(i)=0
         endif
      enddo
      Ng2=j
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      subroutine assign(N,r,rm,L,dtl,P0,nbg,ig,w) !with FKP weighing
cc*******************************************************************
      real dtl(2*L,L,L),r(3,N),rm(2),we,ar,nb,nbg(N),w(N)
      integer ig(N)
      external nbar
c
      do 1 iz=1,L
       do 1 iy=1,L
        do 1 ix=1,2*L
1        dtl(ix,iy,iz)=0.
c
      rca=rm(1)
      rcb=rm(2)
c
      do 2 i=1,N
      if (ig(i).eq.1) then

       we=w(i)/(1.+nbg(i)*P0) 
       
       rx=rca*r(1,i)+rcb
       ry=rca*r(2,i)+rcb
       rz=rca*r(3,i)+rcb
       tx=rx+0.5
       ty=ry+0.5
       tz=rz+0.5
       ixm1=int(rx)
       iym1=int(ry)
       izm1=int(rz)
       ixm2=2*mod(ixm1-2+L,L)+1
       ixp1=2*mod(ixm1,L)+1
       ixp2=2*mod(ixm1+1,L)+1
       hx=rx-ixm1
       ixm1=2*ixm1-1
       hx2=hx*hx
       hxm2=(1.-hx)**3
       hxm1=4.+(3.*hx-6.)*hx2
       hxp2=hx2*hx
       hxp1=6.-hxm2-hxm1-hxp2
c
       iym2=mod(iym1-2+L,L)+1
       iyp1=mod(iym1,L)+1
       iyp2=mod(iym1+1,L)+1
       hy=ry-iym1
       hy2=hy*hy
       hym2=(1.-hy)**3
       hym1=4.+(3.*hy-6.)*hy2
       hyp2=hy2*hy
       hyp1=6.-hym2-hym1-hyp2
c
       izm2=mod(izm1-2+L,L)+1
       izp1=mod(izm1,L)+1
       izp2=mod(izm1+1,L)+1
       hz=rz-izm1
       hz2=hz*hz
       hzm2=(1.-hz)**3
       hzm1=4.+(3.*hz-6.)*hz2
       hzp2=hz2*hz
       hzp1=6.-hzm2-hzm1-hzp2
c
       nxm1=int(tx)
       nym1=int(ty)
       nzm1=int(tz)
c
       gx=tx-nxm1
       nxm1=mod(nxm1-1,L)+1
       nxm2=2*mod(nxm1-2+L,L)+2
       nxp1=2*mod(nxm1,L)+2
       nxp2=2*mod(nxm1+1,L)+2
       nxm1=2*nxm1
       gx2=gx*gx
       gxm2=(1.-gx)**3
       gxm1=4.+(3.*gx-6.)*gx2
       gxp2=gx2*gx
       gxp1=6.-gxm2-gxm1-gxp2
c
       gy=ty-nym1
       nym1=mod(nym1-1,L)+1
       nym2=mod(nym1-2+L,L)+1
       nyp1=mod(nym1,L)+1
       nyp2=mod(nym1+1,L)+1
       gy2=gy*gy
       gym2=(1.-gy)**3
       gym1=4.+(3.*gy-6.)*gy2
       gyp2=gy2*gy
       gyp1=6.-gym2-gym1-gyp2
c
       gz=tz-nzm1
       nzm1=mod(nzm1-1,L)+1
       nzm2=mod(nzm1-2+L,L)+1
       nzp1=mod(nzm1,L)+1
       nzp2=mod(nzm1+1,L)+1
       gz2=gz*gz
       gzm2=(1.-gz)**3
       gzm1=4.+(3.*gz-6.)*gz2
       gzp2=gz2*gz
       gzp1=6.-gzm2-gzm1-gzp2
c
       dtl(ixm2,iym2,izm2)   = dtl(ixm2,iym2,izm2)+ hxm2*hym2 *hzm2*we
       dtl(ixm1,iym2,izm2)   = dtl(ixm1,iym2,izm2)+ hxm1*hym2 *hzm2*we
       dtl(ixp1,iym2,izm2)   = dtl(ixp1,iym2,izm2)+ hxp1*hym2 *hzm2*we
       dtl(ixp2,iym2,izm2)   = dtl(ixp2,iym2,izm2)+ hxp2*hym2 *hzm2*we
       dtl(ixm2,iym1,izm2)   = dtl(ixm2,iym1,izm2)+ hxm2*hym1 *hzm2*we
       dtl(ixm1,iym1,izm2)   = dtl(ixm1,iym1,izm2)+ hxm1*hym1 *hzm2*we
       dtl(ixp1,iym1,izm2)   = dtl(ixp1,iym1,izm2)+ hxp1*hym1 *hzm2*we
       dtl(ixp2,iym1,izm2)   = dtl(ixp2,iym1,izm2)+ hxp2*hym1 *hzm2*we
       dtl(ixm2,iyp1,izm2)   = dtl(ixm2,iyp1,izm2)+ hxm2*hyp1 *hzm2*we
       dtl(ixm1,iyp1,izm2)   = dtl(ixm1,iyp1,izm2)+ hxm1*hyp1 *hzm2*we
       dtl(ixp1,iyp1,izm2)   = dtl(ixp1,iyp1,izm2)+ hxp1*hyp1 *hzm2*we
       dtl(ixp2,iyp1,izm2)   = dtl(ixp2,iyp1,izm2)+ hxp2*hyp1 *hzm2*we
       dtl(ixm2,iyp2,izm2)   = dtl(ixm2,iyp2,izm2)+ hxm2*hyp2 *hzm2*we
       dtl(ixm1,iyp2,izm2)   = dtl(ixm1,iyp2,izm2)+ hxm1*hyp2 *hzm2*we
       dtl(ixp1,iyp2,izm2)   = dtl(ixp1,iyp2,izm2)+ hxp1*hyp2 *hzm2*we
       dtl(ixp2,iyp2,izm2)   = dtl(ixp2,iyp2,izm2)+ hxp2*hyp2 *hzm2*we
       dtl(ixm2,iym2,izm1)   = dtl(ixm2,iym2,izm1)+ hxm2*hym2 *hzm1*we
       dtl(ixm1,iym2,izm1)   = dtl(ixm1,iym2,izm1)+ hxm1*hym2 *hzm1*we
       dtl(ixp1,iym2,izm1)   = dtl(ixp1,iym2,izm1)+ hxp1*hym2 *hzm1*we
       dtl(ixp2,iym2,izm1)   = dtl(ixp2,iym2,izm1)+ hxp2*hym2 *hzm1*we
       dtl(ixm2,iym1,izm1)   = dtl(ixm2,iym1,izm1)+ hxm2*hym1 *hzm1*we
       dtl(ixm1,iym1,izm1)   = dtl(ixm1,iym1,izm1)+ hxm1*hym1 *hzm1*we
       dtl(ixp1,iym1,izm1)   = dtl(ixp1,iym1,izm1)+ hxp1*hym1 *hzm1*we
       dtl(ixp2,iym1,izm1)   = dtl(ixp2,iym1,izm1)+ hxp2*hym1 *hzm1*we
       dtl(ixm2,iyp1,izm1)   = dtl(ixm2,iyp1,izm1)+ hxm2*hyp1 *hzm1*we
       dtl(ixm1,iyp1,izm1)   = dtl(ixm1,iyp1,izm1)+ hxm1*hyp1 *hzm1*we
       dtl(ixp1,iyp1,izm1)   = dtl(ixp1,iyp1,izm1)+ hxp1*hyp1 *hzm1*we
       dtl(ixp2,iyp1,izm1)   = dtl(ixp2,iyp1,izm1)+ hxp2*hyp1 *hzm1*we
       dtl(ixm2,iyp2,izm1)   = dtl(ixm2,iyp2,izm1)+ hxm2*hyp2 *hzm1*we
       dtl(ixm1,iyp2,izm1)   = dtl(ixm1,iyp2,izm1)+ hxm1*hyp2 *hzm1*we
       dtl(ixp1,iyp2,izm1)   = dtl(ixp1,iyp2,izm1)+ hxp1*hyp2 *hzm1*we
       dtl(ixp2,iyp2,izm1)   = dtl(ixp2,iyp2,izm1)+ hxp2*hyp2 *hzm1*we
       dtl(ixm2,iym2,izp1)   = dtl(ixm2,iym2,izp1)+ hxm2*hym2 *hzp1*we
       dtl(ixm1,iym2,izp1)   = dtl(ixm1,iym2,izp1)+ hxm1*hym2 *hzp1*we
       dtl(ixp1,iym2,izp1)   = dtl(ixp1,iym2,izp1)+ hxp1*hym2 *hzp1*we
       dtl(ixp2,iym2,izp1)   = dtl(ixp2,iym2,izp1)+ hxp2*hym2 *hzp1*we
       dtl(ixm2,iym1,izp1)   = dtl(ixm2,iym1,izp1)+ hxm2*hym1 *hzp1*we
       dtl(ixm1,iym1,izp1)   = dtl(ixm1,iym1,izp1)+ hxm1*hym1 *hzp1*we
       dtl(ixp1,iym1,izp1)   = dtl(ixp1,iym1,izp1)+ hxp1*hym1 *hzp1*we
       dtl(ixp2,iym1,izp1)   = dtl(ixp2,iym1,izp1)+ hxp2*hym1 *hzp1*we
       dtl(ixm2,iyp1,izp1)   = dtl(ixm2,iyp1,izp1)+ hxm2*hyp1 *hzp1*we
       dtl(ixm1,iyp1,izp1)   = dtl(ixm1,iyp1,izp1)+ hxm1*hyp1 *hzp1*we
       dtl(ixp1,iyp1,izp1)   = dtl(ixp1,iyp1,izp1)+ hxp1*hyp1 *hzp1*we
       dtl(ixp2,iyp1,izp1)   = dtl(ixp2,iyp1,izp1)+ hxp2*hyp1 *hzp1*we
       dtl(ixm2,iyp2,izp1)   = dtl(ixm2,iyp2,izp1)+ hxm2*hyp2 *hzp1*we
       dtl(ixm1,iyp2,izp1)   = dtl(ixm1,iyp2,izp1)+ hxm1*hyp2 *hzp1*we
       dtl(ixp1,iyp2,izp1)   = dtl(ixp1,iyp2,izp1)+ hxp1*hyp2 *hzp1*we
       dtl(ixp2,iyp2,izp1)   = dtl(ixp2,iyp2,izp1)+ hxp2*hyp2 *hzp1*we
       dtl(ixm2,iym2,izp2)   = dtl(ixm2,iym2,izp2)+ hxm2*hym2 *hzp2*we
       dtl(ixm1,iym2,izp2)   = dtl(ixm1,iym2,izp2)+ hxm1*hym2 *hzp2*we
       dtl(ixp1,iym2,izp2)   = dtl(ixp1,iym2,izp2)+ hxp1*hym2 *hzp2*we
       dtl(ixp2,iym2,izp2)   = dtl(ixp2,iym2,izp2)+ hxp2*hym2 *hzp2*we
       dtl(ixm2,iym1,izp2)   = dtl(ixm2,iym1,izp2)+ hxm2*hym1 *hzp2*we
       dtl(ixm1,iym1,izp2)   = dtl(ixm1,iym1,izp2)+ hxm1*hym1 *hzp2*we
       dtl(ixp1,iym1,izp2)   = dtl(ixp1,iym1,izp2)+ hxp1*hym1 *hzp2*we
       dtl(ixp2,iym1,izp2)   = dtl(ixp2,iym1,izp2)+ hxp2*hym1 *hzp2*we
       dtl(ixm2,iyp1,izp2)   = dtl(ixm2,iyp1,izp2)+ hxm2*hyp1 *hzp2*we
       dtl(ixm1,iyp1,izp2)   = dtl(ixm1,iyp1,izp2)+ hxm1*hyp1 *hzp2*we
       dtl(ixp1,iyp1,izp2)   = dtl(ixp1,iyp1,izp2)+ hxp1*hyp1 *hzp2*we
       dtl(ixp2,iyp1,izp2)   = dtl(ixp2,iyp1,izp2)+ hxp2*hyp1 *hzp2*we
       dtl(ixm2,iyp2,izp2)   = dtl(ixm2,iyp2,izp2)+ hxm2*hyp2 *hzp2*we
       dtl(ixm1,iyp2,izp2)   = dtl(ixm1,iyp2,izp2)+ hxm1*hyp2 *hzp2*we
       dtl(ixp1,iyp2,izp2)   = dtl(ixp1,iyp2,izp2)+ hxp1*hyp2 *hzp2*we
       dtl(ixp2,iyp2,izp2)   = dtl(ixp2,iyp2,izp2)+ hxp2*hyp2 *hzp2*we
c
       dtl(nxm2,nym2,nzm2)   = dtl(nxm2,nym2,nzm2)+ gxm2*gym2 *gzm2*we
       dtl(nxm1,nym2,nzm2)   = dtl(nxm1,nym2,nzm2)+ gxm1*gym2 *gzm2*we
       dtl(nxp1,nym2,nzm2)   = dtl(nxp1,nym2,nzm2)+ gxp1*gym2 *gzm2*we
       dtl(nxp2,nym2,nzm2)   = dtl(nxp2,nym2,nzm2)+ gxp2*gym2 *gzm2*we
       dtl(nxm2,nym1,nzm2)   = dtl(nxm2,nym1,nzm2)+ gxm2*gym1 *gzm2*we
       dtl(nxm1,nym1,nzm2)   = dtl(nxm1,nym1,nzm2)+ gxm1*gym1 *gzm2*we
       dtl(nxp1,nym1,nzm2)   = dtl(nxp1,nym1,nzm2)+ gxp1*gym1 *gzm2*we
       dtl(nxp2,nym1,nzm2)   = dtl(nxp2,nym1,nzm2)+ gxp2*gym1 *gzm2*we
       dtl(nxm2,nyp1,nzm2)   = dtl(nxm2,nyp1,nzm2)+ gxm2*gyp1 *gzm2*we
       dtl(nxm1,nyp1,nzm2)   = dtl(nxm1,nyp1,nzm2)+ gxm1*gyp1 *gzm2*we
       dtl(nxp1,nyp1,nzm2)   = dtl(nxp1,nyp1,nzm2)+ gxp1*gyp1 *gzm2*we
       dtl(nxp2,nyp1,nzm2)   = dtl(nxp2,nyp1,nzm2)+ gxp2*gyp1 *gzm2*we
       dtl(nxm2,nyp2,nzm2)   = dtl(nxm2,nyp2,nzm2)+ gxm2*gyp2 *gzm2*we
       dtl(nxm1,nyp2,nzm2)   = dtl(nxm1,nyp2,nzm2)+ gxm1*gyp2 *gzm2*we
       dtl(nxp1,nyp2,nzm2)   = dtl(nxp1,nyp2,nzm2)+ gxp1*gyp2 *gzm2*we
       dtl(nxp2,nyp2,nzm2)   = dtl(nxp2,nyp2,nzm2)+ gxp2*gyp2 *gzm2*we
       dtl(nxm2,nym2,nzm1)   = dtl(nxm2,nym2,nzm1)+ gxm2*gym2 *gzm1*we
       dtl(nxm1,nym2,nzm1)   = dtl(nxm1,nym2,nzm1)+ gxm1*gym2 *gzm1*we
       dtl(nxp1,nym2,nzm1)   = dtl(nxp1,nym2,nzm1)+ gxp1*gym2 *gzm1*we
       dtl(nxp2,nym2,nzm1)   = dtl(nxp2,nym2,nzm1)+ gxp2*gym2 *gzm1*we
       dtl(nxm2,nym1,nzm1)   = dtl(nxm2,nym1,nzm1)+ gxm2*gym1 *gzm1*we
       dtl(nxm1,nym1,nzm1)   = dtl(nxm1,nym1,nzm1)+ gxm1*gym1 *gzm1*we
       dtl(nxp1,nym1,nzm1)   = dtl(nxp1,nym1,nzm1)+ gxp1*gym1 *gzm1*we
       dtl(nxp2,nym1,nzm1)   = dtl(nxp2,nym1,nzm1)+ gxp2*gym1 *gzm1*we
       dtl(nxm2,nyp1,nzm1)   = dtl(nxm2,nyp1,nzm1)+ gxm2*gyp1 *gzm1*we
       dtl(nxm1,nyp1,nzm1)   = dtl(nxm1,nyp1,nzm1)+ gxm1*gyp1 *gzm1*we
       dtl(nxp1,nyp1,nzm1)   = dtl(nxp1,nyp1,nzm1)+ gxp1*gyp1 *gzm1*we
       dtl(nxp2,nyp1,nzm1)   = dtl(nxp2,nyp1,nzm1)+ gxp2*gyp1 *gzm1*we
       dtl(nxm2,nyp2,nzm1)   = dtl(nxm2,nyp2,nzm1)+ gxm2*gyp2 *gzm1*we
       dtl(nxm1,nyp2,nzm1)   = dtl(nxm1,nyp2,nzm1)+ gxm1*gyp2 *gzm1*we
       dtl(nxp1,nyp2,nzm1)   = dtl(nxp1,nyp2,nzm1)+ gxp1*gyp2 *gzm1*we
       dtl(nxp2,nyp2,nzm1)   = dtl(nxp2,nyp2,nzm1)+ gxp2*gyp2 *gzm1*we
       dtl(nxm2,nym2,nzp1)   = dtl(nxm2,nym2,nzp1)+ gxm2*gym2 *gzp1*we
       dtl(nxm1,nym2,nzp1)   = dtl(nxm1,nym2,nzp1)+ gxm1*gym2 *gzp1*we
       dtl(nxp1,nym2,nzp1)   = dtl(nxp1,nym2,nzp1)+ gxp1*gym2 *gzp1*we
       dtl(nxp2,nym2,nzp1)   = dtl(nxp2,nym2,nzp1)+ gxp2*gym2 *gzp1*we
       dtl(nxm2,nym1,nzp1)   = dtl(nxm2,nym1,nzp1)+ gxm2*gym1 *gzp1*we
       dtl(nxm1,nym1,nzp1)   = dtl(nxm1,nym1,nzp1)+ gxm1*gym1 *gzp1*we
       dtl(nxp1,nym1,nzp1)   = dtl(nxp1,nym1,nzp1)+ gxp1*gym1 *gzp1*we
       dtl(nxp2,nym1,nzp1)   = dtl(nxp2,nym1,nzp1)+ gxp2*gym1 *gzp1*we
       dtl(nxm2,nyp1,nzp1)   = dtl(nxm2,nyp1,nzp1)+ gxm2*gyp1 *gzp1*we
       dtl(nxm1,nyp1,nzp1)   = dtl(nxm1,nyp1,nzp1)+ gxm1*gyp1 *gzp1*we
       dtl(nxp1,nyp1,nzp1)   = dtl(nxp1,nyp1,nzp1)+ gxp1*gyp1 *gzp1*we
       dtl(nxp2,nyp1,nzp1)   = dtl(nxp2,nyp1,nzp1)+ gxp2*gyp1 *gzp1*we
       dtl(nxm2,nyp2,nzp1)   = dtl(nxm2,nyp2,nzp1)+ gxm2*gyp2 *gzp1*we
       dtl(nxm1,nyp2,nzp1)   = dtl(nxm1,nyp2,nzp1)+ gxm1*gyp2 *gzp1*we
       dtl(nxp1,nyp2,nzp1)   = dtl(nxp1,nyp2,nzp1)+ gxp1*gyp2 *gzp1*we
       dtl(nxp2,nyp2,nzp1)   = dtl(nxp2,nyp2,nzp1)+ gxp2*gyp2 *gzp1*we
       dtl(nxm2,nym2,nzp2)   = dtl(nxm2,nym2,nzp2)+ gxm2*gym2 *gzp2*we
       dtl(nxm1,nym2,nzp2)   = dtl(nxm1,nym2,nzp2)+ gxm1*gym2 *gzp2*we
       dtl(nxp1,nym2,nzp2)   = dtl(nxp1,nym2,nzp2)+ gxp1*gym2 *gzp2*we
       dtl(nxp2,nym2,nzp2)   = dtl(nxp2,nym2,nzp2)+ gxp2*gym2 *gzp2*we
       dtl(nxm2,nym1,nzp2)   = dtl(nxm2,nym1,nzp2)+ gxm2*gym1 *gzp2*we
       dtl(nxm1,nym1,nzp2)   = dtl(nxm1,nym1,nzp2)+ gxm1*gym1 *gzp2*we
       dtl(nxp1,nym1,nzp2)   = dtl(nxp1,nym1,nzp2)+ gxp1*gym1 *gzp2*we
       dtl(nxp2,nym1,nzp2)   = dtl(nxp2,nym1,nzp2)+ gxp2*gym1 *gzp2*we
       dtl(nxm2,nyp1,nzp2)   = dtl(nxm2,nyp1,nzp2)+ gxm2*gyp1 *gzp2*we
       dtl(nxm1,nyp1,nzp2)   = dtl(nxm1,nyp1,nzp2)+ gxm1*gyp1 *gzp2*we
       dtl(nxp1,nyp1,nzp2)   = dtl(nxp1,nyp1,nzp2)+ gxp1*gyp1 *gzp2*we
       dtl(nxp2,nyp1,nzp2)   = dtl(nxp2,nyp1,nzp2)+ gxp2*gyp1 *gzp2*we
       dtl(nxm2,nyp2,nzp2)   = dtl(nxm2,nyp2,nzp2)+ gxm2*gyp2 *gzp2*we
       dtl(nxm1,nyp2,nzp2)   = dtl(nxm1,nyp2,nzp2)+ gxm1*gyp2 *gzp2*we
       dtl(nxp1,nyp2,nzp2)   = dtl(nxp1,nyp2,nzp2)+ gxp1*gyp2 *gzp2*we
       dtl(nxp2,nyp2,nzp2)   = dtl(nxp2,nyp2,nzp2)+ gxp2*gyp2 *gzp2*we
       endif
2     continue
c
      write(*,*)rca,rcb,P0
      return
      end
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL function nbar(QQ,N,z,selfun,sec) !nbar(z)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      INTEGER N
      real z(N),selfun(N),sec(N),self,az,QQ
      az=QQ
      if (az.lt.0.0 .or. az.gt.1.5) then
         nbar=0.0
      else
          call splint(z,selfun,sec,N,az,self)
          nbar=self 
      endif
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL function nbarchi(QQ,N,dm,selfunchi,secchi) !nbar(comdis)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      INTEGER N
      real dm(N),selfunchi(N),secchi(N),self,ar,QQ
      ar=QQ
      call splint(dm,selfunchi,secchi,N,ar,self)
      nbarchi=self 
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL function peakpofr(QQQ) !peakpofr(r)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      REAL sigma
      PARAMETER(sigma=0.403852182)
      REAL peakar,QQQ
      peakar=QQQ
      peakpofr=EXP(-1.0*ABS(peakar)/sigma) 
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL function tailnbar(QQQ,N,tailz,tailnbarz,tailsec)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      INTEGER N
      REAL tailz(N),tailnbarz(N),tailsec(N)
      REAL tailself,tailar,QQQ
      tailar=QQQ
      CALL splint(tailz,tailnbarz,tailsec,N,tailar,tailself)
      tailnbar=tailself
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL function chi(x) !radial distance in Mpc/h as a function of z
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      real*8 qmin,qmax,ans,rdi,epsabs,epsrel,abserr
      parameter (limit=1000)
      integer neval,ier,iord(limit),last
      real*8 alist(limit),blist(limit),elist(limit),rlist(limit)
      external rdi,dqage
      common/radint/Om0,OL0
      qmin=0.d0
      qmax=dble(x)
      epsabs=0.d0
      epsrel=1.d-2                                                            
      call dqage(rdi,qmin,qmax,epsabs,epsrel,30,limit,ans,abserr,
     $ neval,ier,alist,blist,rlist,elist,iord,last)
      chi=real(ans)
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      real*8 function rdi(z) !radial distance integrand
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      real Om0,OL0
      parameter (Om0=0.27,OL0=0.73)  
      real*8 z
      rdi=3000.d0/dsqrt(OL0+(1.d0-Om0-OL0)*(1.d0+z)**2+Om0*(1.d0+z)**3)
      return
      end
cc*******************************************************************
      subroutine fcomb(L,dcl,N)
cc*******************************************************************
      implicit none
      integer L,Lnyq,ix,iy,iz,icx,icy,icz,N
      real cf,rkx,rky,rkz,wkx,wky,wkz,cfac
      complex dcl(L,L,L)
      real*8 tpi,tpiL,piL
      complex*16 rec,xrec,yrec,zrec
      complex c1,ci,c000,c001,c010,c011,cma,cmb,cmc,cmd
      tpi=6.283185307d0
c
      cf=1./(6.**3*4.) !*float(N)) not needed for FKP
      Lnyq=L/2+1
      tpiL=tpi/float(L)
      piL=-tpiL/2.
      rec=cmplx(dcos(piL),dsin(piL))
      c1=cmplx(1.,0.)
      ci=cmplx(0.,1.)
      zrec=c1
      do 301 iz=1,Lnyq
       icz=mod(L-iz+1,L)+1
       rkz=tpiL*(iz-1)
       Wkz=1.
       if(rkz.ne.0.)Wkz=(sin(rkz/2.)/(rkz/2.))**4
       yrec=c1
       do 302 iy=1,Lnyq
        icy=mod(L-iy+1,L)+1
        rky=tpiL*(iy-1)
        Wky=1.
        if(rky.ne.0.)Wky=(sin(rky/2.)/(rky/2.))**4
        xrec=c1
        do 303 ix=1,Lnyq
         icx=mod(L-ix+1,L)+1
         rkx=tpiL*(ix-1)
         Wkx=1.
         if(rkx.ne.0.)Wkx=(sin(rkx/2.)/(rkx/2.))**4
         cfac=cf/(Wkx*Wky*Wkz)
c
         cma=ci*xrec*yrec*zrec
         cmb=ci*xrec*yrec*conjg(zrec)
         cmc=ci*xrec*conjg(yrec)*zrec
         cmd=ci*xrec*conjg(yrec*zrec)
c
         c000=dcl(ix,iy ,iz )*(c1-cma)+conjg(dcl(icx,icy,icz))*(c1+cma)
         c001=dcl(ix,iy ,icz)*(c1-cmb)+conjg(dcl(icx,icy,iz ))*(c1+cmb)
         c010=dcl(ix,icy,iz )*(c1-cmc)+conjg(dcl(icx,iy ,icz))*(c1+cmc)
         c011=dcl(ix,icy,icz)*(c1-cmd)+conjg(dcl(icx,iy ,iz ))*(c1+cmd)
c
c
         dcl(ix,iy ,iz )=c000*cfac
         dcl(ix,iy ,icz)=c001*cfac
         dcl(ix,icy,iz )=c010*cfac
         dcl(ix,icy,icz)=c011*cfac
         dcl(icx,iy ,iz )=conjg(dcl(ix,icy,icz))
         dcl(icx,iy ,icz)=conjg(dcl(ix,icy,iz ))
         dcl(icx,icy,iz )=conjg(dcl(ix,iy ,icz))
         dcl(icx,icy,icz)=conjg(dcl(ix,iy ,iz ))
c
         xrec=xrec*rec
303     continue
        yrec=yrec*rec
302    continue
       zrec=zrec*rec
301   continue
c
      return
      end
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      include '/home/users/hahn/powercode/dqage.f'
      include '/home/users/hahn/powercode/d1mach.f'
      include '/home/users/hahn/powercode/dqawfe.f'
      include '/home/users/hahn/powercode/spline.f'
      include '/home/users/hahn/powercode/splint.f'
      include '/home/users/hahn/powercode/gabqx.f'
