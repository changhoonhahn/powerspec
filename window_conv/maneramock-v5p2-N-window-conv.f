        IMPLICIT DOUBLE PRECISION (A-H,O-Z)
        INTEGER wNbin,sNbin
        REAL*8 pi
        PARAMETER(wNbin=120,sNbin=456,pi=3.141592654)
        CHARACTER POWERFILE*200,POWERFNAME*200
        CHARACTER SIMFILE*200,SIMFNAME*200
        CHARACTER OUTFILE*200,OUTFNAME*200
        REAL*8 k,Pg,Pg2,Pg4,Pr,Pr2,Pr4,dk,co,Pc
        REAL*8 k_k,PPg,PPg2,PPg4,PPr,PPr2,PPr4,ddk,cco,PPc
        REAL*8 wk(wNbin),wPr(wNbin),sec1(wNbin),Pconv(wNbin)
        REAL*8 sk(sNbin),sPg(sNbin),sec2(sNbin)
        REAL*8 tol,kk,q1,q2,g1,g2
        REAL*8 ps,pw
        REAL*8 maxwk
        INTEGER*8 i,iwr
        COMMON /interpol1/wk,wPr,sec1
        COMMON /interpol2/sk,sPg,sec2
        COMMON /variables/KK
        COMMON /maxvalue/maxwk
        EXTERNAL ps,pw

!WINDOW POWER
        CALL GETARG(1,POWERFILE)
        OPEN(UNIT=4,FILE=POWERFILE,STATUS='old',FORM='formatted')
        WRITE(*,*) POWERFILE

        DO i=1,wNbin
            read(4,*,END=12) k,Pg,Pg2,Pg4,Pr,Pr2,Pr4,dk,co
            wk(i)=DBLE(k)
            wPr(i)=DBLE(Pr)
        ENDDO
 12     CONTINUE 
        CLOSE(4)
        CALL spline(wk,wPr,wNbin,3e30,3e30,sec1)
        maxwk=MAXVAL(wk)

!SIMULATED POWER
        CALL GETARG(2,SIMFILE)
        OPEN(UNIT=5,FILE=SIMFILE,STATUS='old',FORM='FORMATTED')
        WRITE(*,*) SIMFILE

        DO i=1,sNbin
c            READ(5,*,END=13) k_k,PPg,PPg2,PPg4,PPr,PPr2,PPr4,ddk,cco
            READ(5,*,END=13) k_k,PPg
            sk(i)=DBLE(k_k)
            sPg(i)=DBLE(PPg)
        ENDDO
 13     CONTINUE
        CLOSE(5)
        CALL spline(sk,sPg,sNbin,3e30,3e30,sec2)

        CALL GETARG(3,OUTFILE)
        OPEN(UNIT=7,FILE=OUTFILE,STATUS='unknown',FORM='formatted')
        WRITE(*,*) OUTFILE

        tol=1.d-6
        iwr=0
        q1=DBLE(minval(sk))
        q2=DBLE(maxval(sk))
        DO i=1,sNbin
            KK=sk(i)
            CALL gabqx(ps,q1,q2,Pc,tol,iwr)
            Pconv(i)=2.0d0*DBLE(pi)*Pc
c            WRITE(*,*) KK,Pconv(i)
        WRITE(7,1020) KK,Pconv(i)
        ENDDO
        WRITE(*,*) sPg(1), Pconv(1),sPg(1)/Pconv(1)
        CLOSE(7)
 1020   FORMAT(2x,2e16.6)

        STOP
        END

C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION ps(QQ)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT DOUBLE PRECISION (A-H,O-Z)
        INTEGER wNbin,sNbin,iwr
        PARAMETER(wNbin=120,sNbin=456)
        REAL*8 Q,QQ,psq,KK,tol,x1,x2,pwsum
        REAL*8 sk(sNbin),sPg(sNbin),sec2(sNbin)
        COMMON /variables/KK,Q
        COMMON /interpol2/sk,sPg,sec2
        EXTERNAL pw

        tol=1.d-6
        iwr=0
        Q=QQ
        x1=-1.0d0
        x2=1.0d0
        call splint(sk,sPg,sec2,sNbin,Q,psq)
        call gabqy(pw,x1,x2,pwsum,tol,iwr)
        ps=psq*Q**2*pwsum
        RETURN
        END


C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION pw(GG)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT DOUBLE PRECISION (A-H,O-Z)
        INTEGER wNbin,sNbin
        PARAMETER(wNbin=120,sNbin=456)
        REAL*8 G,GG,Q,KK
        REAL*8 wk(wNbin),wPr(wNbin),sec1(wNbin)
        REAL*8 maxwk
        COMMON /variables/KK,Q
        COMMON /interpol1/wk,wPr,sec1
        COMMON /maxvalue/maxwk

        G=SQRT(KK**2+Q**2-2.0*KK*Q*GG)
        IF (G .GT. maxwk) THEN 
            pw=0.0d0
        ELSE 
            call splint(wk,wPr,sec1,wNbin,G,pw)
        END IF 

        RETURN
        END

        INCLUDE '/home/users/hahn/powercode/integration/gabqx.f'
        INCLUDE '/home/users/hahn/powercode/integration/gabqy.f'
        INCLUDE '/home/users/hahn/powercode/integration/spline_dp.f'
        INCLUDE '/home/users/hahn/powercode/integration/splint_dp.f'
