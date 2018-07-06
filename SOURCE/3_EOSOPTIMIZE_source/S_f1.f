!=========================== SUBROUTINE U4 =============================
      SUBROUTINE readf1(f1,ntot,ky,nky,npw,nen,nps,wky,rpw,ren,rps)!  >>
      IMPLICIT NONE!                                                  >>
      INTEGER ntot,nky,npw,nen,nps,line,iky,ien,ips,ipw!              >>
      INTEGER ky(ntot)!                                               >>
      DOUBLE PRECISION rpw(npw),ren(nen),rps(nps)!                    >>
      CHARACTER(100) wky(nky)!                                        >>
      CHARACTER(100) :: f1!                                           >>
!=======================================================================    
      open (1,file=trim(f1))
      iky=0
      ien=0
      ips=0
!       do line=1, ntot
!         write(*,*)line,ky(line)
!       enddo
      do line=1, ntot
         if(ky(line).ge.7)read(1,*)
         !write(*,*)'a',ky(line)
         if(ky(line).eq.0)then
           iky=iky+1
           read(1,20)wky(iky)!READ KEYWORDS
!          write(2,*)wky(iky)!WRITE KEYWORDS
         elseif(ky(line).ge.1.and.ky(line).le.4)then
           read(1,*)(rpw(ipw),ipw=1,npw)!READ Rpaw values
!          write(2,*)(rpw(ipw),ipw=1,npw)
         elseif(ky(line).eq.5)then
           ien=ien+1
           read(1,*)ren(ien)!READ energy
!           write(2,*)ren(ien)
         elseif(ky(line).eq.6)then
           ips=ips+1
           read(1,*)rps(ips)!READ r for partial waves
!           write(2,*)rps(ips)
         endif
      enddo
20    format(A70)
      close(1)
      return
      end
