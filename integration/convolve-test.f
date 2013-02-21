        IMPLICIT DOUBLE PRECISION (A-H,O-Z)
        PARAMETER(pi=3.141592654)
        CHARACTER POWERFILE*200,POWERFNAME*200
        CHARACTER SIMFILE*200,SIMFNAME*200
        CHARACTER OUTFILE*200,OUTFNAME*200
        REAL, ALLOCATABLE :: Pconv(:)
        REAL*8 tol,kk,q1,q2,g1,g2
        INTEGER*8 i,iwr,wNbin
        COMMON /interpol1/wk,wPr,sec1
        COMMON /interpol2/sk,sPg,sec2
        COMMON /variables/KK
        EXTERNAL ps,pw

        CALL GETARG(1,OUTFNAME)
        OPEN(UNIT=6,FILE=OUTFNAME,STATUS='unknown',FORM='formatted')
        tol=1.d-6
        iwr=0
        q1=0.0
        q2=100.0
        wNbin=480
        ALLOCATE(Pconv(wNbin))
        DO i=1,wNbin
            KK=q1+float(i)*200.0/float(wNbin)
            CALL gabqx(ps,q1,q2,Pc,tol,iwr)
            Pconv(i)=2*pi*Pc!/3.937402*2
        WRITE(6,*) KK,Pconv(i),gauss(KK/sqrt(2.0))
        ENDDO
        CLOSE(6)
 1020   FORMAT(2x,3e16.6)

        STOP
        END
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION gauss(XX)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT DOUBLE PRECISION (A-H,O-Z)
        PARAMETER(pi=3.141592654)
        REAL*8 X,XX

        X=XX
        gauss=exp(-X**2)/(sqrt(2*pi))
        RETURN
        END

C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION ps(QQ)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT DOUBLE PRECISION (A-H,O-Z)
        REAL*8 Q,QQ,psq,KK
        COMMON /variables/KK,Q
        EXTERNAL pw,gauss

        tol=1.d-6
        iwr=0
        Q=QQ
        x1=-1.0
        x2=1.0
        psq=gauss(Q)
        call gabqy(pw,x1,x2,pwsum,tol,iwr)
        ps=psq*Q**2*pwsum
        RETURN
        END


C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION pw(GG)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT DOUBLE PRECISION (A-H,O-Z)
        REAL*8 G,GG,Q,KK
        COMMON /variables/KK,Q

        G=SQRT(KK**2+Q**2-2.0*KK*Q*GG)
        pw=gauss(G)
        RETURN
        END

        INCLUDE '/home/users/hahn/powercode/integration/gabqx.f'
        INCLUDE '/home/users/hahn/powercode/integration/gabqy.f'
        INCLUDE '/home/users/hahn/powercode/integration/spline_dp.f'
        INCLUDE '/home/users/hahn/powercode/integration/splint_dp.f'
