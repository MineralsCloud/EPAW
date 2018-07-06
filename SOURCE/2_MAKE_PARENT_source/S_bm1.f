************************************************************************************************************************
        function bm1(idum)
************************************************************************************************************************
        implicit none
        integer idum
        real*4 rand
        double precision bb,ba,bm1,da
        da=1.0d0
        bb=rand(idum)
        if(bb.le.0.0)then
        bb=0.001
        endif
        ba=-4.0d0*da*log(bb)
        bm1=dsqrt(ba)
        return
        end
