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
!      SUBROUTINE CONINTL(ipop,nop,ncns,aindv,crpmx,crpmn,crp)
!      implicit none
!      integer iop,ipop,nop,ncns
!      double precision aindv(nop),crpmx,crpmn,crp,rpaw
!      if (aindv(1).gt.crpmx)aindv(1)=crpmx
!      if (aindv(1).lt.crpmn)aindv(1)=crpmn
!      rpaw=aindv(1)
!      do iop=2,ncns
!        if (aindv(iop).gt.rpaw)aindv(iop)=rpaw
!        if (aindv(iop).lt.crpmn)aindv(iop)=crpmn
!      enddo
!      return
!      end
      SUBROUTINE CONINTL(ipop,nop,ncns,aindv,crpmx,crpmn,crp)
      implicit none
      integer iop,ipop,nop,ncns,idum
      double precision aindv(nop),crpmx,crpmn,crp,rpaw
      double precision r,rndm,term
      real*4 rand!                                                    ||
      common/ide/idum!                                                ||
      if (ipop.ge.2)then
         if (aindv(1).gt.crpmx)aindv(1)=crpmx
         if (aindv(1).lt.crpmn)aindv(1)=crpmn
         rpaw=aindv(1)
         do iop=2,ncns
           if (aindv(iop).gt.rpaw)aindv(iop)=rpaw
           if (aindv(iop).lt.crpmn)aindv(iop)=crpmn
         enddo
         do iop=1+ncns,nop
           rndm=rand(idum)
           if (rndm.ge.0.5)r=1.0d0*rndm
           if (rndm.lt.0.5)r=-1.0d0*rndm
           term=0.5*aindv(iop)*r*r
!           term=0.5*aindv(iop)*r*rand(idum)
!           if(dabs(term).gt.(aindv(iop)/2.0)term=term*rand(idum)
!           aindv(iop)=aindv(iop)+aindv(iop)*r*rand(idum)
           aindv(iop)=aindv(iop)+term
         enddo
      endif
      return
      end

