!============================ DECLARATION ==============================
      IMPLICIT NONE!                                                  ||
!     include 'PARAMETERS.H'!                                         ||
      INTEGER i,line,iop,ipop,ipid!                                   ||
!     INTEGER ky(ntot)!                                               ||
      INTEGER,ALLOCATABLE :: ky(:)!                                   %%
!     DOUBLE PRECISION rpw(npw),ren(nen),rps(nps)!                    ||
      DOUBLE PRECISION,ALLOCATABLE :: rpw(:),ren(:),rps(:)!           %%
!     DOUBLE PRECISION avol(neos),aprs(neos)!                         ||
      DOUBLE PRECISION,ALLOCATABLE :: avol(:),aprs(:)!                %%
      DOUBLE PRECISION E0w, V0w, B0w, B0pw!                           ||
!     DOUBLE PRECISION prnt(npop,nop)!                                ||      
      DOUBLE PRECISION,ALLOCATABLE :: prnt(:,:)!                      %%
      INTEGER maxgen,ign,ntrn!                                        ||
      DOUBLE PRECISION cp,cpmx,cpmn,ci,cimx,cimn,alpha!               ||
      DOUBLE PRECISION pm,pmmx,pmmn,pi,pimx,pimn!                     ||
      DOUBLE PRECISION Vmin, Vmax!                                    ||
      DOUBLE PRECISION clgotm,clga!                                   ||
!     DOUBLE PRECISION cpwmx(nwfnfl),cpspwmx(nwfnfl),cprjmx(nwfnfl)!  ||
!     DOUBLE PRECISION cpwmn(nwfnfl),cpspwmn(nwfnfl),cprjmn(nwfnfl)!  ||
      DOUBLE PRECISION,ALLOCATABLE :: cpwmx(:),cpspwmx(:),cprjmx(:)!  %%
      DOUBLE PRECISION,ALLOCATABLE :: cpwmn(:),cpspwmn(:),cprjmn(:)!  %%
      DOUBLE PRECISION areap,avgfit!                                  ||
!     DOUBLE PRECISION areap,farea(npop),fotm(npop),fit(npop),avgfit! ||
      DOUBLE PRECISION,ALLOCATABLE :: farea(:),fotm(:),fit(:)!        %%
!     CHARACTER(100) wky(ntot)!                                       ||
      CHARACTER(100),ALLOCATABLE :: wky(:)!                           %%
!============================ =========== ==============================
      INTEGER igen,iky!                                               ||
!     DOUBLE PRECISION iselect(npop),fitsl(npop)!                     ||
      INTEGER,ALLOCATABLE :: iselect(:)!                              %%
      DOUBLE PRECISION,ALLOCATABLE :: fitsl(:)!                       %%
!     DOUBLE PRECISION offspr(npop,nop),poolm(npop,nop)!              ||
      DOUBLE PRECISION,ALLOCATABLE :: offspr(:,:),poolm(:,:)!         %%
      DOUBLE PRECISION RUN,SYSTEM!                                    ||
      INTEGER ipw,ien,ips!                                            ||
!     DOUBLE PRECISION aindv(nop)!                                    ||
      DOUBLE PRECISION,ALLOCATABLE :: aindv(:)!                       %%
      CHARACTER*70 cna,cnb!                                           ||      
      DOUBLE PRECISION dlgotm,dlga!                                   ||
!     DOUBLE PRECISION dpwmx(nwfnfl),dpspwmx(nwfnfl),dprjmx(nwfnfl)!  ||
!     DOUBLE PRECISION dpwmn(nwfnfl),dpspwmn(nwfnfl),dprjmn(nwfnfl)!  ||
      DOUBLE PRECISION,ALLOCATABLE :: dpwmx(:),dpspwmx(:),dprjmx(:)!  %%
      DOUBLE PRECISION,ALLOCATABLE :: dpwmn(:),dpspwmn(:),dprjmn(:)!  %%
      INTEGER ic,iex,iwfn,itag!                                       ||
!     INTEGER ic(npop)!                                               ||
!     INTEGER,ALLOCATABLE :: ic(:)!                                   %%
!     DOUBLE PRECISION fito(npop),arcfit(n2pop)!                      ||
!     DOUBLE PRECISION archv(n2pop,nop)!                              ||
      DOUBLE PRECISION,ALLOCATABLE :: fito(:),arcfit(:)!              %%
      DOUBLE PRECISION,ALLOCATABLE :: archv(:,:)!                     %%
      DOUBLE PRECISION fittest!                                       ||
!============================ =========== ==============================      
      INTEGER imrc,idum!                                             ||     
!     DOUBLE PRECISION prmx(npop),prmn(npop),primn(npop)!             ||
      DOUBLE PRECISION,ALLOCATABLE :: prmx(:),prmn(:),primn(:)!       %%
      DOUBLE PRECISION crpmxt,crpmnt,crpt,bm1!                        ||
      DOUBLE PRECISION ratio!                                         ||
!     DOUBLE PRECISION probm(npop),aintm(npop)!                       ||
      DOUBLE PRECISION,ALLOCATABLE :: probm(:),aintm(:)!              %%
!============================ =========== ==============================
      real*4 rand!                                                    || 
      common/ide/idum!                                                ||
!============================ =========== ==============================
      INTEGER ischm,ntot,nop,ncns,istrt         !                     ||
      INTEGER nwfnfl,nlgfl,nlgline,npop,n2pop   !                     ||
      INTEGER nky,neos,npw,nps,nen,nvpnt        !                     ||
      INTEGER itemp,irow,newcnt                 !                     ||
      DOUBLE PRECISION cwfn,crpmx,crpmn,crp     !                     ||
      DOUBLE PRECISION wtp_ext,wtp_h,wtp_m,wtp_l!                     ||
      DOUBLE PRECISION wtwfn                    !                     ||
      DOUBLE PRECISION engr1,engr2              !                     ||
      LOGICAL there!                                                  %%
!============================ =========== ==============================     
