c  ifort -O4 -o 2.exe bisp_fast_bin_fftw2.f -L/usr/local/fftw_intel_s/lib -lsrfftw -lsfftw
      include '/usr/local/src/fftw-2.1.5/fortran/fftw_f77.i'
      integer nside,nsideD,Dim,nn(3),nmax,ncheck,istep
      integer*8 planb,planf
c* INPUT (Check) ************************************************************
c      parameter(nside=180,nmax=30)
c      parameter(nside=240,nmax=80)
      parameter(nside=360,nmax=40)
c      parameter(nside=480,nmax=53)
c****************************************************************************
      parameter(Dim=3,nsideD=nside**Dim) 
      data nn/nside,nside,nside/
      integer i, j, l, m, n, nk(0:2*nside), nbk(0:2*nside+1)
      integer iseed, indx(nsideD), id, jd, ld, nmodes, ndim,k,ix,iy,iz
c      real mapk(nsideD,nmax),m1(2,nsideD), map1(nsideD), map2(nsideD)  
      real pow(nmax),I10,I12,I22,I13,I23,I33,P0,alpha
      real, allocatable :: mapk(:,:),m1(:,:),map1(:),map2(:)
c      real normk(nsideD,nmax), norm1(2,nsideD)
      real di, dj, dl, eightpi2, bi, step
      real dist, bisp(nmax,nmax,nmax), q(nmax,nmax,nmax)
      real*8 coun(nmax,nmax,nmax), avg, sum
      real rand,fac,Fr,Fi,Pt,Rr,Ri
      complex, allocatable :: dclr1(:,:,:),dclr2(:,:,:)
      integer nobj,ip,aexp,p,dpnp1,dpn,ibuf,lm,mcode,Ncut,ng
      integer clck_count_beg,clck_count_end,clck_rate
      character*255 filebisp, filecoef,filecounts,file1,file2,homedir
      character*255 iflagstr
      common/discrete/I10,I12,I22,I13,I23,I33,P0,alpha
    
c* INPUT (Check) ************************************************************
c      filecounts='~/Code/Fortran/counts2_n180_nmax30_ncut2_s2.be'
      homedir='/home/users/hahn/powercode/bispectrum/'
      file1='counts2_n360_nmax40_ncut3_s3'
c      file1='counts2_n480_nmax53_ncut3_s3'
c      file1='counts2_n240_nmax80_ncut2_s1'
      filecounts=homedir(1:len_trim(homedir))//file1(1:len_trim(file1))
      Ncut=3
      istep=3
c****************************************************************************
      CALL SYSTEM_CLOCK(clck_count_beg,clck_rate)
      
      
      call fftw3d_f77_create_plan(planf,nside,nside,nside,
     $ FFTW_FORWARD,FFTW_ESTIMATE+FFTW_IN_PLACE)

      step=real(istep)
      eightpi2 = 78.95683521
     
      allocate(map1(nside**Dim),map2(nside**Dim))

c      write(*,*) 'Nbody (1) or data (2)?'
      call getarg(1,iflagstr)
      read(iflagstr,*) iflag
c      iflag=1

      if (iflag.eq.1) then

         write(*,*) 'Fourier file :'
         read(*,'(a)') filecoef
         write(*,*) 'Bispectrum file :'
         read(*,'(a)') filebisp

         allocate(dclr1(nside/2+1,nside,nside))
         call inputNB(nside,Dim,filecoef,map1,map2,dclr1)
         deallocate(dclr1)

      elseif (iflag.eq.2) then

c         write(*,*) 'Random Fourier file :'
         call getarg(2,file1)
c         read(*,'(a)') file1
c         write(*,*) 'Data Fourier file :'
         call getarg(3,file2)
c         read(*,'(a)') file2
c         write(*,*) 'Bispectrum file :'
         call getarg(4,filebisp)
c         read(*,'(a)') filebisp         

         allocate(dclr1(nside/2+1,nside,nside))
         allocate(dclr2(nside/2+1,nside,nside))
         call inputDA(nside,Dim,file1,file2,map1,map2,dclr1,dclr2)
         deallocate(dclr1)
         deallocate(dclr2)

      endif

      do l=1,nmax
         do j=1,nmax
            do i=1,nmax
               bisp(i,j,l) = 0.
            enddo
         enddo
      enddo
      
      do i=0,2*nside
         nk(i)=0
      enddo

c      write(*,*) 'Find modes of amplitude |k|'

      do i = 0, nside -1
         do j = 0, nside  -1
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
      
c      write(*,*) 'Save coordinates'
  
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

      write(*,*) 'Calculate k maps'

      ndim=3

      allocate(m1(2,nsideD),mapk(nsideD,nmax))
      do i = ncut/int(step), nmax
         do n = 1, nsideD 
            m1(1,n) = 0.
            m1(2,n) = 0.
         enddo 
         nmodes = 0
         do n = nbk(i)+1, nbk(i+1)
            m1(1,indx(n)) = map1(indx(n))
            m1(2,indx(n)) = map2(indx(n))
            nmodes =nmodes +1 
         enddo 
c         call cfft_3d('c','c','f',m1,m1,nside,nside,nside,nside,nside,
c     $        1,1,1)
         call fftwnd_f77_one(planf,m1,0)
         avg = 0.d0 
         do n = 1, nsideD
            avg = avg + dble(m1(1,n))*dble(m1(1,n))
            mapk(n,i) = m1(1,n)
         enddo
         pow(i)=real(avg)/float(nsided)/float(nmodes)
         if (iflag.eq.2) then 
            pow(i)=(pow(i)-(1.+alpha)*I12)/I22 !correct discreteness
         endif
      enddo

      write(*,*) 'Read counts'

      open(unit=2,status='old',form='unformatted',file=filecounts)
      read(2) coun
      close(2)

      write(*,*) 'counts were read'

      do i = ncut/int(step), nmax
         do j = i, nmax
            do l = j, min(nmax,i+j)
                  sum = 0.d0 
                  do n = 1, nsideD
         sum = sum + dble(mapk(n,i))*dble(mapk(n,j))*dble(mapk(n,l))
                  enddo
                  bi=real(sum/coun(i,j,l))
                  if (iflag.eq.2) then
             bi=(bi-(pow(i)+pow(j)+pow(l))*I23-(1.-alpha**2)*I13)/I33
                  endif
                  bisp(i,j,l) = bi
                  q(i,j,l)=bi/(pow(i)*pow(j)+pow(j)*pow(l)
     $                 +pow(l)*pow(i))
            enddo
         enddo 
      enddo          

      write(*,*) 'Last sum'

      open(unit=7,file=filebisp,status='unknown',form='formatted')
c      open(unit=7,file=filebisp,status='unknown')
c      write(*,*) 'open'
      do l = ncut/int(step), nmax
         do j = ncut/int(step), l
            do i = ncut/int(step),j
               fac=1.
               if(coun(i,j,l).ne.0.d0) then 
                  if(j.eq.l .and. i.eq.j) fac=6.
                  if(i.eq.j .and. j.ne.l) fac=2.
                  if(i.eq.l .and. l.ne.j) fac=2.
                  if(j.eq.l .and. l.ne.i) fac=2.
                  coun(i,j,l)=coun(i,j,l)/dble(fac*float(nsided))
                  write(7,1000) int(step)*l,int(step)*j,int(step)*i,
     $                 pow(l),pow(j),pow(i),bisp(i,j,l),q(i,j,l),
     $                 real(coun(i,j,l))
               endif
            enddo
         enddo
      enddo 
c      write(*,*) 'wrote'
      close(7)
c      write(*,*) 'closed'

      CALL SYSTEM_CLOCK(clck_count_end,clck_rate)
      WRITE(*,*) (clck_count_end-clck_count_beg)/REAL(clck_rate)

 1000 format(3I4, 6e13.5)
 2000 stop 
      end 


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine inputNB(nside,Dim,filecoef,map1,map2,dclr1)

      integer nside,Dim,n,i,j,l,id,jd,ld,Lx,Ly,Lz,Npar
      real akx,aky,akz,phys_nyq
      real map1(nside**Dim), map2(nside**Dim) 
      complex dclr1(nside/2+1,nside,nside)
      character*255 filecoef

      open(unit=1,status='old',file=filecoef,form='unformatted')
      read(1) Lx,Ly,Lz,Npar,akx,aky,akz,phys_nyq
      read(1)(((dclr1(i,j,l),i=1,Lx/2+1),j=1,Ly),l=1,Lz) 
      close(1)

      n = 0 
      do i = 1, nside 
         do j = 1, nside 
            do l = 1, nside 
               n = n+1
               if (i .le. nside/2+1) then 
                  map1(n) = real(dclr1(i,j,l))
                  map2(n) = aimag(dclr1(i,j,l))
               else 
                  id = mod(nside-i+1,nside)+1
                  jd = mod(nside-j+1,nside)+1
                  ld = mod(nside-l+1,nside)+1
                  map1(n) = real(dclr1(id,jd,ld))
                  map2(n) = -aimag(dclr1(id,jd,ld))
               endif
               if (mod(i-1,nside/2)+mod(j-1,nside/2)+
     $              mod(l-1,nside/2).eq.0) then
                  map2(n) = 0.
               endif  
            enddo
         enddo 
      enddo
c      map2(1)=0.
      return
      end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      subroutine inputDA(nside,Dim,file1,file2,map1,map2,dclr1,dclr2)

      integer nside,Dim,n,i,j,l,id,jd,ld,Lx,Ly,Lz,Nr,Ng
      real akx,aky,akz,phys_nyq,I10,I12,I22,I13,I23,I33,P0,alpha,Ngsys
      real map1(nside**Dim), map2(nside**Dim) 
      complex dclr1(nside/2+1,nside,nside),dclr2(nside/2+1,nside,nside)
      character*255 filecoef
      common/discrete/I10,I12,I22,I13,I23,I33,P0,alpha

      open(unit=1,status='old',file=file1,form='unformatted')
      read(1)dclr1
      read(1)I10,I12,I22,I13,I23,I33
      read(1)P0,Nr
      close(1)

      open(unit=1,status='old',file=file2,form='unformatted')
      read(1)dclr2
      read(1)P0,Ng,Ngsys
      close(1)
      
c      alpha=float(Ng)/float(Nr) !now scale random integrals by alpha
      alpha=Ngsys/float(Nr) !now scale random integrals by alpha
      I10=I10*alpha
      I12=I12*alpha
      I22=I22*alpha
      I13=I13*alpha
      I23=I23*alpha
      I33=I33*alpha

      do l=1,nside
         do j=1,nside
            do i=1,nside/2+1
               dclr1(i,j,l)=dclr2(i,j,l)-alpha*dclr1(i,j,l)
            enddo
         enddo
      enddo

      n = 0 
      do i = 1, nside 
         do j = 1, nside 
            do l = 1, nside 
               n = n+1
               if (i .le. nside/2+1) then 
                  map1(n) = real(dclr1(i,j,l))
                  map2(n) = aimag(dclr1(i,j,l))
               else 
                  id = mod(nside-i+1,nside)+1
                  jd = mod(nside-j+1,nside)+1
                  ld = mod(nside-l+1,nside)+1
                  map1(n) = real(dclr1(id,jd,ld))
                  map2(n) = -aimag(dclr1(id,jd,ld))
               endif
               if (mod(i-1,nside/2)+mod(j-1,nside/2)+
     $              mod(l-1,nside/2).eq.0) then
                  map2(n) = 0.
               endif  
            enddo
         enddo 
      enddo
c      map2(1)=0.
      return
      end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
