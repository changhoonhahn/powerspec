c     ifort -O4 -o bisp_fast_norm_fftw2.exe bisp_fast_norm_fftw2.f -L/usr/local/fftw_intel_s/lib -lsrfftw -lsfftw
      include '/usr/local/src/fftw-2.1.5/fortran/fftw_f77.i'
      integer nside, nsideD, Dim, nn(3), nmax
      integer*8 planf
c *** INPUT (Check always) *******************************************
c      parameter(nside=240,nmax=80)
c      parameter(nside=180,nmax=30)
c      parameter(nside=480,nmax=53)
      parameter(nside=360,nmax=40)
c ********************************************************************
      parameter(Dim=3,nsideD=nside**Dim) 
      data nn/nside,nside,nside/
      integer i, j, l, m, n, nk(0:2*nside), nbk(0:2*nside+1)
      integer iseed, indx(nsideD), id, jd, ld, nmodes, ndim,k,ix,iy,iz
c      real normk(nsideD,nmax), norm1(2,nsideD),coun(nmax,nmax,nmax)
      real, allocatable :: normk(:,:),norm1(:,:)
      real di, dj, dl, eightpi2, avg, bi
      real*8 sumn, coun(nmax,nmax,nmax)
      real dist, sum , step
      real rand,fac,Fr,Fi,Pt,Rr,Ri
      integer clck_count_beg,clck_count_end,clck_rate
      integer nobj,ip,aexp,p,dpnp1,dpn,ibuf,lm,mcode,Ncut,ng,Ncuts
      character*255 filebisp, filecoef

      eightpi2 = 78.95683521

c *** INPUT (Check always) *******************************************
c      filecoef='counts2_n240_nmax80_ncut2_s1'
      filecoef='counts2_n360_nmax40_ncut3_s3'
      step=3.0  ! Step size
      Ncut=3   ! Infrared Cutoff (must be multiple of bin size)
      Ncuts=Ncut/int(step)
c ********************************************************************

      CALL SYSTEM_CLOCK(clck_count_beg, clck_rate)

      call fftw3d_f77_create_plan(planf,nside,nside,nside,
     $ FFTW_FORWARD,FFTW_ESTIMATE+FFTW_IN_PLACE)

      do i=0,2*nside
         nk(i)=0
      enddo

c     Find modes of amplitude |k|
      write(*,*) 'Find modes of amplitude |k|'

      do i = 0, nside -1
         do j = 0, nside -1
            do l = 0, nside  -1
               di = float(min(i,nside-i))
               dj = float(min(j,nside-j))
               dl = float(min(l,nside-l))
               dist = sqrt(di*di + dj*dj +dl*dl)
               nk(int(dist/step+0.5)) = nk(int(dist/step+0.5)) + 1 
            enddo
         enddo
      enddo
      
      nbk(0) = 0 
      do i = 0, 2*nside
         nbk(i+1) = nbk(i) + nk(i)
         nk(i) = 0 
      enddo 
      
c     Save coordinates  
      write(*,*) 'Save coordinates'

      m = 0
      do i = 0, nside -1 
         do j = 0, nside -1
            do l = 0, nside -1
               di = float(min(i,nside-i))
               dj = float(min(j,nside-j))
               dl = float(min(l,nside-l))
               dist = sqrt(di*di + dj*dj +dl*dl)
               nk(int(dist/step+0.5)) = nk(int(dist/step+0.5)) + 1  
               n = nbk(int(dist/step+0.5)) + nk(int(dist/step+0.5))
               m = m+ 1
               indx(n) = m 
            enddo 
         enddo 
      enddo 
      
c     calculate k maps 
      write(*,*) 'Calculate k maps'

      ndim=3

      allocate(norm1(2,nsideD),normk(nsideD,nmax))
      do i = ncut/int(step), nmax
         do n = 1, nsideD 
            norm1(1,n) = 0.
            norm1(2,n) = 0.
         enddo 
         do n = nbk(i)+1, nbk(i+1)
            norm1(1,indx(n)) = 1.
         enddo 
c         call cfft_3d('c','c','f',norm1,norm1,nside,nside,nside,nside,
c     $        nside,1,1,1)
      call fftwnd_f77_one(planf,norm1,0)
         do n = 1, nsideD
            normk(n,i) = norm1(1,n)
         enddo
      enddo

      write(*,*) 'Final sum'
      
      do i = ncuts, nmax
         do j = i, nmax
!            do l = j, min(nmax,i+j+1) !do just diag
            do l = j, min(nmax,i+j)
               sumn = 0.d0 
               do n = 1, nsideD
        sumn = sumn + dble(normk(n,i))*dble(normk(n,j))*dble(normk(n,l))
               enddo
               coun(i,j,l)=sumn
c              write(*,*)i,j,l,sumn
            enddo
         enddo 
      enddo          
      
      write(*,*) 'Write output file'

      open(unit=2,status='unknown',file=filecoef,form='unformatted')
      write(2) coun
      close(2)
      
      CALL SYSTEM_CLOCK(clck_count_end, clck_rate) 
      WRITE(*,*) (clck_count_end-clck_count_beg)/REAL(clck_rate)

      stop 
      end 
