!--------------------------- WFNCNSTRNT -------------------------------|4
! WFNCNSTRNT checks whether WFN constraints are satisfied?             |
!----------------------------------------------------------------------|
!   VARIABLES/  |                      DESCRIPTION OF                  |
!   PARAMETERS  |                   VARIABLES/PARAMETERS               |
!......................................................................|
! n             : number of rows in logderiv files                     |   
! nlgfile       : number of logderiv files                             |   
! iex           : measure of discontinuity                             |   
!......................................................................|
      SUBROUTINE WFNCNSTRNT(cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,
     \                      dpwmx,dpspwmx,dprjmx,dpwmn,dpspwmn,dprjmn,
     \                      nwfnfl,wtwfn,iwfn)
      IMPLICIT NONE!                                                  ||
      INTEGER ifl,nwfnfl,iwfn!                                        ||
      DOUBLE PRECISION cpwmx(nwfnfl),cpspwmx(nwfnfl),cprjmx(nwfnfl)!  ||
      DOUBLE PRECISION cpwmn(nwfnfl),cpspwmn(nwfnfl),cprjmn(nwfnfl)!  ||
      DOUBLE PRECISION dpwmx(nwfnfl),dpspwmx(nwfnfl),dprjmx(nwfnfl)!  ||
      DOUBLE PRECISION dpwmn(nwfnfl),dpspwmn(nwfnfl),dprjmn(nwfnfl)!  ||
      DOUBLE PRECISION pwmx,pspwmx,prjmx!                             ||
      DOUBLE PRECISION pwmn,pspwmn,prjmn!                             ||
      DOUBLE PRECISION wtwfn!                                         ||
            iwfn=0
      do ifl=1,nwfnfl
         pwmx=wtwfn*dabs(cpwmx(ifl))-dabs(dpwmx(ifl)-cpwmx(ifl))
         pspwmx=wtwfn*dabs(cpspwmx(ifl))-dabs(dpspwmx(ifl)-cpspwmx(ifl))
         prjmx=wtwfn*dabs(cprjmx(ifl))-dabs(dprjmx(ifl)-cprjmx(ifl))
         pwmn=wtwfn*dabs(cpwmn(ifl))-dabs(dpwmn(ifl)-cpwmn(ifl))
         pspwmn=wtwfn*dabs(cpspwmn(ifl))-dabs(dpspwmn(ifl)-cpspwmn(ifl))
         prjmn=wtwfn*dabs(cprjmn(ifl))-dabs(dprjmn(ifl)-cprjmn(ifl))
         if(pwmx.ge.0.0d0.and.pspwmx.ge.0.0d0.and.prjmx.ge.0.0d0.and.
     +      pwmn.ge.0.0d0.and.pspwmn.ge.0.0d0.and.prjmn.ge.0.0d0)then
            iwfn=iwfn+0
          else
            iwfn=iwfn+1
!          write(*,20)pwmx,pspwmx,prjmx,pwmn,pspwmn,prjmn
!          write(*,*)iwfn,'iwfn'
         endif
      enddo
20    format(6f14.7)
      RETURN
      END