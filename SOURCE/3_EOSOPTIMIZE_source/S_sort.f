!----------------------------- SORTARAY -------------------------------|7
! SORTARAY sorts an array (pool of solution strings) according to      |
! fitness in ascending order                                           |
!----------------------------------------------------------------------|
!   VARIABLES/  |                      DESCRIPTION OF                  |
!   PARAMETERS  |                   VARIABLES/PARAMETERS               |
!......................................................................|
! n2pop         : 2*Cardinality (npop) of the mating pool.             |   
! nop           : Dimension of each solution string.                   |   
! idmn          : Reduced dimension of pool to sort.                   |   
! dfit          : fitness of the solution strings in pool.             |   
! pool          : contains the solution strings                        |   
!......................................................................|
      SUBROUTINE SORTARAY(idmn,nop,dfit,pool,ipid)
      implicit none
      integer i,j,idmn,nop,indx(idmn),nt,ipid
      double precision dfit(idmn),t,pool(idmn,nop),tarchv(idmn,nop)
      do i=1,idmn
       indx(i)=i
      enddo
      do i=1,idmn-1
        do j=i+1,idmn
           if (dfit(i).gt.dfit(j))then
              t=dfit(i)
              nt=indx(i)
              dfit(i)=dfit(j)
              indx(i)=indx(j)
              dfit(j)=t
              indx(j)=nt
           endif
         enddo
      enddo
      do i=1,idmn
        do j=1,nop
          tarchv(i,j)=pool(indx(i),j)
        enddo
      enddo
      do i=1,idmn
        do j=1,nop
          pool(i,j)=tarchv(i,j)
        enddo
      enddo
      ipid=indx(1)
      return
      end