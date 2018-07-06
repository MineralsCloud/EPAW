      SUBROUTINE EVALPRNT(parent,ky,wky,clgotm,clga,crpmx,crpmn,crp,
     +        wtwfn,cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,nvpnt,
     +         ncns,ntot,nky,npop,nop,nwfnfl,npw,nen,nps,nlgline,nlgfl)
!============================ DECLARATION ==============================
      IMPLICIT NONE
      INTEGER i,iop,ipop,newcnt!                                        ||
      INTEGER iky,ien,ips,ipw,iex,iwfn,nvpnt,itemp,irow!              ||
      INTEGER ntot,nky,npop,nop,nwfnfl,npw,nen,nps,nlgline,nlgfl,ncns!||
      INTEGER ky(ntot)!                                               ||      
      DOUBLE PRECISION aindv(nop)!                                    ||
      DOUBLE PRECISION parent(npop,nop)!                              ||
      DOUBLE PRECISION rpw(npw),ren(nen),rps(nps)!                    ||
      DOUBLE PRECISION RUN,SYSTEM!                                    ||
      DOUBLE PRECISION clgotm,clga!                                   ||      
      DOUBLE PRECISION dlgotm,dlga!                                   ||
      DOUBLE PRECISION cpwmx(nwfnfl),cpspwmx(nwfnfl),cprjmx(nwfnfl)!  ||
      DOUBLE PRECISION cpwmn(nwfnfl),cpspwmn(nwfnfl),cprjmn(nwfnfl)!  ||      
      DOUBLE PRECISION dpwmx(nwfnfl),dpspwmx(nwfnfl),dprjmx(nwfnfl)!  ||
      DOUBLE PRECISION dpwmn(nwfnfl),dpspwmn(nwfnfl),dprjmn(nwfnfl)!  ||
      DOUBLE PRECISION crpmx,crpmn,crp!                               ||
      DOUBLE PRECISION wtwfn!                                         ||
      DOUBLE PRECISION engr1,engr2              !                     ||
      CHARACTER(100) wky(nky)!                                        ||
      CHARACTER*256 cna,cnb!                                          ||      
      LOGICAL there!                                                  %%
!=======================================================================
      do ipop=1,npop!========================> DO FOR EACH PARENT STRING ***
!        if(istrt.eq.0)goto 10
        do iop=1,nop
           aindv(iop)=parent(ipop,iop)
        enddo
        call CHKINTL(ipop,nop,ncns,aindv,crpmx,crpmn,crp)
        write(*,*)ipop,'th solution string obeys RPAW constraints'
!        
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
        write(*,*)'IN_STANDARD | run atompaw script'
        RUN=SYSTEM('./APAW.sh')
!        
        write(*,*)'check existence of ghost states'       
        call DSTCNTY(nlgline,nlgfl,iex)
        if (iex.gt.2)then
          write(*,*)'Discontinuity index iex= ',iex
!          STOP
        endif
!      
        write(*,*)'CONSTRAINT PROPERTIES FROM wfn* &'
        CALL CONWFN(nwfnfl,dpwmx,dpspwmx,dprjmx,dpwmn,dpspwmn,dprjmn)
        CALL INTGPAW(nlgline,nlgfl,dlgotm,dlga)
        if(dlgotm.gt.clgotm)then
           WRITE(*,*)ipop,'dlgotm > clgotm, Not obeying logderiv'
           WRITE(*,*)ipop, dlgotm,clgotm         
!           STOP!                                        :UNCOMMENT
        endif
        CALL     WFNCNSTRNT(cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,
     \                      dpwmx,dpspwmx,dprjmx,dpwmn,dpspwmn,dprjmn,
     \                      nwfnfl,wtwfn,iwfn) 
        write(*,*)iwfn,'iwfn'
        if(iwfn.gt.0)then
           WRITE(*,*)ipop,'th soln: WFN Constraints are not satisfied'
!           STOP!                                        :UNCOMMENT
        endif    
!
10      if(ipop.lt.10)then
          write(cna,FMT="(I1)")ipop
        elseif(ipop.lt.100)then
          write(cna,FMT="(I2)")ipop
        endif
        open(1,file='copyfile.sh',status='unknown')
        rewind(1)
        RUN=SYSTEM('chmod 777 copyfile.sh')
        RUN=SYSTEM('cp -f *paw.UPF epaw.UPF')
!        cnb='cp -f *-paw* pot'//trim(cna)
        cnb='cp -f epaw.UPF pot'//trim(cna)
        write(1,'(a)')trim(cnb)
        write(*,*)'Place: ' , trim(cnb)           
        close(1)
        RUN=SYSTEM('./copyfile.sh')
        RUN=SYSTEM('rm epaw.UPF')    
      enddo!<============================== ENDDO FOR EACH PARENT STRING *** 
!         STOP 
! <====================================================================
        call sep()
        call sleep(2)
! ====================================================================> 
      write(*,*)'Run Quantum Espresso Script '        
      RUN=SYSTEM('rm pot*/ev.in')
      RUN=SYSTEM('rm pot*/qerun.out')
      RUN=SYSTEM('python runQE.py')
!      call QESPRS()
!       newcnt=newcnt+1
!       do ipop=1,npop
!         if(ipop.lt.10)then
!           write(cna,FMT="(I1)")ipop
!         elseif(ipop.lt.100)then
!           write(cna,FMT="(I2)")ipop
!         endif
! 65      cnb='pot'//trim(cna)//'/EvsVRyBohr.dat'
!         inquire(file=trim(cnb),exist=there)
!         if (there) then
!           write(*,*)'qerun exist for',ipop
! !          RUN=SYSTEM('rm tempfile')
!         else
!                 newcnt=newcnt+1
!                 call sleep(1)
!                 if(newcnt.lt.300)then
!                   goto 65
!                 endif
!                 newcnt=0
!            cnb='pot'//trim(cna)//'__ABI_MPIABORTFILE__'
!            inquire(file=trim(cnb),exist=there)
!                if (there)then 
!                   goto 64
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
!                     read (1,*, END=11)
!                     irow = irow + 1
!                   enddo
! 11                rewind(1)
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
!                   if (dabs(engr1-engr2).gt.3.0d0)goto 64
! !                  RUN=SYSTEM('./terminate.sh')
! !                  cnb='pot'//trim(cna)//'__ABI_MPIABORTFILE__'
! !                  inquire(file=trim(cnb),exist=there)
!                    newcnt=newcnt+1
!                    call sleep(1)
!                    if(newcnt.eq.300)then
!                      newcnt=0
!                     goto 64
!                   endif
!                endif
!            call sleep(5)
!            goto 65
!         endif
! 64      write(*,*)ipop,'MPI ABORT'
!       enddo
!       RUN=SYSTEM('rm pot*/JOB-*')
!       RUN=SYSTEM('rm pot*/*.o_DS*')
!       RUN=SYSTEM('rm pot*/*paw.abinit')
!      itemp=nvpnt*2*npop
!70    RUN=SYSTEM('./check.sh')
!      open(1,file='checkbatchjob',status='unknown')      
!      cnb='checkbatchjob'
!      rewind(1)
!      call NROW(cnb,irow)
!      write(*,*)'irow=itemp'
!      write(*,*)irow,itemp
!      if(irow.eq.itemp)then
!        close(1,status='delete')
!        goto 69
!      else
!        write(*,*)'BATCH NOT COMPLETED'
!        call sleep(2)
!        close(1,status='delete')
!        goto 70
!      endif
!69    write(*,*)'BATCH COMPLETED'
!!      RUN=SYSTEM('rm checkbatchjob')
!!      RUN=SYSTEM('ls checkbatchjob')
!!      STOP
!!      RUN=SYSTEM('for i in `seq 1 10`; do cp ev.in pot$i; done')    
!      do ipop=1,npop
!        if(ipop.lt.10)then
!          write(cna,FMT="(I1)")ipop
!        elseif(ipop.lt.100)then
!          write(cna,FMT="(I2)")ipop
!        endif
!        cnb='pot'//trim(cna)//'/Li2O.out'
!        call getVolvsEngfromabinit(ipop,cnb)
!!        cnb='pot'//trim(cna)//'/EvsVRyBohr.dat'
!!        call Genbm3EOS(neos,cnb,Vmin,Vmax)
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
!      STOP
      return
      end
