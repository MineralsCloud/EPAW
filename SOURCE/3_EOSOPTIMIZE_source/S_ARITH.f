*================= SINGLE-POINT ARITHMATIC CROSSOVER======================
*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*| S 6A *|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
*=========================================================================
      SUBROUTINE SPACROSS(nop,fc,prnt)
      implicit none
      integer i,iop,idum,nop,istl1,istl2,iend1,iend2,lr,lr1
      double precision fc,prnt(2,nop),tmp(2,nop)
      real*4 rand
      common/ide/idum
      call SIRAND(nop,1,lr)
      call SIRAND(1,0,lr1)
      if (lr1.eq.0)then
        istl1=lr
        iend1=nop
        istl2=1
        iend2=lr-1
        if(iend2.lt.1)iend2=1
      else
        istl1=1
        iend1=lr
        istl2=lr+1
        iend2=nop
        if(istl2.gt.nop)istl2=nop
      endif
      do i=istl1,iend1
       tmp(1,i)=fc*prnt(1,i)+(1-fc)*prnt(2,i)
       tmp(2,i)=fc*prnt(2,i)+(1-fc)*prnt(1,i)
      enddo
      do i=istl2,iend2
       tmp(1,i)=prnt(1,i)
       tmp(2,i)=prnt(2,i)
      enddo
      do iop=1,nop
        prnt(1,iop)=tmp(1,iop)
        prnt(2,iop)=tmp(2,iop)
      enddo
      return
      end