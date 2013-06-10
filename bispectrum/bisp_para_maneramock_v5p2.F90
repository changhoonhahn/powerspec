! ifort -O4 -openmp -o bisp_bin_OMP.exe bisp_bin_OMP.F90 -L/usr/local/fftw_intel_s/lib -lsrfftw -lsfftw
module common_mod 
implicit none 

integer,parameter :: nside=360
integer :: nmax=40
integer :: Ncut =3 
integer :: istep =3 
integer :: n_thread = 5  !nsideD must be divisible by n_thread  
character(len=255) :: filecounts='/home/users/rs123/Code/Fortran/counts2_n480_nmax80_ncut2_s2'

integer, parameter :: Dim=3
integer :: nsideD  =  nside**Dim  

real :: I10,I12,I22,I13,I23,I33,P0,alpha
contains 

subroutine inputNB(filecoef,map1,map2,dclr1)

integer :: n,i,j,l,id,jd,ld,Lx,Ly,Lz,Npar,ioerror 
real :: akx,aky,akz  ,phys_nyq
real,dimension(nsideD) :: map1 , map2        
complex,dimension(nside/2+1,nside,nside):: dclr1     
character(len=255) :: filecoef

open(unit=146,status='old',file=filecoef,form='unformatted')
read(146) Lx,Ly,Lz,Npar,akx,aky,akz,phys_nyq
read(146,iostat=ioerror)(((dclr1(i,j,l),i=1,Lx/2+1),j=1,Ly),l=1,Lz) 
close(146)

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
         end if
         if (mod(i-1,nside/2)+mod(j-1,nside/2)+ mod(l-1,nside/2).eq.0) then
            map2(n) = 0.
         end if
      end do
   end do
end do

end subroutine inputNB

subroutine inputDA(file1,file2,map1,map2,dclr1,dclr2)

integer ::n,i,j,l,id,jd,ld,Nr,Ng
!real :: akx,aky,akz  !,phys_nyq 
real Ngsys
real,dimension(nsideD) ::  map1 , map2
complex,dimension(nside/2+1,nside,nside) :: dclr1, dclr2
character(len=255) ::  file1, file2  

open(unit=1,status='old',file=file1,form='unformatted')
read(1)dclr1
read(1)I10,I12,I22,I13,I23,I33
read(1)P0,Nr
close(1)

open(unit=1,status='old',file=file2,form='unformatted')
read(1)dclr2
read(1)P0,Ng,Ngsys
close(1)
      
!alpha=float(Ng)/float(Nr) !now scale random integrals by alpha
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
      end do
   end do
end do

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
         end if
         if (mod(i-1,nside/2)+mod(j-1,nside/2)+ mod(l-1,nside/2).eq.0) then
            map2(n) = 0.
         end if
      end do
   end do
end do

end subroutine inputDA

end module common_mod

program bisp_calculator
use common_mod  
implicit none 

#include '/usr/local/src/fftw-2.1.5/fortran/fftw_f77.i'

integer, dimension(3) :: nn 
integer*8 :: planf
integer :: i, j, l, m, n,  iflag 
integer, dimension(:),allocatable :: nk , nbk           
integer  ::  nmodes, ndim  !,ix,iy,iz
integer, dimension(:), allocatable :: indx 
real, dimension(:), allocatable :: pow , map1 , map2
real, dimension(:,:), allocatable :: m1
real, dimension(:,:,:), allocatable :: mapk 
real :: di, dj, dl, eightpi2, bi, step ,dist , fac
real,dimension(:,:,:),allocatable ::  bisp , q 
real,dimension(:,:,:,:),allocatable ::  bis 
real(8),dimension(:,:,:), allocatable ::  coun
real(8) ::  avg, sum
complex, dimension(:,:,:), allocatable :: dclr1 , dclr2        
integer :: bisp_num 
integer :: clck_count_beg,clck_count_end,clck_rate
character(len=255):: filebisp,filecoef,file1,file2,iflagstr

!CALL SYSTEM_CLOCK(clck_count_beg,clck_rate)

nn = nside  
allocate(nk(0:2*nside ), nbk(0:2*nside+1  ) ) 
allocate(indx(nsideD), pow(nmax) )
allocate( bisp(nmax,nmax,nmax), q(nmax,nmax,nmax) )
allocate(  coun(nmax,nmax,nmax) )
allocate(map1(nside**Dim),map2(nside**Dim))

call OMP_set_num_threads(n_thread)

call fftw3d_f77_create_plan(planf,nside,nside,nside,    &
     FFTW_FORWARD,FFTW_ESTIMATE+FFTW_IN_PLACE)

step=real(istep)
eightpi2 = 78.95683521
     


!write(*,*) 'Nbody (1) or data (2)?'
CALL GETARG(1,iflagstr)
READ(iflagstr,*) iflag
!read(*,*)iflag

if (iflag.eq.1) then

   write(*,*) 'Fourier file :'
   read(*,'(a)') filecoef
   write(*,*) 'Bispectrum file :'
   read(*,'(a)') filebisp

   allocate(dclr1(nside/2+1,nside,nside))
   call inputNB(filecoef,map1,map2,dclr1)
   deallocate(dclr1)

else if (iflag.eq.2) then

!   write(*,*) 'Random Fourier file :'
!   read(*,'(a)') file1
   CALL getarg(2,file1)
!   write(*,*) 'Data Fourier file :'
   CALL GETARG(3,file2)
!   read(*,'(a)') file2
!   write(*,*) 'Bispectrum file :'
   CALL GETARG(4,filebisp)
!   read(*,'(a)') filebisp         

   allocate(dclr1(nside/2+1,nside,nside))
   allocate(dclr2(nside/2+1,nside,nside))
   call inputDA(file1,file2,map1,map2,dclr1,dclr2)
   deallocate(dclr1)
   deallocate(dclr2)
   
end if

do l=1,nmax
   do j=1,nmax
      do i=1,nmax
         bisp(i,j,l) = 0.
      end do
   end do
end do
      
do i=0,2*nside
   nk(i)=0
end do

write(*,*) 'Find modes of amplitude |k|'
! find out the number of modes in each bin, nk, i.e. to have the 
! onion structure in Fourier space 
do i = 0, nside -1
   do j = 0, nside  -1
      do l = 0, nside  -1
         di = float(min(i,nside-i))
         dj = float(min(j,nside-j))
         dl = float(min(l,nside-l))
         dist = sqrt(di*di + dj*dj +dl*dl)
         nk(int(dist/step+0.5)) = nk(int(dist/step+0.5)) + 1 
      end do
   end do
end do
      
nbk(0) = 0 
do i = 0, 2*nside
   nbk(i+1) = nbk(i) + nk(i)
   nk(i) = 0 
end do
      
write(*,*) 'Save coordinates'
! to find out the mapping between the index of the array, m, and
! the index of the onion structure, n. So we have the coordinates 
! of the modes in the onion structure                    
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
      end do
   end do
end do
deallocate(nk)

write(*,*) 'Calculate k maps'
! calculate delta_{k}(x) using only the modes in the bin [k]
ndim=3

allocate(m1(2,nsideD),mapk(nsideD/n_thread,nmax,n_thread)) !each thread does one section in space
do i = ncut/int(step), nmax
   do n = 1, nsideD 
      m1(1,n) = 0.
      m1(2,n) = 0.
   end do
   nmodes = 0
   do n = nbk(i)+1, nbk(i+1)
      m1(1,indx(n)) = map1(indx(n))
      m1(2,indx(n)) = map2(indx(n))
      nmodes =nmodes +1 
   end do

   call fftwnd_f77_one(planf,m1,0)
   avg = 0.d0 
   n=0
   do j = 1, n_thread
      do m = 1, nsideD/n_thread
         n=n+1
         avg = avg + dble(m1(1,n))*dble(m1(1,n))
         mapk(m,i,j) = m1(1,n)
      enddo
   enddo
   pow(i)=real(avg)/float(nsided)/float(nmodes)
   if (iflag.eq.2) then 
      pow(i)=(pow(i)-(1.+alpha)*I12)/I22 !correct discreteness
   end if
end do
deallocate(m1,indx,nbk,map1,map2)

write(*,*) 'Read counts'
open(unit=2,status='old',form='unformatted',file=filecounts)
read(2) coun
close(2)


write(*,*) " calculate the bispectrum (with OpenMP) " 
allocate(bis(nmax,nmax,nmax,n_thread))
!$OMP parallel do schedule(static,1) private(sum)
do m = 1, n_thread
do i = ncut/int(step), nmax
   do j = i, nmax
      do l = j, min(nmax,i+j)
         sum = 0.d0 
         do n = 1, nsideD/n_thread
      sum = sum + dble(mapk(n,i,m))*dble(mapk(n,j,m))*dble(mapk(n,l,m))
         enddo
         bis(i,j,l,m)=real(sum/coun(i,j,l))
      end do
   end do
end do
end do
!$OMP end parallel do 
deallocate(mapk)

do i = ncut/int(step), nmax
   do j = i, nmax
      do l = j, min(nmax,i+j)
         bi=0.
         do m = 1, n_thread
            bi = bi+bis(i,j,l,m)
         enddo
         if (iflag.eq.2) then
            bi=(bi-(pow(i)+pow(j)+pow(l))*I23-(1.-alpha**2)*I13)/I33
         endif
         bisp(i,j,l) = bi
         q(i,j,l)=bi/(pow(i)*pow(j)+pow(j)*pow(l)+pow(l)*pow(i))
      enddo
   enddo 
enddo         
deallocate(bis)


! note that the power spectrum and bispectrum are the P-hat and 
! B-hat, which are dimensionless. 


write(*,*) "Outputing file"
open(unit=7,file=filebisp,status='unknown',form='formatted')

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
            write(7,1000)int(step)*l, int(step)*j, int(step)*i,	&
            pow(l),pow(j),pow(i),bisp(i,j,l),q(i,j,l), real(coun(i,j,l))
         end if
      end do
   end do
end do

close(7)

!CALL SYSTEM_CLOCK(clck_count_end,clck_rate)
!WRITE(*,*) (clck_count_end-clck_count_beg)/REAL(clck_rate)

1000 format(3I4, 6e13.5)

end program bisp_calculator


