!=========================== SUBROUTINE U5 =============================
      SUBROUTINE write_stndr(ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)!>>
      IMPLICIT NONE!                                                  >>
      INTEGER ntot,nky,npw,nen,nps,line,iky,ien,ips,ipw!              >>
      INTEGER ky(ntot)!                                               >>
      DOUBLE PRECISION rpw(npw),ren(nen),rps(nps)!                    >>
      CHARACTER(100) wky(nky)!                                        >>
!=======================================================================    
      open (1,file='IN_STANDARD')
      iky=0
      ien=0
      ips=0
      do line=1, ntot
!            write(*,*)line
         if(ky(line).eq.0)then
           iky=iky+1
           write(1,20)wky(iky)!WRITE KEYWORDS
         elseif(ky(line).ge.1.and.ky(line).le.4)then
           if(rpw(1).lt.10.0d0)write(1,21)(rpw(ipw),ipw=1,npw)!WRITE Rpaw values
           if(rpw(1).ge.10.0d0)write(1,22)(rpw(ipw),ipw=1,npw)!WRITE Rpaw values
*           write(1,*)(rpw(ipw),ipw=1,npw)!WRITE Rpaw values            
         elseif(ky(line).eq.5)then
           ien=ien+1
           if(ren(ien).lt.10.0d0)write(1,21)ren(ien)!WRITE energy
           if(ren(ien).ge.10.0d0)write(1,22)ren(ien)!WRITE energy
         elseif(ky(line).eq.6)then
           ips=ips+1
           if(rps(ips).lt.10.0d0)write(1,21)rps(ips)!WRITE r for partial waves
           if(rps(ips).ge.10.0d0)write(1,22)rps(ips)!WRITE r for partial waves
         endif
      enddo
 20   format(A70)
 21   format(F9.7,3F11.7)
 22   format(F10.7,3F11.7)
      close(1)
       !write(*,*)'>> Reading UPTO HERE  __________....................'
       !STOP
      return
      end
