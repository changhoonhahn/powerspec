      implicit none 
      character a*200,arg*200,arrg*200
      character hello*200,world*200
      real num

      call getarg(1,arg)
      call getarg(2,arrg)
      
      read(arrg,*) num
      write(*,*) "world"//"hello"//"what"
      write(*,*) num*2.0
      end

