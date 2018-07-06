*==================== FLIP A COIN WITH A PROBABILITY =====================
*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*| F 1F *|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
*=========================================================================
      function iflip(prob)
      implicit none
      integer idum,iflip
      real*4 rand
      double precision prob
      common/ide/idum
      iflip = 0
      if ((prob.eq.1.0).or.(rand(idum).le.prob)) iflip = 1
      return
      end