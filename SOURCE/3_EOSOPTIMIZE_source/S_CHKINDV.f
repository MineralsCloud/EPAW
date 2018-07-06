!______________________________________________________________________
!______________________________________________________________________
!   |   CHKINDV checks whether each solution string from the       |
!   |   archive obeys the RPAW constraints or not.                 |
!___|______________________________________________________________|___
!   VARIABLES/  |                    DESCRIPTION OF                |   
!   CONSTRAINTS |                VARIABLES/CONSTRAINTS             |   
!_______________|__________________________________________________|___
! nop           I Number of variables that have to optimize.       |   
! ncns          I Number of parameters that depends on distance    |   
! aindv(nop)    I individual or solution string contains parameters|   
!               | subject to optimization.                         |   
! crpmx         I Maximum allowed value for RPAW                   |   
! crpmn         I Minimum allowed value for RPAW                   |   
! crp           I Minimum allowed value (other distance parameters)|
!_______________|__________________________________________________|___
      SUBROUTINE CHKINDV(nop,ncns,aindv,crpmx,crpmn,crp)
      implicit none
      integer iop,nop,ncns
      double precision aindv(nop),crpmx,crpmn,crp,rpaw
      if (aindv(1).gt.crpmx)aindv(1)=crpmx
      if (aindv(1).lt.crpmn)aindv(1)=crpmn
      rpaw=aindv(1)
      do iop=2,ncns
        if (aindv(iop).gt.rpaw)aindv(iop)=rpaw
        if (aindv(iop).lt.crpmn)aindv(iop)=crpmn
      enddo
      do iop=ncns+1,nop
       if (aindv(iop).lt.crp)aindv(iop)=crp
      enddo
      return
      end