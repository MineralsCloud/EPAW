!=========================== SUBROUTINE U11 ============================
      SUBROUTINE heador(ischm,crpmx,crpmn,crp,cwfn,istrt,!            >>
     +             wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn,neos,nky,nvpnt,!   >>
     +             ntot,npw,nen,nps,nwfnfl,nlgfl,nlgline,npop,nop,!   >>
     +             clgotm,clga,cpwmx,cpspwmx,cprjmx,!                 >>
     +             cpwmn,cpspwmn,cprjmn)!                             >>
      IMPLICIT NONE!                                                  >>
      INTEGER i,ischm,neos,nky,istrt!                                 >>
      INTEGER ntot,npw,nen,nps,nwfnfl,nlgfl,nlgline,npop,nop,nvpnt!   >>
      DOUBLE PRECISION crpmx,crpmn,crp,cwfn!                          >>
      DOUBLE PRECISION wtp_ext,wtp_h,wtp_m,wtp_l,wtwfn!               >>
      DOUBLE PRECISION cpwmx(nwfnfl),cpspwmx(nwfnfl),cprjmx(nwfnfl)!  >>
      DOUBLE PRECISION cpwmn(nwfnfl),cpspwmn(nwfnfl),cprjmn(nwfnfl)!  >>
      DOUBLE PRECISION clgotm,clga!                                   >>
      DOUBLE PRECISION RUN,SYSTEM!                                    >>
      CHARACTER(100) :: fname,fname1!                                 >>
      LOGICAL there!                                                  >>
!=======================================================================    
      inquire(file='PARAMETERS',exist=there)
      if (there) then
         RUN=SYSTEM('rm -f PARAMETERS')
         open (1,file='PARAMETERS')
      else
         open (1,file='PARAMETERS')
      endif
       fname=')'
       fname1='!PARAMETER (  ischm)'
       write(1,25)ischm,      '!<=====',trim(fname1)
       fname1='!PARAMETER (  istrt)'
       write(1,25)istrt,      '!<=====',trim(fname1)
       fname1='!PARAMETER (   ntot)'
       write(1,25)ntot,       '!<=====',trim(fname1)
       fname1='!PARAMETER (    npw)'
       write(1,25)npw,        '!<=====',trim(fname1)
       fname1='!PARAMETER (    nps)'
       write(1,25)nps,        '!<=====',trim(fname1)
       fname1='!PARAMETER (    nen)'
       write(1,25)nen,        '!<=====',trim(fname1)
       fname1='!PARAMETER (    nop)'
       write(1,25)npw+nen+nps,'!<=====',trim(fname1)
       fname1='!PARAMETER (   ncns)'
       write(1,25)npw+nps,    '!<=====',trim(fname1)
       fname1='!PARAMETER (    nky)'
       write(1,25)nky,        '!<=====',trim(fname1)
       fname1='!PARAMETER ( nwfnfl)'
       write(1,25)nwfnfl,     '!<=====',trim(fname1)
       fname1='!PARAMETER (  nlgfl)'
       write(1,25) nlgfl,     '!<=====',trim(fname1)
       fname1='!PARAMETER (nlgline)'
       write(1,25)nlgline,    '!<=====',trim(fname1)
       fname1='!PARAMETER (wtp_ext)'
       write(1,24)wtp_ext,    '!<=====',trim(fname1)
       fname1='!PARAMETER (  wtp_h)'
       write(1,24)  wtp_h,    '!<=====',trim(fname1)
       fname1='!PARAMETER (  wtp_m)'
       write(1,24)wtp_m,      '!<=====',trim(fname1)
       fname1='!PARAMETER (  wtp_l)'
       write(1,24)wtp_l,      '!<=====',trim(fname1)
       fname1='!PARAMETER (  wtwfn)'
       write(1,24)wtwfn,      '!<=====',trim(fname1)
       fname1='!PARAMETER (   npop)'
       write(1,25) npop,      '!<=====',trim(fname1)
       fname1='!PARAMETER (  n2pop)'
       write(1,25)2*npop,     '!<=====',trim(fname1)
       fname1='!PARAMETER (  nvpnt)'
       write(1,25)nvpnt,      '!<=====',trim(fname1)
       if (ischm.eq.0) then               
           fname1='!PARAMETER (   neos)'
           write(1,25)neos,   '!<=====',trim(fname1)
       endif                              
c----------------------------------------------------  
       fname1='!PARAMETER (  crpmx)'
       write(1,24)crpmx,   '!<=====',trim(fname1)      
       fname1='!PARAMETER (  crpmn)'
       write(1,24)crpmn,   '!<=====',trim(fname1)      
       fname1='!PARAMETER (    crp)'
       write(1,24)  crp,   '!<=====',trim(fname1)
c----------------------------------------------------
 24   format(F7.4,A10,A26)
 25   format(I7,A10,A26)
!      write(1,'(a)')'       return'
!      write(1,'(a)')'       end' 
      close(1)
      inquire(file='CONSTRAINTS',exist=there)
      if (there) then
         RUN=SYSTEM('rm -f CONSTRAINTS')
         open (1,file='CONSTRAINTS')
      else
         open (1,file='CONSTRAINTS')
      endif
      write(1,'(a)')'# clgotm,clga'
      write(1,*)clgotm,clga
      write(1,'(a)')'# cpwmx(i),cpspwmx(i),cprjmx(i)'
      write(1,'(a)')'# cpwmn(i),cpspwmn(i),cprjmn(i)'
      do i=1,nwfnfl
         write(1,*)cpwmx(i),cpspwmx(i),cprjmx(i)
         write(1,*)cpwmn(i),cpspwmn(i),cprjmn(i)
      enddo
     
      close(1)
      return
      end
