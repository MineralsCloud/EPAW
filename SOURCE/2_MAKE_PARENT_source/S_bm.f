*============================== BOX-MULLER ===============================
*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*| F 1F *|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
*=========================================================================
        function BM(idum)
        implicit none
        integer idum,igen
        real*4 rand
        double precision bb,ba,bm,da
c        common/gen/igen
c        if(igen.lt.30000)da=1.0d0
c        if(igen.gt.30000)da=10.0d0
c        if(igen.gt.60000)da=100.0d0
        da=10.0d0
        bb=rand(idum)
        if(bb.le.0.0)then
        bb=0.001
        endif
        ba=-4.0d0*da*log(bb)
        BM=dsqrt(ba)
        return
        end