      SUBROUTINE place(ipid)
      IMPLICIT NONE!                                                  %%
      INTEGER ipid!                                                   ||
      CHARACTER*70 cna,cnb,cnc,cnd,cne!                               ||
      DOUBLE PRECISION RUN,SYSTEM!                                    || 
      if(ipid.lt.10)then
          write(cna,FMT="(I1)")ipid
      elseif(ipid.lt.100)then
          write(cna,FMT="(I2)")ipid
      endif  
      cnb='cp -f  pot'//trim(cna)//'/*.UPF SUPERINDIVIDUAL'
      cnc='cp -f  pot'//trim(cna)//'/ev.in SUPERINDIVIDUAL'
!      cnd='cp -f  pot'//trim(cna)//'/fit.log SUPERINDIVIDUAL'
      cne='cp -f  pot'//trim(cna)//'/qerun.out SUPERINDIVIDUAL'
      write(*,*) cnb
      open(1,file='copyfile.sh',status='unknown')
      rewind(1)
      RUN=SYSTEM('chmod 777 copyfile.sh')
      write(1,'(a)')trim(cnb)
      write(1,'(a)')trim(cnc)
!      write(1,'(a)')trim(cnd)
      write(1,'(a)')trim(cne)
      close(1)
      RUN=SYSTEM('./copyfile.sh')
      return
      end
