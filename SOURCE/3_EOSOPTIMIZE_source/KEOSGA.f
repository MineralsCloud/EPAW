           include 'DECLARATION.H'           
!============================ =========== ==============================
!=========================== INITIALIZATION ============================
!============================ =========== ==============================
! <==================================================================== 
      WRITE(*,*)'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~READING PARAMETERS'
      call sep()
! ====================================================================> 
      call READPARAMS(ischm,ntot,nop,ncns,
     +                 istrt,nwfnfl,nlgfl,nlgline,npop,n2pop,
     +                 nky,neos,npw,nps,nen,nvpnt,
     +                 cwfn,crpmx,crpmn,crp,
     +                 wtp_ext,wtp_h,wtp_m,wtp_l,
     +                 wtwfn)
!! COMMENT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CHECKING PARAMETERS READING 
!       call WRITEPARAMS(ischm,ntot,nop,ncns,
!     +                 istrt,nwfnfl,nlgfl,nlgline,npop,n2pop,
!     +                 nky,neos,npw,nps,nen,nvpnt,
!     +                 cwfn,crpmx,crpmn,crp,
!     +                 wtp_ext,wtp_h,wtp_m,wtp_l,
!     +                 wtwfn)
! <==================================================================== 
      WRITE(*,*)'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~READING INPUTS'
      call sep()
! ====================================================================> 
      allocate ( ky(ntot)      )
      allocate ( wky(nky)      )
      allocate ( rpw(npw)      )
      allocate ( ren(nen)      )
      allocate ( rps(nps)      )
      allocate (avol(neos)     )
      allocate (aprs(neos)     )
      allocate (cpwmx(nwfnfl)  )
      allocate (cpspwmx(nwfnfl))      
      allocate (cprjmx(nwfnfl) )      
      allocate (cpwmn(nwfnfl)  )      
      allocate (cpspwmn(nwfnfl))      
      allocate (cprjmn(nwfnfl) )
      allocate (prnt(npop,nop) )
      allocate (prmx(npop)     )
      allocate (prmn(npop)     )
      allocate (primn(npop)    )       
      call RINPUTS(ntot,nky,npop,nop,nwfnfl,npw,nen,nps,neos,
     +             ky,wky,rpw,ren,rps,E0w,V0w,B0w,B0pw,avol,aprs,
     +             maxgen,ign,ntrn,cp,cpmx,cpmn,ci,cimx,cimn,alpha,
     +             pm,pmmx,pmmn,pi,pimx,pimn,clgotm,clga,cpwmx,
     +             cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,prnt,
     +             Vmin,Vmax,crpmx,crpmn,crp,wtp_ext,wtp_h,wtp_m,wtp_l,
     +             ischm,istrt,wtwfn,nvpnt,prmx,prmn,primn)
!        call CHINPUTS(ntot,nky,npop,nop,nwfnfl,npw,nen,nps,neos,
!     +             ky,wky,rpw,ren,rps,E0w,V0w,B0w,B0pw,avol,aprs,
!     +             maxgen,ign,ntrn,cp,cpmx,cpmn,ci,cimx,cimn,alpha,
!     +             pm,pmmx,pmmn,pi,pimx,pimn,clgotm,clga,cpwmx,
!     +             cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,prnt,
!     +             Vmin,Vmax,crpmx,crpmn,crp,wtp_ext,wtp_h,wtp_m,wtp_l,
!     +             ischm,istrt,wtwfn,nvpnt,prmx,prmn,primn)     
! <==================================================================== 
      WRITE(*,*)'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~PARENT EVALUATION'
      call sep()
      call EVALPRNT(prnt,ky,wky,clgotm,clga,crpmx,crpmn,crp,
     +        wtwfn,cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,nvpnt,
     +         ncns,ntot,nky,npop,nop,nwfnfl,npw,nen,nps,nlgline,nlgfl)
!      STOP
! ====================================================================> 
      allocate (fit(npop)       )
      allocate (fotm(npop)      )
      allocate (farea(npop)     )
      allocate (aindv(nop)      )
      call C_Simps(neos,avol,aprs,areap)
      if(ischm.eq.0)call FITEOS(npop,neos,wtp_ext,wtp_h,wtp_m,wtp_l,
     +                  areap,avol,aprs,fotm,farea)
!     ! if(ischm.eq.1)call FITBULK(npop,fitb)
      avgfit=0.0d0
      do ipop=1,npop
          fit(ipop)=fotm(ipop)
!          write(*,*)ipop,'RAW fitness=',fit(ipop),prnt(ipop,1)
          avgfit=avgfit+fit(ipop)
      enddo
      avgfit=avgfit/npop
!      write(*,*)'AVG fitness=',avgfit
!OUTPUTFILES
      OPEN(81,file='O_EVOLFITNESS',status='unknown',access='append')
      OPEN(82,file='O_SUPERINDV',status='unknown',access='append')!||
      OPEN(83,file='O_ARCHV',status='unknown')!     ||
      rewind(81)
      rewind(82)
      rewind(83)
      write(81,*)'# GENERATION, (fit(ipop),ipop=1,',npop, 'avg fitness'
      write(82,*)'# GENERATION, fitness, (Superindividual,iop=1,',nop
!      call SORTARAY(npop,nop,fit,prnt,ipid)
!      call place(ipid)
      do ipop=1,npop
!          write(*,*)ipop,'SORTED fitness=',fit(ipop),prnt(ipop,1)
          write(83,21)(prnt(ipop,iop),iop=1,npw)
          do iop=npw+1,nop
             write(83,21)prnt(ipop,iop)
          enddo
          write(83,*)ipop,'# Fitness=',fit(ipop)
      enddo
      write(81,20)0,(fit(ipop),ipop=1,npop),avgfit
      write(82,20)0,fit(1),(prnt(1,iop),iop=1,nop)
20    format(I7,20F15.7)
21    format(5F15.7)
      fittest=fit(1)
!       RUN=SYSTEM('rm pot*/*.out*')
!      STOP
      RUN=SYSTEM('./replace.sh')
! <===================================================================== 
!=======================================================================
!========================= GENETIC ALGORITHMS ==========================
!=======================================================================
       allocate (iselect(npop)   )
       allocate (fitsl(npop)     )
       allocate (poolm(npop,nop) )
       allocate (fito(npop)      )
       allocate (arcfit(n2pop)   )
       allocate (archv(n2pop,nop))
       allocate (dpwmx(nwfnfl)   )
       allocate (dpspwmx(nwfnfl) )
       allocate (dprjmx(nwfnfl)  )
       allocate (dpwmn(nwfnfl)   )
       allocate (dpspwmn(nwfnfl) )
       allocate (dprjmn(nwfnfl)  )
       allocate (offspr(npop,nop))
      do igen=1,maxgen
         RUN=SYSTEM('rm -rf pot*/*.UPF')      
         ic=0
! MATING POOL      
76      call TOURNMNT(ntrn,npop,fit,iselect)
        fitsl(1)=fit(1)
        do iop=1,nop
           poolm(1,iop)=prnt(1,iop)
        enddo
        do ipop=1,npop-1
           iky=iselect(ipop)
           fitsl(ipop+1)=fit(iky)
           do iop=1,nop
              poolm(ipop+1,iop)=prnt(iky,iop)
           enddo
        enddo
!         do ipop=1,npop
!            write(*,21)(poolm(ipop,iop),iop=1,npw)
!            do iop=npw+1,nop
!               write(*,21)poolm(ipop,iop)
!            enddo
!            write(*,*)ipop,'# Fitness=',fitsl(ipop)
!         enddo          
        call crossover(nop,npop,fitsl,poolm,cp,ci,alpha)
!         do ipop=1,npop
!            write(*,21)(poolm(ipop,iop),iop=1,npw)
!            do iop=npw+1,nop
!               write(*,21)poolm(ipop,iop)
!            enddo
!            write(*,*)ipop,'# Fitness=',fitsl(ipop)
!         enddo 
        call MPMUT(npop,nop,pm,pi,poolm)
!         do ipop=1,npop
!            write(*,21)(poolm(ipop,iop),iop=1,npw)
!            do iop=npw+1,nop
!               write(*,21)poolm(ipop,iop)
!            enddo
!            write(*,*)ipop,'# Fitness=',fitsl(ipop)
!         enddo
!________________________________________________PREPARATION to RUN QE
          do ipop=1,npop
            do iop=1,nop
               aindv(iop)=poolm(ipop,iop)
            enddo
            call CHKINDV(nop,ncns,aindv,crpmx,crpmn,crp)
            do ipw=1,npw
               rpw(ipw)=aindv(ipw)
            enddo
            do ips=1,nps
               rps(ips)=aindv(npw+ips)
            enddo
            do ien=1,nen
               ren(ien)=aindv(npw+nps+ien)
            enddo 
            call write_stndr(ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)
            RUN=SYSTEM('./APAW.sh')
            call DSTCNTY(nlgline,nlgfl,iex)
            if (iex.le.2)then
               CALL INTGPAW(nlgline,nlgfl,dlgotm,dlga)
               if(dlgotm.lt.clgotm)then
                  CALL CONWFN(nwfnfl,dpwmx,dpspwmx,dprjmx,dpwmn,
     +                        dpspwmn,dprjmn)
                  CALL WFNCNSTRNT(cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,
     +                            cprjmn,dpwmx,dpspwmx,dprjmx,dpwmn,
     +                            dpspwmn,dprjmn,nwfnfl,wtwfn,iwfn)
                  if(iwfn.eq.0)then
                    ic=ic+1
                    do iop=1,nop
                      offspr(ic,iop)=aindv(iop)
                    enddo
                    if(ic.lt.10)then
                      write(cna,FMT="(I1)")ic
                    elseif(ic.lt.100)then
                      write(cna,FMT="(I2)")ic
                    endif
                    open(1,file='copyfile.sh',status='unknown')
                    rewind(1)
                    !RUN=SYSTEM('chmod 777 copyfile.sh')
                    RUN=SYSTEM('cp -f *paw.UPF epaw.UPF')
                    cnb='cp -f *paw.UPF pot'//trim(cna)
                    write(1,'(a)')trim(cnb)
!                    write(*,'(a)')trim(cnb)
                    close(1)
                    RUN=SYSTEM('./copyfile.sh')
                    RUN=SYSTEM('rm epaw.UPF') 
                  endif               
               endif
            endif
            if (ic.eq.npop)goto 77           
          enddo
          if (ic.lt.npop)goto 76         
! 77        RUN=SYSTEM('rm pot*/EvsVRyBohr.dat')
!           RUN=SYSTEM('rm pot*/*MPIABORTFILE*')
77        call sleep(1)
!           call QESPRS()
          RUN=SYSTEM('python runQE.py')         
!           newcnt=0
!           do ipop=1,npop
!             if(ipop.lt.10)then
!               write(cna,FMT="(I1)")ipop
!             elseif(ipop.lt.100)then
!               write(cna,FMT="(I2)")ipop
!             endif
! 63          cnb='pot'//trim(cna)//'/EvsVRyBohr.dat'
!             inquire(file=trim(cnb),exist=there)
!             if (there) then
!                write(*,*)'qerun exist for',ipop
!             else
!                 newcnt=newcnt+1
!                 call sleep(1)
!                 if(newcnt.lt.300)then
!                   goto 63
!                 endif
!                 newcnt=0
!                cnb='pot'//trim(cna)//'__ABI_MPIABORTFILE__'
!                inquire(file=trim(cnb),exist=there)
!                if (there)then 
!                   goto 61
!                else
! !                  RUN=SYSTEM('./terminate.sh')
!                   open(1,file='copyfile.sh',status='unknown')
!                   rewind(1)
!                   cnb='cd pot'//trim(cna)
!                   write(1,'(a)')trim(cnb)
!                   write(1,'(a)')'./terminate.sh'
!                   write(1,'(a)')'cd ..'
!                   close(1)
!                   RUN=SYSTEM('./copyfile.sh')
!                   cnb='pot'//trim(cna)//'/termin'
!                   open(1,file=trim(cnb),status='old')
!                   irow = 0
!                   do
!                     read (1,*, END=10)
!                     irow = irow + 1
!                   enddo
! 10                rewind(1)
!                   engr1=0.0
!                   engr2=0.0
!                   if (irow.gt.100)then
!                     rewind(1)
!                     do i=1,98
!                        read(1,*)
!                     enddo 
!                     read(1,*)itemp,engr1
!                     read(1,*)itemp,engr2
!                   endif
!                   close(1)
!                   if (dabs(engr1-engr2).gt.3.0d0)goto 61
! !                  RUN=SYSTEM('./terminate.sh')
! !                  cnb='pot'//trim(cna)//'__ABI_MPIABORTFILE__'
! !                  inquire(file=trim(cnb),exist=there)
!                    newcnt=newcnt+1
!                    call sleep(1)
!                    if(newcnt.eq.300)then
!                      newcnt=0
!                     goto 61
!                   endif
!                endif
!                call sleep(5)
!                goto 63
!             endif
! 61          write(*,*)ipop,'MPI ABORT'
!           enddo
!           RUN=SYSTEM('rm pot*/JOB-*')
!           RUN=SYSTEM('rm pot*/*.o_DS*')
!           RUN=SYSTEM('rm pot*/*paw.abinit')
!________________________________________________FITNESS EVALUATION 
!64    inquire(file='tempfile',exist=there)
!      if (there) then
!        call sleep(2)
!        RUN=SYSTEM('rm tempfile')
!      else
!         call sleep(5)
!         goto 64
!      endif
!      RUN=SYSTEM('rm pot*/JOB-*')
!      RUN=SYSTEM('rm pot*/*.o_DS*')
!      RUN=SYSTEM('rm pot*/*paw.abinit')
!      itemp=nvpnt*2*npop
!      RUN=SYSTEM('rm pot*/EvsV*.dat')
!70    RUN=SYSTEM('./check.sh')
!      RUN=SYSTEM('ls checkbatchjob')
!      open(1,file='checkbatchjob',status='old')
!      irow = 0
!      do
!        read (1,*, END=10)
!        irow = irow + 1
!      enddo
!10    rewind(1)
!!      cna='checkbatchjob'
!!      cnb=trim(cna)
!!      rewind(1)
!!      call NROW(cnb,irow)
!!      write(*,*)cnb
!      write(*,*)irow,itemp
!      call sleep(2)
!!      STOP
!      if(irow.eq.itemp)then
!        close(1,status='delete')
!        goto 69
!      else
!        write(*,*)'BATCH NOT COMPLETED COMPLETED'
!        call sleep(2)
!        close(1,status='delete')
!        goto 70
!      endif
!69    write(*,*)'BATCH COMPLETED'
!!      STOP
!      do ipop=1,npop
!        if(ipop.lt.10)then
!          write(cna,FMT="(I1)")ipop
!        elseif(ipop.lt.100)then
!          write(cna,FMT="(I2)")ipop
!        endif
!        cnb='pot'//trim(cna)//'/Li2O.out'
!        call getVolvsEngfromabinit(ipop,cnb)
!      enddo
!        open(1,file='copyfile.sh',status='unknown')
!        rewind(1)
!        write(1,'(a)')'cd pot1;'
!        write(1,'(a)')'python script.py;'
!        write(1,'(a)')'for i in `seq 2 10`; do'
!        write(1,'(a)')'cd ../pot$i;'
!        write(1,'(a)')'python script.py;'
!        write(1,'(a)')'done'
!        write(1,'(a)')'cd ..'
!        close(1)
!        RUN=SYSTEM('./copyfile.sh')
!________________________________________________
          if(ischm.eq.0)call FITEOS(npop,neos,wtp_ext,wtp_h,wtp_m,wtp_l,
     +                  areap,avol,aprs,fotm,farea)
!     !   if(ischm.eq.1)call FITBULK(npop,fitb)     
          do ipop=1,npop
             fito(ipop)=fotm(ipop)
             if(fito(ipop).le.fittest)then!Place best individual if better
                itag=ipop
                fittest=fito(ipop)
                call place(itag)
             endif
          enddo
!________________________________________________ARCHIVE         
          do ipop=1,npop
            arcfit(ipop)=fit(ipop)
            do iop=1,nop
              archv(ipop,iop)=prnt(ipop,iop)
            enddo
            arcfit(npop+ipop)=fito(ipop)
            do iop=1,nop
              archv(npop+ipop,iop)=offspr(ipop,iop)
            enddo
          enddo         
          call SORTARAY(n2pop,nop,arcfit,archv,ipid)
!________________________________________________new parents
          avgfit=0.0d0
          do ipop=1,npop
            fit(ipop)=arcfit(ipop)
            avgfit=avgfit+fito(ipop)
            do iop=1,nop
              prnt(ipop,iop)=archv(ipop,iop)
            enddo
          enddo
          avgfit=avgfit/npop          
!________________________________________________Output Files         
          write(81,20)igen,(fit(ipop),ipop=1,npop),avgfit         
          write(82,20)igen,fit(1),(prnt(1,iop),iop=1,nop) 
          rewind(83)         
          do ipop=1,npop
              write(83,21)(prnt(ipop,iop),iop=1,npw)
              do iop=npw+1,nop
                 write(83,21)prnt(ipop,iop)
              enddo
              write(83,*)ipop,'# Fitness=',fit(ipop)
          enddo
!   
! 
          write(*,*)'Generation=',igen,'#Fitness & avg =',fit(1),avgfit
!          STOP
          call sleep(1)
          RUN=SYSTEM('rm pot*/*.out*')
      enddo
! ====================================================================== 
! ======================================================================
      stop
      end
