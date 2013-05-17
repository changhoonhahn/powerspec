        IMPLICIT NONE
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
        INTEGER*8 i,iwr
        COMMON /interpol1/wk,wPr,sec1
        COMMON /interpol2/sk,sPg,sec2
        EXTERNAL ps,pw

!WINDOW POWER
        CALL GETARG(1,POWERFNAME)
        OPEN(UNIT=4,FILE=POWERFNAME,STATUS='old',FORM='formatted')
        DO i=1,wNbin
            READ(4,*,END=12) k,Pg,Pg2,Pg4,Pr,Pr2,Pr4,dk,co
            wk(i)=k
            wPr(i)=Pr
        ENDDO
 12     CONTINUE
        CLOSE(4)
        CALL spline(wk,wPr,wNbin,3e30,3e30,sec1)

!SIMULATED POWER
        CALL GETARG(2,SIMFNAME)
        OPEN(UNIT=5,FILE=SIMFNAME,STATUS='old',FORM='FORMATTED')

        DO i=1,sNbin
            READ(5,*,END=13) k_k,PPg!,PPg2,PPg4,PPr,PPr2,PPr4,ddk,cco
            sk(i)=k_k
            sPg(i)=PPg
        ENDDO
 13     CONTINUE
        CLOSE(5)
        CALL spline(sk,sPg,sNbin,3e30,3e30,sec2)

        DO i=1,sNbin
            WRITE(*,*) sk(i), ps(sk(i)), sPg(i), pw(sk(i))
        ENDDO

        CALL GETARG(3,OUTFNAME)
        STOP
        END

C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION ps(QQ)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT NONE
        INTEGER sNbin
        PARAMETER(sNbin=456)
        REAL*8 sk(sNbin),sPg(sNbin),sec2(sNbin),QQ,Q
        COMMON /interpol2/sk,sPg,sec2
        Q=QQ
        call splint(sk,sPg,sec2,sNbin,Q,ps)
        
        RETURN
        END

C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION pw(GG)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT NONE 
        INTEGER wNbin
        PARAMETER(wNbin=120)
        REAL*8 G,GG,wk(wNbin),wPr(wNbin),sec1(wNbin)
        COMMON /interpol1/wk,wPr,sec1
        G=GG
        call splint(wk,wPr,sec1,wNbin,G,pw)

        RETURN
        END

        INCLUDE '/home/users/hahn/powercode/integration/gabqx.f'
        INCLUDE '/home/users/hahn/powercode/integration/gabqy.f'
        INCLUDE '/home/users/hahn/powercode/integration/spline_dp.f'
        INCLUDE '/home/users/hahn/powercode/integration/splint_dp.f'
