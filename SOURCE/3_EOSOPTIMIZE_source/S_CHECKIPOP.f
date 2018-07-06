!----------------------------- CHKINTL --------------------------------|1
! CHKINTL checks whether each solution string from the archive obeys   |
! the RPAW constraints or not.                                         |
!----------------------------------------------------------------------|
!   VARIABLES/  |                      DESCRIPTION OF                  |
!   PARAMETERS  |                   VARIABLES/PARAMETERS               |
!......................................................................|
! nop           : Number of variables that have to optimize.           |   
! ncns          : Number of parameters that depends on distance        |   
! aindv(nop)    : individual or solution string contains parameters    |   
!                 subject to optimization.                             |   
! crpmx         : Maximum allowed value for RPAW                       |   
! crpmn         : Minimum allowed value for RPAW                       |   
! crp           : Minimum allowed value (other distance parameters)    |
!......................................................................|
      SUBROUTINE CHKINTL(ipop,nop,ncns,aindv,crpmx,crpmn,crp)
      implicit none
      integer iop,ipop,nop,ncns
      double precision aindv(nop),crpmx,crpmn,crp,rpaw
      if (aindv(1).gt.crpmx.or.aindv(1).lt.crpmn)then
         WRITE(*,*)ipop,aindv(1),crpmx,crpmn,'RPAW OUT OF RANGE'
         STOP
      endif
      rpaw=aindv(1)
      do iop=2,ncns
        if (aindv(iop).gt.rpaw)then
          WRITE(*,*)ipop,iop,'aindv(iop) > rpaw'
          STOP
        endif
        if (aindv(iop).lt.crpmn)then
          WRITE(*,*)ipop,iop,'aindv(iop) < crpmn'
          STOP
        endif
      enddo
      return
      end
