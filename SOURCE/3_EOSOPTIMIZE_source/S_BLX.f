*======================== BLX-ALPHA CROSSOVER ============================
*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*| S 6C *|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
*=========================================================================
      SUBROUTINE BLXCROSS(nop,alpha,prnt)
      implicit none
      integer idum,iop,nop
      double precision alpha,ub,alb,ai,allb,uub
      double precision prnt(2,nop),tmp(2,nop)
      real*4 rand
      common/ide/idum
*_________________________________________________________________________
         do iop=1,nop
          if(prnt(1,iop).gt.prnt(2,iop))then
            ub=prnt(1,iop)
            alb=prnt(2,iop)
          else
            alb=prnt(1,iop)
            ub=prnt(2,iop)
          endif
          ai=ub-alb
          allb=alb-alpha*ai
          uub=ub+alpha*ai
          tmp(1,iop)=allb+rand(idum)*(uub-allb)
          tmp(2,iop)=allb+rand(idum)*(uub-allb)
         enddo
         do iop=1,nop
          prnt(1,iop)=tmp(1,iop)
          prnt(2,iop)=tmp(2,iop)
         enddo
!            write(*,*)'##############################'
      return
      end