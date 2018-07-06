      IMPLICIT NONE
      INTEGER ipop,npop
      DOUBLE PRECISION RUN,SYSTEM!                                    ||
      CHARACTER*256 cna,cnb!                                           ||
      npop=10
      do ipop=1,npop
        if(ipop.lt.10)then
          write(cna,FMT="(I1)")ipop
        elseif(ipop.lt.100)then
          write(cna,FMT="(I2)")ipop
        endif
        cnb='pot'//trim(cna)//'/Li2O.out'
           call getVolvsEngfromabinit(ipop,cnb)
        
      enddo
      stop
      end
