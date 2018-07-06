      SUBROUTINE INEVALPRNT(parent,ky,wky,clgotm,clga,
     +              cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,fit,
     +              ntot,nky,npop,nop,nwfnfl,npw,nen,nps,nlgline,nlgfl)
!============================ DECLARATION ==============================
      INTEGER iop,ipop!                                               ||
      INTEGER iky,ien,ips,ipw,iex,iwfn!                               ||
      INTEGER ntot,nky,npop,nop,nwfnfl,npw,nen,nps,nlgline,nlgfl!     ||
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
      CHARACTER(100) wky(nky)!                                        ||
!     DOUBLE PRECISION,ALLOCATABLE :: prmx(:),prmn(:),primn(:)!       %%
      DOUBLE PRECISION crpmxt,crpmnt,crpt!                            ||      
      DOUBLE PRECISION fit(npop)!                                     ||  
!=======================================================================
!       if (istrt.eq.0)then
!       else
!          write(*,*)'KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK' 
        do ipop=1,npop!===================> DO FOR EACH PARENT STRING ***
          do iop=1,nop
            aindv(iop)=parent(ipop,iop)
          enddo 
          do ipw=1,npw
             rpw(ipw)=aindv(ipw)
          enddo      
          do ips=1,nps
             rps(ips)=aindv(npw+ips)
          enddo       
          do ien=1,nen
             ren(ien)=aindv(npw+nps+ien)
          enddo 
20        call write_stndr(ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps) 
          write(*,*)'IN_STANDARD | run atompaw script' 
!           STOP
          RUN=SYSTEM('./APAW.sh')
          write(*,*)'check existence of ghost states'       
          call DSTCNTY(nlgline,nlgfl,iex)
          if (iex.gt.2)then
            write(*,*)'Discontinuity index iex= ',iex
            open(45,file='fortfile',status='old')
            do ipw=1,npw
               read(45,*)rpw(ipw)
            enddo
            do ips=1,nps
               read(45,*)rps(ips)
            enddo
            do ien=1,nen
               read(45,*)ren(ien)
            enddo
            close(45)
            goto 20
!            STOP
          endif         
!      
          write(*,*)'CONSTRAINT PROPERTIES FROM wfn* &'
          CALL CONWFN(nwfnfl,dpwmx,dpspwmx,dprjmx,dpwmn,dpspwmn,dprjmn)
          CALL INTGPAW(nlgline,nlgfl,dlgotm,dlga)
          write(*,*)dlgotm,clgotm
          fit(ipop)=dlgotm 
          if(dlgotm.gt.(1.20d0*clgotm))then
             WRITE(*,*)ipop,'dlgotm > 1.2*clgotm, Not obeying logderiv'
             WRITE(*,*)ipop, dlgotm,clgotm         
             open(45,file='fortfile',status='old')
             do ipw=1,npw
                read(45,*)rpw(ipw)
             enddo
             do ips=1,nps
                read(45,*)rps(ips)
             enddo
             do ien=1,nen
                read(45,*)ren(ien)
             enddo
             close(45)
             goto 20
!             STOP!                                        :UNCOMMENT
          endif
          CALL     WFNCNSTRNT(cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,
     \                        dpwmx,dpspwmx,dprjmx,dpwmn,dpspwmn,dprjmn,
     \                        nwfnfl,wtwfn,iwfn) 
          write(*,*)iwfn,'iwfn'
          if(iwfn.gt.0)then
             WRITE(*,*)ipop,'th soln: WFN Constraints are not satisfied'
             if(iwfn.gt.0)then
               open(45,file='fortfile',status='old')
               do ipw=1,npw
                  read(45,*)rpw(ipw)
               enddo
               do ips=1,nps
                  read(45,*)rps(ips)
               enddo
               do ien=1,nen
                  read(45,*)ren(ien)
               enddo
               close(45)
               goto 20
             endif
!             STOP!                                        :UNCOMMENT
          endif 
          write(*,*)ipop,'ipop',dlgotm
        enddo!<============================== ENDDO FOR EACH PARENT STRING ***
!       endif
! <====================================================================
               open(45,file='fortfile',status='old')
               close(45,status='delete')
        call sep()
! ====================================================================>  
      return
      end
