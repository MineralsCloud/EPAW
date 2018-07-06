!=========================== SUBROUTINE U6 =============================
      SUBROUTINE N_wfn_lg(nop,nwfnfl,nlgfl,nlgline)!                  >>
      IMPLICIT NONE!                                                  >>
      INTEGER nop,nwfnfl,nlgfl,nlgline,i!                             >>
      CHARACTER(100) cna,fnma!                                        >>
      LOGICAL there!                                                  >>
!=======================================================================    
      nwfnfl=0
      do i=1,nop
         if (i.lt.10)then
           write(cna,FMT="(I1)")i
         else
           write(cna,FMT="(I2)")i
         endif
         fnma='wfn'//trim(cna)
         inquire(file=trim(fnma),exist=there)
         if (there) then
            nwfnfl=nwfnfl+1
         else
           goto  10
         endif
      enddo
10    nlgfl=0
      do i=0,nop
         if (i.lt.10)then
           write(cna,FMT="(I1)")i
         else
           write(cna,FMT="(I2)")i
         endif
         fnma='logderiv.'//trim(cna)
         inquire(file=trim(fnma),exist=there)
         if (there) then
            nlgfl=nlgfl+1
         else
           goto  11
         endif
      enddo
11    if(nwfnfl.ge.1.and.nlgfl.ge.1)then
          fnma='logderiv.0'
          call NROW(fnma,nlgline)!nlgline=Number of lines in logderiv.* file
      endif
      !write(*,*)nwfnfl,nlgfl,nlgline
      return
      end
