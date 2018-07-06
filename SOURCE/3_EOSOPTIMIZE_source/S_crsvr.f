*====================== CROSSOVER SCHEMES ======================IN USE====
!|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|*|
*=========================================================================
      subroutine crossover(nop,npop,fit,poolm,cp,ci,alpha)
      implicit none
      integer itag,iop,ipop,nop,npop
      integer ipk1,ipk2,idum,ISEED,iflip
      double precision cp,ci,alpha,p(2,nop),epsln,df
      double precision fit(npop),poolm(npop,nop),pool(npop,nop)
      real*4 rand
      common/ide/idum
      itag=0
      epsln=0.001d0
      do ipop=1,2*npop
        if(iflip(cp) .eq. 1) then
          itag=itag+1
          call SIRAND(npop,1,ipk1)
 5        call SIRAND(npop,1,ipk2)
          if (ipk1.eq.ipk2)goto 5
!          write (*,*)ipk1,ipk2
          do iop=1,nop
            p(1,iop)=poolm(ipk1,iop)
            p(2,iop)=poolm(ipk2,iop)
          enddo
          df=dabs(fit(ipk1)-fit(ipk2))
          if (df.gt.epsln)then
!            write(*,*)ipk1,ipk2,'SPACROSS'
            call SPACROSS(nop,ci,p)
          else
!            write(*,*)ipk1,ipk2,'BLX'
            call BLXCROSS(nop,alpha,p)
          endif
          do iop=1,nop
            pool(itag,iop)=p(1,iop)
          enddo
            itag=itag+1
          do iop=1,nop
            pool(itag,iop)=p(2,iop)
          enddo
          !write(*,*)'itag',itag
          if(itag.ge.npop)goto 11
        endif
      enddo
      if(itag.lt.npop)then
        do ipop=itag+1,npop
           call SIRAND(npop,1,ipk1)
           do iop=1,nop
              pool(ipop,iop)=poolm(ipk1,iop)
           enddo
        enddo
      endif
 11   do ipop=1,npop
         do iop=1,nop
            poolm(ipop,iop)=pool(ipop,iop)
         enddo
      enddo
      return
      end