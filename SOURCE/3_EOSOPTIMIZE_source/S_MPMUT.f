*========================= MULTI-POINT MUTATION ==========================
*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*| S 7A *|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
*=========================================================================
      SUBROUTINE MPMUT(npop,nop,amprob,amint,pool)
      implicit none
      integer idum,iflip,iop,nop,ipop,npop,iarn
      real*4 rand
      double precision bm,amprob,y,amint,term,pool(npop,nop)
      common/ide/idum
      do ipop=1,npop
       do iop=1,nop
        if(iflip(amprob) .eq. 1) then
!          write(*,*)'iflip(amprob) .eq. 1',ipop,iop
c          iarn=idirctn(prob)
          y=rand(idum)
          if( y .gt. 0.50d0)then
           iarn=-1
          else
           iarn=1
          endif
          y=bm(idum)
!          y=rand(idum)
          term=iarn*amint*y
!          write(*,*)term
          pool(ipop,iop)=pool(ipop,iop)+term
        endif
       enddo
!       write(*,*)
      enddo
      return
      end