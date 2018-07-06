!===========================  INTGPAW   U9 =============================
      subroutine C_SIMPS(n,x,y,area)!                                 >>
      IMPLICIT NONE!                                                  >>
      INTEGER i,n!                                                    >>
      DOUBLE PRECISION t1,t2,t3,t4,h,x(n),y(n),area!                  >>
!=======================================================================
      h=(x(n)-x(1))/dfloat(n)
      t1=y(1)
      t4=y(n)
      t2=0.0d0
      t3=0.0d0
      do i=2,n-2,2
        t2=t2+4.0d0*y(i)
      enddo
      do i=3,n-1,2
        t3=t3+2.0d0*y(i)
      enddo
      area=t1+t2+t3+t4
      area=area*(h/3.0)
      return
      end
