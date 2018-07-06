!=========================== SUBROUTINE U3 =============================
      SUBROUTINE readf2(f2,ndmy,ky,nky,npw,nen,nps)!                  >>
      IMPLICIT NONE!                                                  >>
      INTEGER ndmy,nky,npw,nen,nps,line!                              >>
      INTEGER ky(ndmy)!                                               >>
      CHARACTER(100) :: f2!                                           >>
!=======================================================================    
      open (1,file=trim(f2))
      nky=0
      npw=0
      nen=0
      nps=0
      do line=1, ndmy
         read(1,*)ky(line)
         if(ky(line).eq.0)then
           nky=nky+1
         elseif(ky(line).ge.1.and.ky(line).le.4)then
           npw=npw+ ky(line)
         elseif(ky(line).eq.5)then
           nen=nen+1
         elseif(ky(line).eq.6)then
           nps=nps+1
         endif
!        write(*,*)ky(line)
      enddo
!     write(*,*)ndmy,nky,npw,nen,nps      
      close(1)
      return
      end
