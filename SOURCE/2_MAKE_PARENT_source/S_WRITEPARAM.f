      SUBROUTINE WRITEPARAMS(ischm,ntot,nop,ncns,
     +                 istrt,nwfnfl,nlgfl,nlgline,npop,n2pop,
     +                 nky,neos,npw,nps,nen,nvpnt,
     +                 cwfn,crpmx,crpmn,crp,
     +                 wtp_ext,wtp_h,wtp_m,wtp_l,
     +                 wtwfn)
!============================ =========== ==============================
      IMPLICIT NONE
      INTEGER ischm,ntot,nop,ncns,istrt         !                     ||
      INTEGER nwfnfl,nlgfl,nlgline,npop,n2pop   !                     ||
      INTEGER nky,neos,npw,nps,nen,nvpnt        !                     ||
      DOUBLE PRECISION cwfn,crpmx,crpmn,crp     !                     ||
      DOUBLE PRECISION wtp_ext,wtp_h,wtp_m,wtp_l!                     ||
      DOUBLE PRECISION wtwfn                    !                     || 
!=======================================================================       
      write(*,*)'  ischm==>',  ischm
      write(*,*)'  istrt==>',  istrt
      write(*,*)'   ntot==>',   ntot
      write(*,*)'    npw==>',    npw
      write(*,*)'    nps==>',    nps
      write(*,*)'    nen==>',    nen
      write(*,*)'    nop==>',    nop
      write(*,*)'   ncns==>',   ncns
      write(*,*)'    nky==>',    nky
      write(*,*)' nwfnfl==>', nwfnfl
      write(*,*)'  nlgfl==>',  nlgfl
      write(*,*)'nlgline==>',nlgline
      write(*,*)'wtp_ext==>',wtp_ext
      write(*,*)'  wtp_h==>',  wtp_h
      write(*,*)'  wtp_m==>',  wtp_m
      write(*,*)'  wtp_l==>',  wtp_l
      write(*,*)'  wtwfn==>',  wtwfn
      write(*,*)'   npop==>',   npop
      write(*,*)'  n2pop==>',  n2pop
      write(*,*)'  nvpnt==>',  nvpnt
      write(*,*)'   neos==>',   neos
      write(*,*)'  crpmx==>',  crpmx
      write(*,*)'  crpmn==>',  crpmn
      write(*,*)'    crp==>',    crp
      return
      end
