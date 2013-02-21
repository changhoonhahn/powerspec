        IMPLICIT NONE
        INTEGER wNbin,sNbin
        REAL*8 pi
        PARAMETER(wNbin=480,sNbin=120,pi=3.141592654)
        CHARACTER POWERFILE*200,POWERFNAME*200
        CHARACTER SIMFILE*200,SIMFNAME*200
        CHARACTER OUTFILE*200,OUTFNAME*200
        REAL*8 k,Pg,Pg2,Pg4,Pr,Pr2,Pr4,dk,co,Pc
        REAL*8 k_k,PPg,PPg2,PPg4,PPr,PPr2,PPr4,ddk,cco,PPc
        REAL*8 wk(wNbin),wPr(wNbin),sec1(wNbin),Pconv(wNbin)
        REAL*8 sk(sNbin),sPg(sNbin),sec2(sNbin)
        REAL*8 tol,kk,q1,q2,g1,g2
        REAL*8 ps
        INTEGER*8 i,iwr
        COMMON /interpol1/wk,wPr,sec1
        COMMON /interpol2/sk,sPg,sec2
        COMMON /variables/KK
        EXTERNAL ps

!WINDOW POWER
        CALL GETARG(1,POWERFNAME)

!SIMULATED POWER
        CALL GETARG(2,SIMFNAME)
        SIMFILE='/mount/chichipio2/hahn/power/'//SIMFNAME
        OPEN(UNIT=5,FILE=SIMFILE,STATUS='old',FORM='FORMATTED')

        DO i=1,sNbin
            READ(5,*,END=13) k_k,PPg,PPg2,PPg4,PPr,PPr2,PPr4,ddk,cco
            sk(i)=k_k
            sPg(i)=PPg
        ENDDO
 13     CONTINUE
        CLOSE(5)
        CALL spline(sPg,sk,sNbin,3e30,3e30,sec2)

        DO i=1,sNbin
            WRITE(*,*) sk(i), ps(sk(i)), sPg(i)
        ENDDO

        CALL GETARG(3,OUTFNAME)
        STOP
        END



C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        REAL*8 FUNCTION ps(QQ)
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        IMPLICIT NONE
        INTEGER sNbin
        PARAMETER(sNbin=120)
        REAL*8 sk(sNbin),sPg(sNbin),sec2(sNbin),QQ,Q,self
        COMMON /interpol2/sk,sPg,sec2
        Q=QQ
        call splint(sk,sPg,sec2,sNbin,Q,self)
        ps=self
        RETURN
        END



        INCLUDE '/home/users/hahn/powercode/integration/gabqx.f'
        INCLUDE '/home/users/hahn/powercode/integration/gabqy.f'
        INCLUDE '/home/users/hahn/powercode/integration/spline_dp.f'
        INCLUDE '/home/users/hahn/powercode/integration/splint_dp.f'
