!=========================== SUBROUTINE U1 =============================
       SUBROUTINE RINPUTS(ntot,nky,npop,nop,nwfnfl,npw,nen,nps,neos,
     +             ky,wky,rpw,ren,rps,E0w,V0w,B0w,B0pw,avol,aprs,
     +             maxgen,ign,ntrn,cp,cpmx,cpmn,ci,cimx,cimn,alpha,
     +             pm,pmmx,pmmn,pi,pimx,pimn,clgotm,clga,cpwmx,
     +             cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,prnt,
     +             Vmin,Vmax,crpmx,crpmn,crp,wtp_ext,wtp_h,wtp_m,wtp_l,
     +             ischm,istrt,wtwfn,nvpnt,prmx,prmn,primn)
      IMPLICIT NONE!                                                  >>
!     include 'PARAMETERS.H'!                                         >>
      INTEGER ntot,nky,npop,nop,nwfnfl,npw,nen,nps,neos!              ||
      INTEGER if1,if2,if3,if4,if5,if6,if7,if8,if9!file numbers        >>
      INTEGER line,ky(ntot)!                                          >>
!     INTEGER,ALLOCATABLE :: ky(:)!                                   %%
      INTEGER iky,ien,ips,ipw,iop,ipop!                               >>
      INTEGER maxgen,ign,ntrn!                                        >>
      INTEGER ischm,istrt,nvpnt!                                      >>
      INTEGER itemp,idum!                                             ||     
      DOUBLE PRECISION prmx(npop),prmn(npop),primn(npop)!             ||      
      DOUBLE PRECISION crpmx,crpmn,crp!                               >>
      DOUBLE PRECISION wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn!               >>      
      DOUBLE PRECISION rpw(npw),ren(nen),rps(nps)!                    >>
!     DOUBLE PRECISION,ALLOCATABLE :: rpw(:),ren(:),rps(:)!           %%
      DOUBLE PRECISION avol(neos),aprs(neos)!                         >>
!     DOUBLE PRECISION,ALLOCATABLE :: avol(:),aprs(:)!                %%
      DOUBLE PRECISION E0w, V0w, B0w, B0pw!                           >>
      DOUBLE PRECISION prnt(npop,nop)!                                >> 
!     DOUBLE PRECISION,ALLOCATABLE :: prnt(:,:)!                      %%
      DOUBLE PRECISION cp,cpmx,cpmn,ci,cimx,cimn,alpha!               >>     
      DOUBLE PRECISION pm,pmmx,pmmn,pi,pimx,pimn!                     >>     
      DOUBLE PRECISION Vmin, Vmax!                                    >>
      DOUBLE PRECISION clgotm,clga!                                   >>      
      DOUBLE PRECISION cpwmx(nwfnfl),cpspwmx(nwfnfl),cprjmx(nwfnfl)!  >>      
      DOUBLE PRECISION cpwmn(nwfnfl),cpspwmn(nwfnfl),cprjmn(nwfnfl)!  >>      
!     DOUBLE PRECISION,ALLOCATABLE :: cpwmx(:),cpspwmx(:),cprjmx(:)!  %%
!     DOUBLE PRECISION,ALLOCATABLE :: cpwmn(:),cpspwmn(:),cprjmn(:)!  %%
      CHARACTER(100) :: f1,f2,f3,f4,f5!                               >>
      CHARACTER(100) wky(nky)!                                        >>
!     CHARACTER(100),ALLOCATABLE :: wky(:)!                           %%
!============================ =========== ==============================
      real*4 rand!                                                    || 
      common/ide/idum!                                                ||
!=======================================================================
      if1=81
      if2=82
      if3=83
      if4=84
      if5=85
      if6=86
! <==================================================================== 
      write(*,*)'>> Dealing with Inputs: Reading Names of input files' 
      call sep()
! ====================================================================>      
      write(*,*)
      open (if1,file='INPUT_FILES',status='old')
         read(if1,*)
         read(if1,*)f1!   INPUT_DATASET
         read(if1,*)f2!   IN_DUMMY
         read(if1,*)f3!   IN_PARENT
         read(if1,*)f4!   IN_GAPRMTR
         read(if1,*)f5!   IN_TARGET
         close(if1)
!          WRITE(*,*)f1! 
!          WRITE(*,*)f2! 
!          WRITE(*,*)f3! 
!          WRITE(*,*)f4! 
!          WRITE(*,*)f5! 
!          STOP
! <==================================================================== 
      write(*,*)'>>  Reading < ',trim(f2),' >  '
      call sep()
! ====================================================================> 
      open (if1,file=trim(f2),status='old')
!      rewind(if1)
!          write(*,*)ntot
      do line=1, ntot
         read(if1,*)ky(line)
!          write(1,*)line,ky(line)
      enddo
!       STOP
      close(if1)
! <==================================================================== 
      write(*,*)'>> Reading < ',trim(f1),' > '
      call sep()
! ====================================================================>      
      call readf1(f1,ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)
          open(45,file='fortfile',status='new')
          do ipw=1,npw
             write(45,*)rpw(ipw)
          enddo
          do ips=1,nps
             write(45,*)rps(ips)
          enddo
          do ien=1,nen
             write(45,*)ren(ien)
          enddo
          close(45)
!       call write_stndr(ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)
!       write(*,*)'CHECK'
!       STOP
! <==================================================================== 
      write(*,*)'>> Reading < ',trim(f5),' > ......................... '
      call sep()
! ====================================================================> 
      open (if1,file=trim(f5),status='old')
         do line=1, neos
            read(if1,*)avol(line),aprs(line)
         enddo
      close(if1) 
!       STOP   
! <==================================================================== 
      write(*,*)'>> Reading < ',trim(f3),' >  '
      call sep()
! ====================================================================>
      open (if1,file=trim(f3),status='old')
      do ipop=1,npop
         read(if1,*)prnt(ipop,1),prnt(ipop,2),prnt(ipop,3),prnt(ipop,4)!RPAW,RSHAPE,RVLOC,RCORE
         do iop=5,nop
            read(if1,*)prnt(ipop,iop)
         enddo
         read(if1,*)
      enddo
      close(if1)
!       STOP
! <==================================================================== 
      write(*,*)'>> Reading < ',trim(f4),' >  '
      call sep()
! ====================================================================>
      open(if1,file=trim(f4),status='old')
      read(if1,*)
      read(if1,*)cp,cpmx,cpmn
      read(if1,*)
      read(if1,*)ci,cimx,cimn
      read(if1,*)
      read(if1,*)alpha      
      read(if1,*)
      read(if1,*)pm,pmmx,pmmn
      read(if1,*)
      read(if1,*)pi,pimx,pimn
      read(if1,*)
      read(if1,*)maxgen
      read(if1,*)
      read(if1,*)ign
      read(if1,*)
      read(if1,*)ntrn
!       write(*,*)
!       write(*,*)cp,cpmx,cpmn
!       write(*,*)
!       write(*,*)ci,cimx,cimn
!       write(*,*)
!       write(*,*)alpha      
!       write(*,*)
!       write(*,*)pm,pmmx,pmmn
!       write(*,*)
!       write(*,*)pi,pimx,pimn
!       write(*,*)
!       write(*,*)maxgen
!       write(*,*)
!       write(*,*)ign
!       write(*,*)
!       write(*,*)ntrn     
      close(if1)
!       STOP
! <====================================================================       
       write(*,*)'>> Reading USER INPUTS  '
       call sep()      
! ====================================================================> 
!       open(if1,file='USER_INPUTS',status='old')
       read (*,*) ischm
       read (*,*) istrt
       read (*,*) npop
       read (*,*) crpmx
       read (*,*) crpmn
       read (*,*) crp
       read (*,*) wtp_ext,wtp_h,wtp_m,wtp_l
       read (*,*) wtwfn
       read (*,*) nvpnt
       read (*,*) neos
       read (*,*) E0w,V0w,B0w,B0pw
       read (*,*) Vmin, Vmax
       read(*,*)itemp
!       write(*,*)itemp
       if (itemp.eq.0)then
        do ipop=1, npop
          prmx(ipop)=crpmx
        enddo        
        idum=0
        do ipop=1, npop
          if (rand(idum).gt.0.5)then
             prmx(ipop)=crpmx+rand(idum)*0.1
             prmn(ipop)=prmx(ipop)-rand(idum)*(crpmx-crpmn)
             primn(ipop)=prmx(ipop)-rand(idum)*(crpmx-crp)
          else
             prmn(ipop)=prmx(ipop)-rand(idum)*(crpmx-crpmn)*2.0
             primn(ipop)=prmx(ipop)-rand(idum)*(crpmx-crp)*2.0          
          endif
         write(*,*)prmx(ipop),prmn(ipop),primn(ipop)
        enddo       
       else
        do ipop=1, npop
          read(*,*)prmx(ipop),prmn(ipop),primn(ipop)
         write(*,*)prmx(ipop),prmn(ipop),primn(ipop)
        enddo
       endif
!        STOP
! <====================================================================       
       write(*,*)'>> Reading CONSTRAINTS based on initial guess'
       call sep()      
! ====================================================================>      
      open(if1,file='CONSTRAINTS',status='old')
      read(if1,*)
      read(if1,*)clgotm,clga
      read(if1,*)
      read(if1,*)
      do line=1,nwfnfl
         read(if1,*)cpwmx(line),cpspwmx(line),cprjmx(line)
         read(if1,*)cpwmn(line),cpspwmn(line),cprjmn(line)
      enddo 
      close(if1)
! ! <====================================================================       
!       call sep()            
! ! ====================================================================>
      return
      end
