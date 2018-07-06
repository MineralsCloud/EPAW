*================ SINGLE INTEGER RANDOM NUMBER GENERATOR =================
*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*| S 11A |*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
*=========================================================================
      SUBROUTINE SIRAND(iulimit,illimit,inr)
      implicit none
      integer idum,inr,illimit,iulimit
      double precision r
      real*4 rand
      common/ide/idum
      r=rand(idum)
    5 inr=(iulimit-illimit+1)*r+illimit
      if (inr.gt.iulimit)then
      goto 5
      endif
      return
      end