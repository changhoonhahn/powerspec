      implicit none  !as FFT_FKP_SDSS_LRG_new but removes some hard-cored choices
      integer Nsel,Nran,i,iwr,Ngal,Nmax,n,kx,ky,kz,Lm,Ngrid,ix,iy,iz,j,k
      integer Ng,Nr,iflag,ic,Nbin,l,outside
      integer*8 planf
      real pi,cspeed
      parameter(Nsel=201,Nmax=2*10**8,Ngrid=10,Nbin=151)
      parameter(pi=3.141592654)
      integer grid
      dimension grid(3)
      parameter(cspeed=299800.0)
      integer, allocatable :: ig(:),ir(:)
      real zbin(Nbin),dbin(Nbin),sec3(Nbin),zt,dum,gfrac
      real cz,Om0,OL0,sec2(Nsel),chi,nbar,Rbox
      real, allocatable :: nbg(:),nbr(:),rg(:,:),rr(:,:),wg(:),wr(:)
      real selfun(Nsel),z(Nsel),sec(Nsel),zmin,zmax,az,ra,dec,rad,numden
      real w, nbb, wsys
      real alpha,P0,nb,weight,ar,akf,Fr,Fi,Gr,Gi
      real*8 I10,I12,I22,I13,I23,I33
      real kdotr,vol,xscale,rlow,rm(2)
      complex, allocatable :: dcg(:,:,:),dcr(:,:,:)
c      complex dcg(Ngrid,Ngrid,Ngrid),dcr(Ngrid,Ngrid,Ngrid)
      character selfunfile*200,lssfile*200,randomfile*200,filecoef*200
      character spltest*200,fname*200,outname*200
      CHARACTER dcgfile*200,dcgfname*200,dcrfile*200,dcrfname*200
      CHARACTER xyzfname*200
      common /interpol/z,selfun,sec
      common /interpol2/ra,sec2
      common /interp3/dbin,zbin,sec3
      common /radint/Om0,OL0
      common /Nrandom/Nran
      external nbar,chi,nbar2,PutIntoBox,assign2,fcomb
      include 'fftw_f77.i'
      grid(1) = Ngrid
      grid(2) = Ngrid
      grid(3) = Ngrid
      call fftwnd_f77_create_plan(planf,3,grid,FFTW_BACKWARD,
     $     FFTW_ESTIMATE + FFTW_IN_PLACE)

      write(*,*)'cosmological parameters: Om0, OL0'
      read(*,*)Om0,OL0
      zmax=1.1
      do ic=1,Nbin
         zt=zmax*float(ic-1)/float(Nbin-1)
         zbin(ic)=zt
         dbin(ic)=chi(zt)
      enddo
      call spline(dbin,zbin,Nbin,3e30,3e30,sec3)

      write(*,*)'semibox side (like radius of sphere)'
      read(*,*)Rbox

      Lm=Ngrid
      xscale=2.*RBox
      rlow=-Rbox
         rm(1)=float(Lm)/xscale
         rm(2)=1.-rlow*rm(1)
      
      write(*,*)'mock (0) or random mock(1)?'
      read(*,*)iflag
      write(*,*)'FKP weight P0?'
      read(*,*)P0

      call spline(z,selfun,Nsel,3e30,3e30,sec)

      if (iflag.eq.0) then ! run on mock
      
         write(*,*)'Mock Survey File'
         read(*,'(a)')lssfile
         fname='/mount/chichipio2/hahn/data/'//lssfile 
         allocate(rg(3,Nmax),nbg(Nmax),ig(Nmax),wg(Nmax))
         open(unit=4,file=fname,status='old',form='formatted')
         Ngal=0 !Ngal will get determined later after survey is put into a box (Ng)
         wsys=0.0
         do i=1,Nmax
            read(4,*,end=13)ra,dec,az,w,nbb
            ra=ra*(pi/180.)
            dec=dec*(pi/180.)
            rad=chi(az)
            !Completeness Weight of the galaxy
            wg(i)=w
            rg(1,i)=rad*cos(dec)*cos(ra)
            rg(2,i)=rad*cos(dec)*sin(ra)
            rg(3,i)=rad*sin(dec)
            nbg(i)=nbb
            wsys=wsys+w*(1.0+nbb*P0)
            Ngal=Ngal+1
         enddo
 13      continue
!         close(7)
         close(4)

         WRITE(*,*) 'Ngal=',Ngal
         WRITE(*,*) 'min x',MINVAL(rg(1,:)),'max x',MAXVAL(rg(1,:))
         WRITE(*,*) 'min y',MINVAL(rg(2,:)),'max y',MAXVAL(rg(2,:))
         WRITE(*,*) 'min z',MINVAL(rg(3,:)),'max z',MAXVAL(rg(3,:))
         WRITE(*,*) 'Ngalsys',wsys,'avg w:',wsys/float(Ngal)

         xyzfname='/mount/chichipio2/hahn/data/cmass-dr10v5-N-xyz.dat'
         OPEN(UNIT=4,FILE=xyzfname,STATUS='UNKNOWN',FORM='FORMATTED')
         DO i=1,Ngal
            WRITE(4,1005) rg(1,i),rg(2,i),rg(3,i)
         ENDDO
         CLOSE(4)
 1005    FORMAT(3(2x,E16.6))

         call PutIntoBox(Ngal,rg,Rbox,ig,Ng,Nmax)
         gfrac=100. *float(Ng)/float(Ngal)
         write(*,*)'Number of Galaxies in Box=',Ng,gfrac,'percent'
       

         allocate(dcg(Ngrid,Ngrid,Ngrid))
         call assign(Ngal,rg,rm,Lm,dcg,P0,nbg,ig,wg)
         write(*,*) 'assign done!'
         write(*,*) 'DCG Output file:'
         read(*,'(a)') dcgfile
         dcgfname='/mount/chichipio2/hahn/FFT/'//dcgfile
         OPEN(unit=4,file=dcgfname,status='unknown',form='formatted')
         DO iz=1,Ngrid
            DO iy=1,Ngrid
                DO ix=1,Ngrid
                    WRITE(4,1015) ix,iy,iz,real(dcg(ix,iy,iz))
     &              ,aimag(dcg(ix,iy,iz))
                ENDDO
            ENDDO
         ENDDO
         CLOSE(4)
 1015    FORMAT(3(2x,I3),2x,E16.6,2x,E16.6)

         call fftwnd_f77_one(planf,dcg,dcg)      
         write(*,*) 'FFT done!'
         call fcomb(Lm,dcg,Ng)
         write(*,*) 'recombination done!'
         write(*,*) 'Fourier file :'
         read(*,'(a)') filecoef
         outname='/mount/chichipio2/hahn/FFT/'//filecoef
         open(unit=4,file=outname,status='unknown',form='unformatted')
         write(4)(((dcg(ix,iy,iz),ix=1,Lm/2+1),iy=1,Lm),iz=1,Lm)
         write(4)P0,Ng,wsys
         close(4)

       elseif (iflag.eq.1) then ! compute discretness integrals and FFT random mock
         write(*,*)'Random Survey File'
         read(*,'(a)')randomfile
         fname='/mount/chichipio2/hahn/data/'//randomfile
         allocate(rr(3,Nmax),nbr(Nmax),ir(Nmax),wr(Nmax))
         open(unit=4,file=fname,status='old',form='formatted')
         Nran=0 !Ngal will get determined later after survey is put into a box (Nr)
         wsys=0.0
         outside=0
         do i=1,Nmax
            read(4,*,end=15)ra,dec,az,w,nbb
            ra=ra*(pi/180.)
            dec=dec*(pi/180.)
            rad=chi(az)
            rr(1,i)=rad*cos(dec)*cos(ra)
            rr(2,i)=rad*cos(dec)*sin(ra)
            rr(3,i)=rad*sin(dec)
            nbr(i)=nbb
            wr(i) =w
            wsys=wsys+w
            Nran=Nran+1
            IF (rr(1,i).gt.0.0 .or. rr(1,i).lt.-2345.244 .or. 
     &      rr(2,i).gt.1872.209 .or. rr(2,i).lt.-2072.302 .or. 
     &      rr(3,i).gt.1968.855 .or. rr(3,i).lt.-119.64) THEN
                outside=outside+1
            ENDIF
         enddo
 15      continue
         close(4)
       
         WRITE(*,*) 'min x',MINVAL(rr(1,:)),'max x',MAXVAL(rr(1,:))
         WRITE(*,*) 'min y',MINVAL(rr(2,:)),'max y',MAXVAL(rr(2,:))
         WRITE(*,*) 'min z',MINVAL(rr(3,:)),'max z',MAXVAL(rr(3,:))
         WRITE(*,*) 'outside',outside
         WRITE(*,*) 'outside frac',float(outside)/float(Ngal)
         xyzfname=
     &   '/mount/chichipio2/hahn/data/cmass-dr10v5-N-xyz.ran.dat'
         OPEN(UNIT=4,FILE=xyzfname,STATUS='UNKNOWN',FORM='FORMATTED')
         DO i=1,Ngal
            WRITE(4,1010)rr(1,i),rr(2,i),rr(3,i)
         ENDDO
         CLOSE(4)
 1010    FORMAT(3(2x,E16.6))

         call PutIntoBox(Nran,rr,Rbox,ir,Nr,Nmax)
         gfrac=100. *float(Nr)/float(Nran)
         write(*,*)'Number of Random in Box=',Nr,gfrac,'percent'

         I10=0.d0
         I12=0.d0
         I22=0.d0
         I13=0.d0
         I23=0.d0
         I33=0.d0
         do i=1,Nr
            nb=nbr(i)  
            weight=wr(i)
            !1./(1.+nb*P0) 
            I10=I10+1.d0
            I12=I12+dble(weight**2)
            I22=I22+dble(nb*weight**2)
            I13=I13+dble(weight**3)
            I23=I23+dble(nb*weight**3 )
            I33=I33+dble(nb**2 *weight**3)
         enddo
         write(*,*)'the following need to be scaled by alpha later'
         write(*,*)'I10=',I10,'I12=',I12,'I22=',I22
         write(*,*)'I13=',I13,'I23=',I23,'I33=',I33

         allocate(dcr(Ngrid,Ngrid,Ngrid))
         call assign(Nran,rr,rm,Lm,dcr,P0,nbr,ir,wr)
         write(*,*) 'assign done!'

         write(*,*) 'DCR Output file:'
         read(*,'(a)') dcrfile
         dcrfname='/mount/chichipio2/hahn/FFT/'//dcrfile
         OPEN(unit=4,file=dcrfname,status='unknown',form='formatted')
         DO iz=1,Ngrid
            DO iy=1,Ngrid
                DO ix=1,Ngrid
                    WRITE(4,1035) ix,iy,iz,real(dcr(ix,iy,iz))
     &              ,aimag(dcr(ix,iy,iz))
                ENDDO
            ENDDO
         ENDDO
         CLOSE(4)
 1035    FORMAT(3(2x,I16),2x,E16.6,2x,E16.6)
     
         call fftwnd_f77_one(planf,dcr,dcr)      
         write(*,*) 'FFT done!'
         call fcomb(Lm,dcr,Nr)
         write(*,*) 'recombination done!'

         write(*,*) 'Fourier file :'
         read(*,'(a)') filecoef
         outname='/mount/chichipio2/hahn/FFT/'//filecoef
         open(unit=4,file=outname,status='unknown',form='unformatted')
         write(4)(((dcr(ix,iy,iz),ix=1,Lm/2+1),iy=1,Lm),iz=1,Lm)
         write(4)real(I10),real(I12),real(I22),real(I13),real(I23),
     &   real(I33)
         write(4)P0,Nr
         close(4)
         
      endif
      

 1025 format(2x,6e14.6)
 123  stop
      end
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      Subroutine PutIntoBox(Ng,rg,Rbox,ig,Ng2,Nmax)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      implicit none
      integer Nmax
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

       ! wg is the  
       we=w(i)
       !/(1.+nbg(i)*P0) 

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
      REAL function nbar(QQ,iflag) !nbar(z)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      parameter(Nsel=201)!80)
      integer iflag
      real z(Nsel),selfun(Nsel),sec(Nsel),self,az,qq,area_ang
      common /interpol/z,selfun,sec
      common/radint/Om0,OL0
      common /zbounds/zmin,zmax
      real Om0,OL0
      external chi
      az=QQ
c      if (az.lt.zmin-0.05 .or. az.gt.0.47) then
      if (az.lt.0.0 .or. az.gt.1.5) then
         nbar=0.
      else
         call splint(z,selfun,sec,Nsel,az,self)
c         self=2.4e-5 ! 21.8
c         self=9.5e-5 ! 21.2 and full?
         if (iflag.eq.0) then
            nbar=self !for clustered mock
         else
            nbar=self ! for 10x random mock
         endif
      endif
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL function zdis(ar) !interpolation redshift(distance)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      parameter(Nbin=151)
      common /interp3/dbin,zbin,sec3
      real dbin(Nbin),zbin(Nbin),sec3(Nbin)
      call splint(dbin,zbin,sec3,Nbin,ar,zdis)
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
      common/radint/Om0,OL0
      real Om0,OL0
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
      include 'dqage.f'
      include 'd1mach.f'
      include 'dqawfe.f'
      include 'spline.f'
      include 'splint.f'
      include 'gabqx.f'
