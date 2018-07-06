!=========================== SUBROUTINE U1 =============================
       SUBROUTINE CHINPUTS(ntot,nky,npop,nop,nwfnfl,npw,nen,nps,neos,
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
! 
! 
! 
! 
! 
!       SUBROUTINE CHINPUTS(ky, wky, rpw,ren,rps,  ! from f1 & f2        >>
!      +                   avol,aprs,prnt,E0w, V0w, B0w, B0pw,! f3 & f5 >>
!      +                   maxgen,ign,ntrn,cp,cpmx,cpmn,ci,cimx,cimn,!  >>
!      +                   alpha,pm,pmmx,pmmn,pi,pimx,pimn,! f4
!      +                   Vmin, Vmax,
!      +                   clgotm,clga,cpwmx,cpspwmx,cprjmx,!  >>
!      +                   cpwmn,cpspwmn,cprjmn,!                     >>
!      +              ntot,nky,npop,nop,nwfnfl,npw,nen,nps,neos)
!       IMPLICIT NONE!                                                  >>
!     include 'PARAMETERS.H'!                                         >>
!     INTEGER ntot,nky,npop,nop,nwfnfl,npw,nen,nps!                   ||
!     INTEGER if1,if2,if3,if4,if5,if6,if7,if8,if9!file numbers        >>
!     INTEGER line,ky(ntot)!                                          >>
!     INTEGER iky,ien,ips,ipw,iop,ipop!                               >>
!     INTEGER maxgen,ign,ntrn!                                        >>
!     DOUBLE PRECISION rpw(npw),ren(nen),rps(nps)!                    >>
!     DOUBLE PRECISION avol(neos),aprs(neos)!                         >>
!     DOUBLE PRECISION E0w, V0w, B0w, B0pw!                           >>
!     DOUBLE PRECISION prnt(npop,nop)!                                >> 
!     DOUBLE PRECISION alpha,cp,cpmx,cpmn,ci,cimx,cimn!               >>     
!     DOUBLE PRECISION pm,pmmx,pmmn,pi,pimx,pimn!                     >>     
!     DOUBLE PRECISION Vmin, Vmax!                                    >>
!     DOUBLE PRECISION clgotm,clga!                                   >>      
!     DOUBLE PRECISION cpwmx(nwfnfl),cpspwmx(nwfnfl),cprjmx(nwfnfl)!  >>      
!     DOUBLE PRECISION cpwmn(nwfnfl),cpspwmn(nwfnfl),cprjmn(nwfnfl)!  >>      
!     CHARACTER(100) :: f1,f2,f3,f4,f5!                               >>
!     CHARACTER(100) wky(nky)!                                        >>
!       INTEGER ntot,nky,npop,nop,nwfnfl,npw,nen,nps,neos!              ||
!       INTEGER if1,if2,if3,if4,if5,if6,if7,if8,if9!file numbers        >>
!       INTEGER line,ky(ntot)!                                          >>
! !     INTEGER,ALLOCATABLE :: ky(:)!                                   %%
!       INTEGER iky,ien,ips,ipw,iop,ipop!                               >>
!       INTEGER maxgen,ign,ntrn!                                        >>
!       DOUBLE PRECISION rpw(npw),ren(nen),rps(nps)!                    >>
! !     DOUBLE PRECISION,ALLOCATABLE :: rpw(:),ren(:),rps(:)!           %%
!       DOUBLE PRECISION avol(neos),aprs(neos)!                         >>
! !     DOUBLE PRECISION,ALLOCATABLE :: avol(:),aprs(:)!                %%
!       DOUBLE PRECISION E0w, V0w, B0w, B0pw!                           >>
!       DOUBLE PRECISION prnt(npop,nop)!                                >> 
! !     DOUBLE PRECISION,ALLOCATABLE :: prnt(:,:)!                      %%
!       DOUBLE PRECISION cp,cpmx,cpmn,ci,cimx,cimn,alpha!               >>     
!       DOUBLE PRECISION pm,pmmx,pmmn,pi,pimx,pimn!                     >>     
!       DOUBLE PRECISION Vmin, Vmax!                                    >>
!       DOUBLE PRECISION clgotm,clga!                                   >>      
!       DOUBLE PRECISION cpwmx(nwfnfl),cpspwmx(nwfnfl),cprjmx(nwfnfl)!  >>      
!       DOUBLE PRECISION cpwmn(nwfnfl),cpspwmn(nwfnfl),cprjmn(nwfnfl)!  >>      
! !     DOUBLE PRECISION,ALLOCATABLE :: cpwmx(:),cpspwmx(:),cprjmx(:)!  %%
! !     DOUBLE PRECISION,ALLOCATABLE :: cpwmn(:),cpspwmn(:),cprjmn(:)!  %%
!       CHARACTER(100) :: f1,f2,f3,f4,f5!                               >>
!       CHARACTER(100) wky(nky)!                                        >>
! !     CHARACTER(100),ALLOCATABLE :: wky(:)!                           %%
!=======================================================================
      if1=81
      open (if1,file='CHECKS',status='unknown')
! <==================================================================== 
! ====================================================================>        
      write(if1,*)'# >>  IN_DUMMY' 
      write(if1,*)
      do line=1, ntot
         write(if1,*)ky(line)
      enddo
! <==================================================================== 
! ====================================================================>      
      write(if1,*)'# >> INPUT_DATASET in IN_STANDARD '
      write(if1,*)
      call write_stndr(ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)
! <==================================================================== 
! ====================================================================> 
      write(if1,*)'# >> IN_TARGET  '
      write(if1,*)
!      if (ischm.eq.0)then
         do line=1, neos
            write(if1,*)avol(line),aprs(line)
         enddo
!         write(if1,*)E0w, V0w, B0w, B0pw
!      else
!         write(if1,*)E0w, V0w, B0w, B0pw
!      endif 
! <==================================================================== 
! ====================================================================>
      write(if1,*)'# >> IN_PARENT  '
      write(if1,*)     
      do ipop=1,npop
         write(if1,*)prnt(ipop,1),prnt(ipop,2),prnt(ipop,3),prnt(ipop,4)!RPAW,RSHAPE,RVLOC,RCORE
         do iop=5,nop
            write(if1,*)prnt(ipop,iop)
         enddo
         write(if1,*)
      enddo
! <==================================================================== 
! ====================================================================>
      write(if1,*)'# >> IN_GAPARAMETERS  '
      write(if1,*) 
      write(if1,*)
      write(if1,*)cp,cpmx,cpmn
      write(if1,*)
      write(if1,*)ci,cimx,cimn
      write(if1,*)
      write(if1,*)alpha
      write(if1,*)
      write(if1,*)pm,pmmx,pmmn
      write(if1,*)
      write(if1,*)pi,pimx,pimn
      write(if1,*)
      write(if1,*)maxgen
      write(if1,*)
      write(if1,*)ign
      write(if1,*)
      write(if1,*)ntrn
! <====================================================================       
! ====================================================================>      
       write(if1,*)'#>> USER INPUTS ..........................'
       WRITE(if1,*) ischm
       WRITE(if1,*) istrt
       WRITE(if1,*) npop
       WRITE(if1,*) crpmx
       WRITE(if1,*) crpmn
       WRITE(if1,*) crp
       WRITE(if1,*) wtp_ext,wtp_h,wtp_m,wtp_l
       WRITE(if1,*) wtwfn
       WRITE(if1,*) nvpnt
       WRITE(if1,*) neos
       WRITE(if1,*) E0w,V0w,B0w,B0pw
       WRITE(if1,*) Vmin, Vmax
       do ipop=1, npop
         write(if1,*)prmx(ipop),prmn(ipop),primn(ipop)
       enddo
! <====================================================================       
! ====================================================================>      
      write(if1,*)'# >> CONSTRAINTS ..........................'
      write(if1,*)
      write(if1,*)clgotm,clga
      write(if1,*)
      write(if1,*)
      do line=1,nwfnfl
         write(if1,*)cpwmx(line),cpspwmx(line),cprjmx(line)
         write(if1,*)cpwmn(line),cpspwmn(line),cprjmn(line)
      enddo 
      close(if1)
! <====================================================================       
      call sep()            
! ====================================================================>
      return
      end
