!===========================  DSTCNTY   U7 =============================
! DSTCNTY checks for any discontinuity in logderivative files         >>
!--------------------------------------------------------------------->>
!   VARIABLES/  |                      DESCRIPTION OF                 >>
!   PARAMETERS  |                   VARIABLES/PARAMETERS              >>
!.....................................................................>>
! n             : number of rows in logderiv files                    >>   
! nlgfile       : number of logderiv files                            >>   
! iex           : measure of discontinuity                            >>   
      SUBROUTINE DSTCNTY(n,nlgfile,iex)!                              >>
      implicit none!                                                  >>
      integer i,j,n,ifile,nlgfile!                                    >>
      integer iex,icount(nlgfile)!                                    >>
      double precision s0(nlgfile,n),gr0(nlgfile,n),sr0(nlgfile,n)!   >>
      double precision s(n),gr(n),sr(n)!                              >>
      double precision summ,dlgotm,dlga,areagr,areasr!                >>
      character*10 cna!                                               >>
!=======================================================================    
! OPEN & READ THE logderiv.* FILES
      do j=1,nlgfile
        ifile=j-1
        if(ifile.lt.10)then
          write(cna,FMT="(I1)")ifile
        elseif(ifile.lt.100)then
          write(cna,FMT="(I2)")ifile
        endif
        open(1,file='logderiv.'//trim(cna),status='unknown')
        do i=1,n
          read(1,*)s0(j,i),gr0(j,i),sr0(j,i)
        enddo
        close(1)
      enddo
! READ logderiv.* FILES & SUM OF THE DIFFERENCE BETWEEN EACH POINT
! ONTO MAPPING
      do j=1,nlgfile
        icount(j)=0
        iex=0
        do i=2,n
          if(dabs(gr0(j,i)) .le. 5.0d0)then
          if(dabs(sr0(j,i)) .le. 5.0d0)then
            if(gr0(j,i) .le. gr0(j,i-1))then
              if(sr0(j,i) .le. sr0(j,i-1))then
                iex=0
              else
                iex=1
              endif
            else
              if(sr0(j,i) .gt. sr0(j,i-1))then
                iex=0
              else
                iex=1
              endif
            endif
          endif
          endif
          icount(j)=icount(j)+iex
!          write(*,*)i,icount(j)
        enddo
!        write(*,*)icount(j)
      enddo
      iex=0
      do j=1,nlgfile
        iex=iex+icount(j)
      enddo
!      write(*,*)iex
      do i=0,nlgfile-1
        ifile=9+i
        close(ifile)
      enddo
      return
      end
