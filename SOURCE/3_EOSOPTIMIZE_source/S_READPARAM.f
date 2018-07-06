      SUBROUTINE READPARAMS(ischm,ntot,nop,ncns,
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
      open (1,file='PARAMETERS',status='old')
      read(1,*)  ischm
      read(1,*)  istrt
      read(1,*)   ntot
      read(1,*)    npw
      read(1,*)    nps
      read(1,*)    nen
      read(1,*)    nop
      read(1,*)   ncns
      read(1,*)    nky
      read(1,*) nwfnfl
      read(1,*)  nlgfl
      read(1,*)nlgline
      read(1,*)wtp_ext
      read(1,*)  wtp_h
      read(1,*)  wtp_m
      read(1,*)  wtp_l
      read(1,*)  wtwfn
      read(1,*)   npop
      read(1,*)  n2pop
      read(1,*)  nvpnt
      read(1,*)   neos
      read(1,*)  crpmx
      read(1,*)  crpmn
      read(1,*)    crp
      close(1)
      return
      end
