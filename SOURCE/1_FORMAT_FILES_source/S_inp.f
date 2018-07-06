!=========================== SUBROUTINE U1 =============================
      SUBROUTINE filenames(f1,f2,f3,f4,f5)!                           >>
      IMPLICIT NONE!                                                  >>
      LOGICAL there!                                                  >>
      CHARACTER(100) :: f1,f2,f3,f4,f5!                               >>
!======================================================================= 
      inquire(file='INPUT_FILES',exist=there)
      if (there) then
         open (1,file='INPUT_FILES')
         read(1,*)
         read(1,*)f1!   INPUT_DATASET
         read(1,*)f2!   IN_DUMMY
         read(1,*)f3!   IN_PARENT
         read(1,*)f4!   IN_GAPRMTR
         read(1,*)f5!   IN_TARGET
      else
         write(*,*)'>> ERROR: < INPUT_FILES > is missing......         '
         write(*,*)'>> UNABLE TO START THE CODE                      <<'
         write(*,*)'>> Press [CTRL+C] to stop......................  <<'
         write(*,*)
         call sleep(15)
         stop
      endif
      close(1)
      return
      end
