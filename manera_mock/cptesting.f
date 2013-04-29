        IMPLICIT NONE
        INTEGER Nmax,i,j
        PARAMETER(Nmax=10)
        REAL ran1, ran2
        
        j=1
        CALL RANDOM_SEED
        DO i=1,Nmax
            WRITE(*,*) "i=",i,"j=",j
            j=j+1
            CALL RANDOM_NUMBER(ran1)
            CALL RANDOM_NUMBER(ran2)
            ran2=0.43+ran2*0.27
            WRITE(*,*) "Ran1=",ran1,"Ran2=",ran2

            DO WHILE (ran2 .lt. ran1)
                CALL RANDOM_NUMBER(ran1)
                CALL RANDOM_NUMBER(ran2)
                ran2=0.43+ran2*0.27
            ENDDO
            WRITE(*,*) "Ran1=",ran1,"<Ran2=",ran2
        ENDDO
        STOP
        END

