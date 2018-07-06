!______________________________________________________________________
!   |   TOURNMNT construct mating pool from the archive            |
!___|______________________________________________________________|___
!   VARIABLES/  |                    DESCRIPTION OF                |   
!   CONSTRAINTS |                VARIABLES/CONSTRAINTS             |   
!_______________|__________________________________________________|___
! n2pop         I 2*Cardinality (npop) of the mating pool.         |   
! nop           I Dimension of each solution string.               |   
! idmn          I Reduced dimension of pool to sort.               |   
! dfit          I fitness of the solution strings in pool.         |   
! pool          I contains the solution strings                    |   
!_______________|__________________________________________________|___
      SUBROUTINE TOURNMNT(ntr,npop,fit,iselect)
      implicit none
      integer i,j,idum,item,ipk(ntr),ntr,npop,ISEED,iselect(npop)
      double precision fit(npop)
      real*4 rand,URAN
      common/ide/idum
      common/ISEE/ISEED
*_________________________________________________________________________
      do i=1,npop
       item=1
       do j=1,ntr
 5       ipk(j)=1+nint(rand(idum)*npop)
         if (ipk(j) .eq. item) goto 5
         if (ipk(j) .gt. npop) goto 5
         item=ipk(j)
       enddo
!       write(3,*)(ipk(j),j=1,ntr)
       iselect(i)=ipk(1)
       do j=2,ntr
         if(fit(ipk(j)).lt.fit(ipk(j-1)))iselect(i)=ipk(j)
!         write(3,*)'is',iselect(i)
       enddo
      enddo
      return
      end