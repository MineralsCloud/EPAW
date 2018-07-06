      SUBROUTINE FITEOS(npop,neos,wtp_ext,wtp_h,wtp_m,wtp_l,
     +                  areap,avol,aprs,fotm,farea)
!============================ DECLARATION ==============================
      INTEGER i,ipop,npop,ieos,neos,ios,nvpnt!                        ||
!       PARAMETER (   npop=     10)!                                  ||
!       PARAMETER (   neos=    400)!                                  ||      
      DOUBLE PRECISION d0,avol(neos),aprs(neos),qvol(neos),qprs(neos)!||
      DOUBLE PRECISION dfr,areap,areaqe,farea(npop),fotm(npop)!       ||
      DOUBLE PRECISION wtp_ext,wtp_h,wtp_m,wtp_l,wt(4)!               ||
      DOUBLE PRECISION tp,tp1,tp2!                                    ||
      CHARACTER*70 cna,cnb!                                           ||
      LOGICAL THERE!                                                  ||
!=======================================================================
!       wtp_ext= 1.0000
!       wtp_h= 0.75000
!       wtp_m= 0.5000
!       wtp_l= 0.2500
! 
!       write(*,*)ios            
!       open(3,file='IN_TARGET',status='old')
!       do ieos=1,neos
!          read(3,*)avol(ieos),aprs(ieos)
!       enddo      
      ios=neos/4      
      do ipop=1,npop!==================================================>
         fotm(ipop)=0.0d0
         farea(ipop)=0.0d0     
         if(ipop.lt.10)then
            write(cna,FMT="(I1)")ipop
         elseif(ipop.lt.100)then
            write(cna,FMT="(I2)")ipop
         endif
         INQUIRE( FILE='pot'//trim(cna)//'/qerun.out', EXIST=THERE )
         IF ( THERE )then
             open(1,file='pot'//trim(cna)//'/qerun.out',status='old')
             rewind(1)
             do ieos=1,neos
                read(1,*)qvol(ieos),qprs(ieos)
             enddo
             close(1)
*******************************************
!contribution from extreme high pressure region
            tp=(wtp_ext-wtp_h)/dfloat(ios)
            tp1=wtp_ext+tp
            do i=1,ios
             tp1=tp1-tp
             d0=0.0d0
             d0=dabs(aprs(i)-qprs(i))
             fotm(ipop)=fotm(ipop)+tp1*d0
!              write(2,*)i,aprs(i),qprs(i),tp1,d0,fotm(ipop)
            enddo
!             write(2,*)
!contribution from high pressure region
            tp=(wtp_h-wtp_m)/dfloat(ios)
            tp1=wtp_h+tp
            do i=1+ios,2*ios
             tp1=tp1-tp
             d0=0.0d0
             d0=dabs(aprs(i)-qprs(i))
             fotm(ipop)=fotm(ipop)+tp1*d0
!              write(2,*)i,aprs(i),qprs(i),tp1,d0,fotm(ipop)             
            enddo
!             write(2,*)
!contribution from moderate pressure to low pressure region
            tp=(wtp_m-wtp_l)/dfloat(2*ios)
            tp1=wtp_m+tp
            do i=1+2*ios,4*ios
             tp1=tp1-tp
             d0=0.0d0
             d0=dabs(aprs(i)-qprs(i))
             fotm(ipop)=fotm(ipop)+tp1*d0
!              write(2,*)i,aprs(i),qprs(i),tp1,d0,fotm(ipop)             
            enddo!
            write(2,*)
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
! Calculate fitness according to area difference of eos 4m QE & WIEN2k %
!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
        call C_Simps(neos,qvol,qprs,areaqe)
        dfr=areap-areaqe
        farea(ipop)=dfr*dfr
        ELSE
          fotm(ipop)=200000000.0*100.0
          farea(ipop)=200000000.0*100.0
        ENDIF
!        write(*,*)ipop,fotm(ipop),farea(ipop)
      enddo!
            return
            end  
!      
!       inquire(file='ev.in',exist=there)
!       
!       open(1,file='test.in')
!       irow = 0
!       do
!         read (1,*, END=10)a,b
!         irow = irow + 1
!       enddo
! 10    rewind(1)
!        write(*,*)irow
!       close(1)
