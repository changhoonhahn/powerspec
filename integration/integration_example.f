c     one-loop CDM power spectrum
c     calculates also dropping decaying modes contribution "b"
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      IMPLICIT DOUBLE PRECISION (A-H,O-Z) 
      INTEGER ntfmax,ntf,itransfer
      PARAMETER(ntfmax=10000)
      REAL*8 kc
      REAL*8 ktf(ntfmax),tf(ntfmax),tfd(ntfmax),akmin,akmax,dum   
      COMMON /BOUND/ ak,pi
      COMMON /SPEC/ gam,eps,kc,anor,itransfer
      COMMON /kbounds/akmin,akmax
      common /transfer/ktf,tf,tfd,ntf
      EXTERNAL gabqx,powbe,p13,p22,p13b,p22b,p13dv,p22dv,p13vv,p22vv
      character*255 datafile,fileTF
c      real*8 Omega0,OmegaL0
c      real Om0,OL0

      pi=3.141592654
      tpi=2.*pi

C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MAIN  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      write(*,*) 'Enter Omega, Omega_Lambda at z=0:'
      read(*,*) Om0,OL0
      write(*,*)'BBKS (0) or CMBFAST (1) ?'
      read(*,*) itransfer
      if (itransfer.eq.0) then
         write(*,*) 'P(k) Shape Parameter (Gamma for BBKS)?'
         read(*,*) Gam
         akmin=0.150868d-04 !!ktf(1)
         akmax=0.503152d02  !!ktf(ntf)
      else
         write(*,*) 'Transfer Function File'
         read(5,'(a)')fileTF
         open(unit=1,file=fileTF,status='old') ! Read Transfer Function
         ntf=0
         do i=1,ntfmax
            read(1,*,end=13) ktf(i),tf(i),dum,dum,dum
            ntf=ntf+1
         enddo
 13      continue
         call spline(ktf,tf,ntf,3d30,3d30,tfd)
         akmin=ktf(1)
         akmax=ktf(ntf)  
      endif
      write(*,*)'read',ntf,'lines, kmin=',akmin,'kmax=',akmax
      write(*,*) 'Enter sigma_8 at z=0:'
      read(*,*) sigma80
      write(*,*) 'Enter box dimension [comoving Mpc/h] Lbox'
      read(*,*) Rbox
      akfun=tpi/Rbox
      write(*,*) 'Enter redshift'
      read(*,*) z
      a=1.
      call Growth(Om0,OL0,a,Om,OL,D0)
      a=1./(1.+z)
      call Growth(Om0,OL0,a,Om,OL,Da)
      sigma8=sigma80*Da/D0
      write(*,*)'sigma8 is',sigma8
      kc=1.e6 !!
      anor=1.e4
      var8=variance(8.)
      anor=anor*sigma8**2/var8 !normalize to sigma8

      eps=akfun !1.d-3 !
      kc=1.d1

      TOL=1.d-6                                                     
      IWR=0        
      
c      stop
      
      write(*,*) 'output File'
      read(5,'(a)')datafile
      open(unit=8,file=datafile,status='unknown')
      close(unit=8)

      do akexp=-2.d0,0.d0,0.22222222d0
         ak=10.d0**akexp
         eps=ak/20.d0
         kc=ak*20.d0
         p1=4.d0*pi*ak**3 *powbe(ak)
         call GABQX(P22,eps,kc,p22in,tol,iwr) !calculates 2D integral
      enddo
      close(unit=8)
      
1015  format(2x,5f15.8)
1025  format(2x,9e15.5)

      STOP
      END
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL*8 function P22(QQ) !density-density
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      REAL*8 Q,kc 
      INTEGER itransfer
      EXTERNAL G0,powbe
      COMMON /XY/ Q
      Common /bound/ ak,pi
      COMMON /SPEC/ gam,eps,kc,anor,itransfer
      Q=QQ
      X1=max(eps,abs(ak-q))
      X2=min(kc,ak+q)
      tol=1.d-6                                                         
      IWR=0
      if (x2.gt.x1) then
         CALL GABQY(G0,X1,X2,SUM,tol,iwr)
         P22=4.d0*pi*SUM*powbe(Q)*Q
      else
         p22=0.d0
      endif
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      Subroutine Growth(Om0,OL0,a,Om,OL,Dp)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      IMPLICIT DOUBLE PRECISION (A-H,O-Z) 
      OK0=1.-Om0-OL0
      Hsq=Om0/a**3+OK0/a**2+OL0
      Om=Om0/a**3/Hsq
      OL=OL0/Hsq
      Dp=2.5d0*a*Om/(Om**(4.d0/7.d0)-OL+(1.d0+0.5d0*Om)*(1.d0+OL/70.d0))
      Return
      End
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL*8 function G0(pp) !density-density
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)                               
      EXTERNAL powbe
      COMMON /BOUND/ ak,pi
      COMMON /XY/ Q
      p=pp
      cos=(ak**2-q**2-p**2)/(2.d0*p*q)
      f2=5.d0/7.d0+0.5d0*cos*(p/q+q/p)+2.d0/7.d0*cos**2
      G0=p*powbe(p)*f2**2
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL*8 function powbe(QQ)   !linear power spectrum BE
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
c      REAL anor,Gam,QQ,aq,kc
      IMPLICIT DOUBLE PRECISION (A-H,O-Z) 
      INTEGER ntf,itransfer
      REAL*8 QQ,kc
      parameter (ntfmax=10000)
      real*8 ktf(ntfmax),tf(ntfmax),tfd(ntfmax),akmin,akmax
      common /SPEC/ gam,eps,kc,anor,itransfer
      common /transfer/ktf,tf,tfd,ntf
      common /kbounds/akmin,akmax
      external splint
      
      if (itransfer.eq.0) then !BE
         aq=QQ/Gam
         powbe=aq*Gam*anor/(1.+(6.4*aq+2.89*aq**2+5.19615242270
     &     663*aq**(3./2.))**1.13)**1.769911504424779
         if (qq.gt.akmax) then 
            powbe=1.e-10 
         endif
      else
         if (QQ.ge.akmin .and. QQ.le.akmax) then
            call splint(ktf,tf,tfd,ntf,QQ,y)
            powbe=QQ*anor*y*y/tf(1)/tf(1)
         else
            write(*,*)'you are asking k beyond transfer function',qq
            stop
        endif
      endif
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL*8 function variance(QQ)   !linear variance
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^    
      real*8 akmin,akmax,ans,varint,epsabs,epsrel,abserr
      parameter (limit=1000)
      integer neval,ier,iord(limit),last
      real*8 alist(limit),blist(limit),elist(limit),rlist(limit)
      common /varscale/ ar
      common /kbounds/akmin,akmax
      external varint,dqage
      ar=QQ
      epsabs=0.d0
      epsrel=1.d-2    
      call dqage(varint,akmin,akmax,epsabs,epsrel,30,limit,ans,abserr,
     $ neval,ier,alist,blist,rlist,elist,iord,last)
      variance=ans
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL*8 function varint(ak)   !linear variance integrand
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      real*8 ak,ax,wth,pid,powbe
      common /varscale/ ar
      external powbe
      pid=3.141592654d0
      ax=ak*ar
      wth=3.d0/ax**3 *(dsin(ax)-ax*dcos(ax))
      varint= powbe(ak)*4.d0*pid *ak**2*wth**2
      RETURN
      END
c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      include 'dqage.f'
      include 'd1mach.f'
      include 'spline_dp.f'
      include 'splint_dp.f'
      include 'dqawfe.f' 
      include 'gabqx.f'
      include 'gabqy.f'
