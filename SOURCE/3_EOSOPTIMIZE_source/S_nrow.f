!=========================== SUBROUTINE U2 =============================
      SUBROUTINE NROW(fname,irow)!                                    >>
      IMPLICIT NONE!                                                  >>
      INTEGER irow!                                                   >>
      CHARACTER(100) :: fname!                                        >>
!=======================================================================    
      open(1,file=trim(fname))
      irow = 0
      do
        read (1,*, END=10)
        irow = irow + 1
      enddo
10    rewind(1)
      close(1)
      return
      end
