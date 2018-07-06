!=========================== SUBROUTINE U11 ============================
      SUBROUTINE U_inputs(ischm,crpmx,crpmn,crp,f5,istrt,npop,!       >>
     +             wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn,neos,nvpnt)!       >>
      IMPLICIT NONE!                                                  >>
      INTEGER ischm,neos,istrt,npop,nvpnt!                            >>
      DOUBLE PRECISION crpmx,crpmn,crp!                               >>
      DOUBLE PRECISION wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn!               >>
      CHARACTER(100) :: f5!                                           >>
!=======================================================================    
      write(*,*)'################## Put asked inputs ##################'
      write(*,*)'                                                      '
      write(*,*)' Scheme of optimization ?                             '
      write(*,*)'                  0 for EoS; 1 for Delta optimization '
      write(*,*)
      read (*,*)ischm
      write(*,*)' Start 4m scrach or 4m predefined parent population   '
      write(*,*)'put 0 for scrach; 1 for predefined parent population  '
      write(*,*)
      read (*,*)istrt
      write(*,*)'No. of members in starting parent population?         '
      write(*,*)'For this version of code it is fixed, put 10.         '
      write(*,*)
      read (*,*)npop 
      write(*,*)'Maximum allowed value for RPAW: must be >= Rpaw'
      write(*,*)
      read(*,*)crpmx
      write(*,*)'Minimum allowed value for RPAW: must be >=0    '
      write(*,*)
      read(*,*)crpmn
      write(*,*)'Minimum allowed value (other distance parameters)'
      write(*,*)
      read(*,*)crp
      write(*,*)'The whole expansion region has been divided to 4 '
      write(*,*)'parts; give weitage for different regions. e.g.  '
      write(*,*)'      1.00       1.00       1.00       0.95      '
      write(*,*)'P_ext=1.00d0,P_h=1.00d0,P_m=1.00d0,P_l=0.95      '
      write(*,*)'for equal priority throughout the entire region  '
      write(*,*)'put 1.0 1.0 1.0 1.0                              '
      write(*,*)
      read(*,*)wtp_ext,wtp_h,wtp_m,wtp_l
      write(*,*)'Give tolerace limit for wf and PSwf < 10         '
      write(*,*)
      read(*,*)wtwfn
      write(*,*)'Number of volume points for FP calculation '
      write(*,*)
      read(*,*)nvpnt     
      if (ischm.eq.0) then
         write(*,*)'No. of PV data in < ',trim(f5),' > file = 400 '
      write(*,*)
         read(*,*)neos
      endif
      return
      end
