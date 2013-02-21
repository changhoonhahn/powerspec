      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      REAL*8 tol,QQ,f,SUM, int
      REAL*8 x, x1, x2, Z
      INTEGER*8 iwr
!      COMMON /XY/ Q

      COMMON Z
      EXTERNAL g,f,GABQX

      tol=1.d-6
      iwr=0

      x1=0.0
      x2=1.0

      z=1.0
      call gabqx(f,x1,x2,sum,tol,iwr)

      write(*,*) sum
      STOP
      END

C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL*8 function f(xx)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      REAL*8 P,x,xx,gint,tol
      REAL*8 y1, y2, Z
      INTEGER*8 iwr
!      COMMON /XY/ Q
      COMMON Z,x
      EXTERNAL g, gabqy
      x=xx
    
      tol=1.d-6
      iwr=0
      y1=0.0
      y2=1.0
      call gabqy(g,y1,y2,gint,tol,iwr)
      f=gint
!      write(*,*) 'f=',f 
      RETURN 
      END
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      REAL*8 function g(yy)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      REAL*8 yy,y,x,Z
!      COMMON /XY/ Q
      COMMON x,Z
      y=yy

      g=(x+y+z)**3

      RETURN
      END

      include 'gabqx.f'
      include 'gabqy.f'
