!============================ DECLARATION ==============================
      IMPLICIT NONE!                                                  %%
      INTEGER i,ndmy,nky,npw,nen,nps,nop,npop!                        %%
      INTEGER ipw,ien,ips,ipop,irow!                                  %%
      INTEGER,ALLOCATABLE :: ky(:)!                                   %%
      INTEGER ntot!nky,npw,nen,nps!                                   %%
      INTEGER nwfnfl,nlgfl,nlgline,iex!                               %%
      INTEGER ischm,neos,istrt,nvpnt!                                 %%
      DOUBLE PRECISION,ALLOCATABLE :: rpw(:),ren(:),rps(:)!           %%
      DOUBLE PRECISION RUN,SYSTEM!                                    %%
      DOUBLE PRECISION clgotm,clga!                                   %%
      DOUBLE PRECISION,ALLOCATABLE :: cpwmx(:),cpspwmx(:),cprjmx(:)!  %%
      DOUBLE PRECISION,ALLOCATABLE :: cpwmn(:),cpspwmn(:),cprjmn(:)!  %%
      DOUBLE PRECISION crpmx,crpmn,crp,cwfn!                          %%
      DOUBLE PRECISION wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn!               %%
      CHARACTER(100),ALLOCATABLE :: wky(:)!                           %%
      CHARACTER(100) :: f1,f2,f3,f4,f5!                               %%
      CHARACTER(100) :: cna,fnma,fname,fname1!                        %%
      LOGICAL there!                                                  %%
!============================ =========== ==============================
      write(*,*)
      write(*,*)'              CHECKING PREREQUISITES'
      write(*,*)'******************************************************'
      write(*,*)
! ====================================================================>  
      write(*,*)'######################################################'
      write(*,*)'#                                                    #'
      write(*,*)'# Current Folder must contain < INPUT_FILES >.       #'
      write(*,*)'# Entries: name of the other input files.            #'
      write(*,*)'# For example:                                       #'
      write(*,*)'#             INPUT_DATASET (required)               #'
      write(*,*)'#             IN_DUMMY      (required)               #'
      write(*,*)'#             IN_PARENT     (optional)               #'
      write(*,*)'#             IN_GAPRMTR    (optional)               #'
      write(*,*)'#             IN_TARGET     (required)               #'
      write(*,*)'# For details of the files check < README > file     #'
      write(*,*)'# File names can be changed in <INPUT_FILES>,        #'
      write(*,*)'# Order of appearances are fixed.                    #'
      write(*,*)'#                                                    #'
      write(*,*)'######################################################'
      write(*,*)
      write(*,*)'READING name of the essential input files ............'
      call filenames(f1,f2,f3,f4,f5)!: name of the other input files
      write(*,*)'            1) ',trim(f1)
      write(*,*)'            2) ',trim(f2) 
      write(*,*)'            3) ',trim(f3) 
      write(*,*)'            4) ',trim(f4) 
      write(*,*)'            5) ',trim(f5)
      write(*,*)
! <====================================================================  
      call sep()
! ====================================================================>  
      write(*,*)'Dealing with < ',trim(f2),' > ........................'
      write(*,*)   
      inquire(file=trim(f2),exist=there)
      if (there) then
         write(*,*)'Counting number of rows in  < ',trim(f2),' > file  '
         call NROW(f2,ndmy)
         write(*,*)'ndmy==',ndmy 
         write(*,*)
      else
         write(*,*)'>> ERROR: < ',trim(f2),' > is missing......        '
         write(*,*)'>> UNABLE TO START THE CODE                      <<'
         write(*,*)'>> Press [CTRL+C] to stop......................  <<'
         write(*,*)
         call sleep(5)
         stop
      endif
      allocate (ky(ndmy))
      write(*,*)'Reading content of  < ',trim(f2),' > file             '
      call readf2(f2,ndmy,ky,nky,npw,nen,nps)
      write(*,*)'0         Number of keywords in < ',trim(f2),' > ',nky
      write(*,*)'1/2/3/4   Number of PAW para in < ',trim(f2),' > ',npw
      write(*,*)'5         Number of Eng para in < ',trim(f2),' > ',nen
      write(*,*)'5         Number of PS waves in < ',trim(f2),' > ',nps
      write(*,*)
      write(*,*)'>>                        Press [CTRL+C] to stop .  <<'
      write(*,*)
      call sleep(1)
! <====================================================================
      call sep()      
! ====================================================================>
      write(*,*)'Dealing with < ',trim(f1),' > ........................'
      inquire(file=trim(f1),exist=there)
      if (there) then
         write(*,*)'Counting number of rows in  < ',trim(f1),' > file  '
         call NROW(f1,ntot)
         write(*,*)'ntot==',ntot 
         write(*,*)         
      else
         write(*,*)'>> ERROR: < ',trim(f1),' > is missing......        '
         write(*,*)'>> UNABLE TO START THE CODE                      <<'
         write(*,*)'>> Press [CTRL+C] to stop......................  <<'
         write(*,*)
         call sleep(5)
         stop
      endif
!
      if (ntot.ne.ndmy) then
         write(*,*)'>> Mismatch in No. of rows for the files.....    <<'
         write(*,*)'>> < ',trim(f1),' > ==>',ntot
         write(*,*)'>> < ',trim(f2),' > =======>',ndmy
         write(*,*)'>> UNABLE TO START THE CODE                      <<'
         write(*,*)'>> Press [CTRL+C] to stop......................  <<'
         write(*,*)
         call sleep(5)
         stop
      endif
!      
      allocate (wky(nky))
      allocate (rpw(npw))
      allocate (ren(nen))
      allocate (rps(nps))
      write(*,*)'Reading content of  < ',trim(f1),' > file    &        '
      call readf1(f1,ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)
      nop=npw+nen+nps
! 
      write(*,*)'Writing < IN_STANDARD > file in the light of          '
      write(*,*)' < ',trim(f1),' > and < ', trim(f2),' > files         '
      call write_stndr(ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)
      write(*,*)
      write(*,*)'Please check < IN_STANDARD >  before next execution   '
      write(*,*)
! <==================================================================== 
      call sep()
! ====================================================================>

      write(*,*)'Running ATOMPAW & Counting #wfn* & #logderiv.* Files  '
      write(*,*)
      RUN=SYSTEM('./APAW.sh')
      call N_wfn_lg(nop,nwfnfl,nlgfl,nlgline)
      write(*,*)'Number of logderiv.* files  ',nlgfl
      write(*,*)'Number of wfn.* files       ',nwfnfl
      write(*,*)'Number of rows in logderiv.*',nlgline  
      write(*,*)
! <====================================================================
      call sep()
! ====================================================================> 
      write(*,*)'Checking if any discontinuity exists in logderiv.*    '
      if (nlgfl.ge.1)then
         call DSTCNTY(nlgline,nlgfl,iex)
         if (iex.gt.2)then
         write(*,*)'>> ERROR: < logderiv.* > is/are discontinuous......'
         write(*,*)'>> UNABLE TO START THE CODE                      <<'
         write(*,*)'>> Press [CTRL+C] to stop......................  <<'
         write(*,*)
         call sleep(5)
         stop
         else
         write(*,*)'>> iex=',iex,' < logderiv.* > ','is/are OK       <<'
         write(*,*)
         endif
      else
         write(*,*)'>> ERROR: < logderiv.* > is missing......          '
         write(*,*)'>> UNABLE TO START THE CODE                      <<'
         write(*,*)'>> Press [CTRL+C] to stop......................  <<'
         write(*,*)
         call sleep(5)
         stop
      endif 
! <====================================================================
      call sep()
! ====================================================================>
      write(*,*)'preparing constraints based on < ',trim(f1),' >      '
      write(*,*)
      write(*,*)'Constraints on log derivative plots                 ' 
      CALL INTGPAW(nlgline,nlgfl,clgotm,clga)
      write(*,*)'sum of absolute difference between each point in   ..'
      write(*,*)'.. the log derivative plots of AE & ATOMPAW ',clgotm
      write(*,*)'[difference between area of log derivative plots   ..'
      write(*,*)'.. of AE & ATOMPAW ]^2                      ',clga
      write(*,*)
      allocate (cpwmx(nwfnfl))
      allocate (cpwmn(nwfnfl))
      allocate (cpspwmx(nwfnfl))
      allocate (cpspwmn(nwfnfl))
      allocate (cprjmx(nwfnfl))
      allocate (cprjmn(nwfnfl))
      write(*,*)'Constraints on wfn                                   '
      CALL CONWFN(nwfnfl,cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn)
      do i=1,nwfnfl
         write(*,*)'# wfn==>',i
         write(*,*)'max amplitude of PW, PSPW, projector' 
         write(*,*)cpwmx(i),cpspwmx(i),cprjmx(i)
         write(*,*)'min amplitude of PW, PSPW, projector'
         write(*,*)cpwmn(i),cpspwmn(i),cprjmn(i)
      enddo
! <====================================================================
      call sep()
! ====================================================================>      
      write(*,*)'User defined Inputs: Based on experience judge inputs '
      call U_inputs(ischm,crpmx,crpmn,crp,f5,istrt,npop,!
     +             wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn,neos,nvpnt)
! <====================================================================
      call sep()
! ====================================================================>
      write(*,*)'Preparing < PARAMETER.H > & < CONSTRAINT.H > '
! *****  Preparing < PARAMETER.H > & < CONSTRAINT.H >                 **
      call heador(ischm,crpmx,crpmn,crp,cwfn,istrt,!
     +             wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn,neos,nky,nvpnt,!
     +             ntot,npw,nen,nps,nwfnfl,nlgfl,nlgline,npop,nop,!
     +             clgotm,clga,cpwmx,cpspwmx,cprjmx,!                 >>
     +             cpwmn,cpspwmn,cprjmn)!                             >>
! <====================================================================
      call sep()
! ====================================================================>  
      write(*,*)'Preparing < ',trim(f4),' > ',' if it does not exist'
      inquire(file=trim(f4),exist=there)
      if (there) then
         write(*,*)
         write(*,*)'>> Careful !!!! Parameters 4 GAs are too sensitive '
         write(*,*)
      else
         write(*,*)'>> < ',trim(f4),' > ','is missing '   
         write(*,*)'>> Starting with default parameter values        <<'
         write(*,*)'>> Careful !!!! Parameters 4 GAs are too sensitive '
         write(*,*)
         call sleep(1)
         open (1,file=trim(f4))
         write(1,'(a)')'#Cross Prob (cp); Max cp (cpmx); Min cp (cpmn)'
         write(1,21)0.7, 0.9, 0.1
         write(1,'(a)')'#Cross Ints (ci); Max ci (cimx); Min ci (cimn)'
         write(1,21)0.6, 0.8, 0.1
         write(1,'(a)')'#Alpha for BLX-alpha crossover'
         write(1,21)0.6        
         write(1,'(a)')'#Mut Prob (pm); Max pm (pmmx); Min pm (pmmn)'
         write(1,21)0.15,0.33,0.1
         write(1,'(a)')'#Mut Ints (dm); Max dm (dmmx); Min dm (dmmn)'
         write(1,*)0.005, 0.2,  1.0E-10
         write(1,'(a)')'#Maximum allowed number of generations(maxgen)'
         write(1,20)200
         write(1,'(a)')'#Intermediate generations for adaptation(ign)'
         write(1,20)10
         write(1,'(a)')'#No. of members in Tournament Selection(ntrn)'
         write(1,20)2
         write(1,'(a)')'#Div. Prob (dp); Max dp (dpmx); Min dp (dpmn)'
         write(1,21)0.05,0.3,0.05
      endif
20    format(I4)
21    format(3F11.7)
      close(1)
! <====================================================================
      call sep()
! ====================================================================>  
      if (istrt.eq.0)then
         write(*,*)'Preparing < ',trim(f3),' > ',' if it does not exist'
         write(*,*)'>> Replicate: starting input to parent           <<'
         write(*,*)'>> Members in starting population are identical  <<'
         write(*,*)
         write(*,*)'Press [CTRL+C] & change (istrt) value in user input'
         write(*,*)'to start with defined parent pool .................'
         write(*,*)
         call sleep(1)
         open (1,file=trim(f3))
         do ipop=1, npop
            do ipw=1,npw
               write(1,21)rpw(ipw)
            enddo
            do ips=1,nps
               write(1,21)rps(ips)
            enddo
            do ien=1,nen
               write(1,21)ren(ien)
            enddo
            write(1,'(a)')'#:<><><><>:<><><><>:<><><><>:'
         enddo
         close(1)
      else
         inquire(file=trim(f3),exist=there)
         if (there) then
            call NROW(f3,irow)!irow=Number of lines in IN_PARENT file
            if(((nop+1)*npop).le.irow)then
               write(*,*)'>> Starting with user-defined parent-pool  <<'
               write(*,*)
            else
               write(*,*)'>> user-defined parent-pool < ',trim(f3),' >'
               write(*,*)'>> has lesser number of entries            <<'
               write(*,*)
               call sleep(15)
               stop
            endif
         endif
      endif

! <====================================================================
      call sep()
! ====================================================================>       
      write(*,*)'Preparing < ',trim(f5),' > ',' if it does not exist'
      write(*,*)'if it is there be careful that it should contain :'
      write(*,*)
      write(*,*)neos,'number of V & P data'
      write(*,*)      
      write(*,*)'if not there be careful - EvsVRyBohr.dat from WIEN2k'
      write(*,*)'or IN_ELAST containing the V0 B0 & Bprime must exist.'
      
      inquire(file=trim(f5),exist=there)
      if (there) then
         write(*,*)' < ',trim(f5),' > ',' exist'
      else
         inquire(file='ev.in',exist=there)
         if (there) then
!           call bm3(neos)
!           WRITE(*,*)'BM3'
            RUN=SYSTEM('python script.py')
            RUN=SYSTEM('mv qerun.out IN_TARGET')
            WRITE(*,*)'pythonscript to EvsVRyBohr.dat'
         else
           inquire(file='IN_ELAST',exist=there)
           if (there) then
             call bm3(neos)
           else
       write(*,*)'>> ERROR: EvsVRyBohr.dat,IN_ELAST,IN_TARGET  missing.'
            write(*,*)'>> UNABLE TO START THE CODE                  <<'
            write(*,*)'>> Press [CTRL+C] to stop..................  <<'
            write(*,*)
             stop         
           endif
         endif
         call sleep(1)
      endif
! <====================================================================
      call sep()
! ====================================================================>        
! *****  mkdir pot$i for QE calculation                              **
      fnma='pot1'
      inquire(file=trim(fnma),exist=there)
      if (there) then
         RUN=SYSTEM('rm -rf pot*')
!         RUN=SYSTEM('for i in `seq 1 10`; do mkdir pot$i; done')
!          write(*,*)         
!      else
!         RUN=SYSTEM('for i in `seq 1 10`; do mkdir pot$i; done')
      endif
!======  ======  ======  ======  ======
      RUN=SYSTEM('cp -f logderiv.0 Further_Continuation')
      WRITE(*,*)'INITIALIZATION ENDS'
      STOP
      END



