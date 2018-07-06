!=========================== SUBROUTINE U4 =============================
      SUBROUTINE bm3(neos)!                                           >>
      IMPLICIT NONE!                                                  >>
      INTEGER i,neos!                                                 >>
      DOUBLE PRECISION temp,E0, V0, B0, B0p, Vmin, Vmax, Vincr!       >>
      DOUBLE PRECISION p23,p73,p53,x,p,RUN,SYSTEM!                    >>      
      CHARACTER(220) :: f1(100)!                                      >>
      LOGICAL there!                                                  >>
!=======================================================================          
!      neos=400
inquire(file='ev.in',exist=there)
if (there) then
   
   
   open (1,file='bm3fit.gnu')
   do i=1,5
     read(1,11)f1(i)
   enddo
   11 format(A30)
   
   read(1,*)
   read(1,12)f1(7),temp
   read(1,12)f1(8),temp
   read(1,12)f1(9),temp
   read(1,12)f1(10),temp
   
   read(1,*)
   read(1,12)f1(12),temp
   read(1,12)f1(13),temp
   read(1,12)f1(14),temp
   12 format(A18,f12.5)
   
   read(1,*)
   read(1,14)f1(16)
   14 format(A200)
   
   read(1,*)
   read(1,15)f1(18)
   read(1,*)
   read(1,15)f1(20)
   read(1,*)
   read(1,11)f1(22)
   read(1,*)
   read(1,11)f1(24)
   15 format(A85)
   
   read(1,*)
   read(1,16)f1(26)
   16 format(A100)
   
   read(1,*)
   read(1,11)f1(28)
   read(1,15)f1(29)
   !stop
   read(1,15)f1(30)
   read(1,17)f1(31)
   read(1,15)f1(32)
   read(1,15)f1(33)
   read(1,15)f1(34)
   read(1,11)f1(35)
   read(1,11)f1(36)
   
   17 format(A130)
   
   close(1,status='delete')
   open (1,file='bm3fit.gnu')
   
   
   write(*,*)'put guessed value of E0, V0, B0, B0p'
   read(*,*)E0, V0, B0, B0p
   write(*,*)'put Vmin, Vmax'!, Vincrement'
   read(*,*)Vmin, Vmax!, Vincr
   
   
   
   
   do i=1,5
     write(1,11)f1(i)
   enddo
   
   write(1,*)
   write(1,12)f1(7),E0
   write(1,12)f1(8),V0
   write(1,12)f1(9),B0
   write(1,12)f1(10),B0p
   
   write(1,*)
   write(1,12)f1(12),Vmin
   write(1,12)f1(13),Vmax
   write(1,12)f1(14),Vincr
   
   
   write(1,*)
   write(1,14)f1(16)
   
   
   write(1,*)
   write(1,15)f1(18)
   write(1,*)
   write(1,15)f1(20)
   write(1,*)
   write(1,11)f1(22)
   write(1,*)
   write(1,11)f1(24)
   
   
   write(1,*)
   write(1,16)f1(26)
   
   
   write(1,*)
   write(1,11)f1(28)
   write(1,15)f1(29)
   write(1,15)f1(30)
   write(1,17)f1(31)
   write(1,15)f1(32)
   write(1,15)f1(33)
   write(1,15)f1(34)
   write(1,12)f1(35)
   write(1,12)f1(36)
   
   
   close(1)
   RUN=SYSTEM('nohup gnuplot bm3fit.gnu')
   
   open (1,file='IN_ELAST')
   read(1,*)E0, V0, B0, B0p
   close(1)
else
   write(*,*)'put guessed value of E0, V0, B0, B0p'
   read(*,*)E0, temp, temp, temp
   write(*,*)'put Vmin, Vmax'!, Vincrement'
   read(*,*)Vmin, Vmax!, Vincr
   open (1,file='IN_ELAST')
   read(1,*)V0, B0, B0p
   close(1)
endif   

open (1,file='IN_TARGET')

p23        =2.0/3.0           
p73        =7.0/3.0           
p53        =5.0/3.0 
Vincr=(Vmax-Vmin)/(6.74833449394997*dfloat(neos-1))
x=Vmin/6.74833449394997
do i=1,neos
  p= 1.5*(B0) * ( (V0/x)**p73 - (V0/x)**p53 ) * ( 1.0 + 0.75*(B0p-4.0) * ((V0/x)**p23 - 1.0) )
  write(1,20)x*6.74833449394997, p
  x=x+Vincr
enddo
write(1,*)E0, V0, B0, B0p
20 format(2F15.5)
         call sleep(1)
!stop
return
end







