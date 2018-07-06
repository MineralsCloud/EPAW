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
!      +                 istrt,nwfnfl,nlgfl,nlgline,npop,n2pop,
!      +                 nky,neos,npw,nps,nen,nvpnt,
!      +                 cwfn,crpmx,crpmn,crp,
!      +                 wtp_ext,wtp_h,wtp_m,wtp_l,
!      +                 wtwfn)
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
!      +             ky,wky,rpw,ren,rps,E0w,V0w,B0w,B0pw,avol,aprs,
!      +             maxgen,ign,ntrn,cp,cpmx,cpmn,ci,cimx,cimn,alpha,
!      +             pm,pmmx,pmmn,pi,pimx,pimn,clgotm,clga,cpwmx,
!      +             cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,prnt,
!      +             Vmin,Vmax,crpmx,crpmn,crp,wtp_ext,wtp_h,wtp_m,wtp_l,
!      +             ischm,istrt,wtwfn,nvpnt,prmx,prmn,primn)     
! <==================================================================== 
      WRITE(*,*)'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~PARENT EVALUATION'
      call sep()
! ====================================================================> 
      allocate (fit(npop)       )
      allocate (aindv(nop)      )
      if (istrt.eq.1)goto 97
      do ipop=1,npop
          fit(ipop)=0.0d0
          do iop=1,nop
            aindv(iop)=prnt(ipop,iop)
          enddo
          crpmxt=prmx(ipop)
          crpmnt=prmn(ipop)
          crpt=primn(ipop)
          call CONINTL(ipop,nop,ncns,aindv,crpmxt,crpmnt,crpt)
          do iop=1,nop
             prnt(ipop,iop)=aindv(iop)
          enddo
      enddo
97    call INEVALPRNT(prnt,ky,wky,clgotm,clga,
     +              cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,cprjmn,fit,
     +              ntot,nky,npop,nop,nwfnfl,npw,nen,nps,nlgline,nlgfl)
      write(*,*) 'ipop,fit(ipop)'
      write(*,*) ipop,fit(ipop)
      do ipop=1,npop
         write(*,*) ipop,fit(ipop)
      enddo
! <==================================================================== 
      WRITE(*,*)'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~WRITING INFORMATION'
      call sep()
! ====================================================================> 
      allocate (ic(npop)        )
      allocate (probm(npop)     )
      allocate (aintm(npop)     )
      OPEN(81,file='log_EVOLFITNESS',status='unknown',access='append')
      OPEN(83,file='log_ARCHV',status='unknown')
      OPEN(84,file='log_EVOLPROB',status='unknown',access='append')
      OPEN(85,file='log_EVOLINTNSTY',status='unknown',access='append')
      write(81,*)'# Starting fitness=',clgotm
      write(81,*)'# GENERATION, (fit(ipop),ipop=1,',npop, ')'
      write(81,20)0,(fit(ipop),ipop=1,npop)
      rewind(83)
      do ipop=1,npop
          write(83,21)(prnt(ipop,iop),iop=1,npw)
          do iop=npw+1,nop
             write(83,21)prnt(ipop,iop)
          enddo
          write(83,*)ipop,'# Fitness=',fit(ipop)
          ic(ipop)=0
          probm(ipop)=cp
          aintm(ipop)=pi
      enddo
      write(84,*)'# GENERATION, (probm(ipop),ipop=1,',npop, ')'
      write(84,20)0,(probm(ipop),ipop=1,npop)
      write(85,*)'# GENERATION, (aintm(ipop),ipop=1,',npop, ')'
      write(85,20)0,(aintm(ipop),ipop=1,npop)
20    format(I7,20F15.7)
21    format(5F15.7)

!      STOP
!=======================================================================
!========================= CARMHC  ALGORITHMS ==========================
!=======================================================================
       allocate ( farea(npop)    )
       allocate (fotm(npop)      )
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
       allocate (poolm(npop,nop) )
       allocate (iselect(npop)   )
       allocate (fitsl(npop)     )

      do igen=1,maxgen
         RUN=SYSTEM('rm -rf wfn*')      
         RUN=SYSTEM('rm -rf logderiv.*') 
         ic=0
        do ipop=1,npop
           fitsl(ipop)=fit(ipop)
           do iop=1,nop
              poolm(ipop,iop)=prnt(ipop,iop)
           enddo
        enddo        
!________________________________________________
          do ipop=1,npop
76          do iop=1,nop
               aindv(iop)=poolm(ipop,iop)
            enddo
            pm=probm(ipop)
            pi=aintm(ipop)
            call SMPMUT(nop,pm,pi,aindv)
            crpmxt=prmx(ipop)
            crpmnt=prmn(ipop)
            crpt=primn(ipop)            
            call CHKINDV(nop,ncns,aindv,crpmxt,crpmnt,crpt)
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
            if (iex.gt.2)then
              goto 76
            else
               CALL INTGPAW(nlgline,nlgfl,dlgotm,dlga)
               if(dlgotm.lt.fit(ipop))then
                  CALL CONWFN(nwfnfl,dpwmx,dpspwmx,dprjmx,dpwmn,
     +                        dpspwmn,dprjmn)
                  CALL WFNCNSTRNT(cpwmx,cpspwmx,cprjmx,cpwmn,cpspwmn,
     +                            cprjmn,dpwmx,dpspwmx,dprjmx,dpwmn,
     +                            dpspwmn,dprjmn,nwfnfl,wtwfn,iwfn)
                  if(iwfn.ge.1)then
                    goto 76
                  else
                    fit(ipop)=dlgotm
                    do iop=1,nop
                      prnt(ipop,iop)=aindv(iop)
                    enddo
                    ic(ipop)=ic(ipop)+1
                    Write(*,*)'here',ipop,fit(ipop),prnt(ipop,1)
                  endif               
               endif
            endif
          enddo         
          write(*,*)'Generation=',igen,'#Fitness & avg =',fit(1),avgfit
! ADAPTIVE MUTATION
       if(mod(igen,ign).eq.0)then
         do ipop=1,npop
           ratio=dfloat(ic(ipop))/dfloat(ign)
c           write(*,*)'ratio',ratio
           if(ratio.lt.0.1d0)then
            aintm(ipop)=aintm(ipop)/(1+bm1(idum))
            probm(ipop)=probm(ipop)/(1+rand(idum)*rand(idum))
           elseif(ratio.gt.0.2d0)then
            aintm(ipop)=aintm(ipop)*(1+bm1(idum))
            probm(ipop)=probm(ipop)*(1+rand(idum)*rand(idum))
           endif
           ic(ipop)=0
           if(aintm(ipop).gt.pimx)aintm(ipop)=pimx
           if(aintm(ipop).lt.pimn)aintm(ipop)=pimn
           if(probm(ipop).gt.pmmx)probm(ipop)=cpmx
           if(probm(ipop).lt.pmmn)probm(ipop)=cpmn           
         enddo
          write(84,20)0,(probm(ipop),ipop=1,npop)
          write(85,20)0,(aintm(ipop),ipop=1,npop)
       endif
!________________________________________________Output Files         
          write(81,20)igen,(fit(ipop),ipop=1,npop)
          rewind(83)         
          do ipop=1,npop
              write(83,21)(prnt(ipop,iop),iop=1,npw)
              call flush(83)
              do iop=npw+1,nop
                 write(83,21)prnt(ipop,iop)
                  call flush(83)
              enddo
              write(83,*)ipop,'# Fitness=',fit(ipop)
              write(*,*)ipop,'# Fitness=',fit(ipop)
              write(*,21)(prnt(ipop,iop),iop=1,npw)
              call flush(83)
          enddo
!   
! 
          call sleep(1)
      enddo
      STOP
      END
