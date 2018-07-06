      SUBROUTINE QESPRS()
      IMPLICIT NONE!                                                  ||
      DOUBLE PRECISION RUN,SYSTEM!                                    ||
      RUN=SYSTEM('python runQE.py')! :UNCOMMENT
!       RUN=SYSTEM('./controlscript')! :UNCOMMENT
      return
      end
