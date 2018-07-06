!Program getVolvsEngfromabinit
SUBROUTINE getVolvsEngfromabinit(ipop,filename)
!  searches for keywords ndtset and rprim in input file
!  searches for keywords acell and etotal in output file      
  Implicit none

  CHARACTER(256) :: cna,cnb
  CHARACTER(256) :: filename,readline
  INTEGER :: ndtset,i,j,k,l,m,n,ok,ipop
  REAL(8) :: basis(3,3),acell(3),x,y,z,v,e,uvol,uvolscaled
  REAL(8), allocatable :: vol(:),energy(:),vols(:),energys(:)

  write(6,*) 'Enter file name for abinit output'
!  read(5,*) filename
  open(7,file=TRIM(filename),form='formatted')

  ndtset=0; basis=0    
  do    
    read(7,'((a))',iostat=OK) readline
     if (OK/=0) exit
       i=INDEX(readline,'ndtset')
       if (i>0) then
          read(unit=readline(i+6:80),fmt=*) ndtset
          write(6,*) 'ndtset = ', ndtset
          if  (ndtset .le. 0) then
            write(6,*) 'Error -- ndtset '
            stop
        endif
       allocate(vol(ndtset), energy(ndtset),vols(ndtset), energys(ndtset))
       exit
     endif        
 end do

  do    
    read(7,'((a))',iostat=OK) readline
     if (OK/=0) exit
       j=INDEX(readline,'rprim')
       if (j>0 ) then
          read(unit=readline(j+5:80),fmt=*) basis(:,1)
              read(7,*) basis(:,2)     
              read(7,*) basis(:,3)     
              uvol=abs(basis(1,1)*basis(2,2)*basis(3,3) + &
&               basis(1,2)*basis(2,3)*basis(3,1)  + &         
&               basis(1,3)*basis(2,1)*basis(3,2)  - &         
&               basis(3,1)*basis(2,2)*basis(1,3)  - &         
&               basis(3,2)*basis(2,3)*basis(1,1)  - &         
&               basis(2,1)*basis(1,2)*basis(3,3) )
                write(6,*) 'uvol = ', uvol
                uvolscaled=uvol*(0.52917721067**3)    ! Angstrom^3 unit
             if (uvol .le.  1.d-5) then
             write(6,*) 'Error uvol '
             stop
             endif
             exit
     endif        
  enddo

i=0;j=0

do
   if (i.ge.ndtset.and.j.ge.ndtset) exit
   read(7,'((a))',iostat=ok) readline
      if (ok/=0) exit
   k= INDEX(readline,'acell')
   l= INDEX(readline,'etotal')
   if (k>0 .and. i.lt.ndtset) then
     read(unit=readline,fmt='(21x,3e18.10)') acell(:)
     write(6,*) acell; call flush(6)
     i=i+1
     vol(i)=uvol*acell(1)*acell(2)*acell(3)      
     vols(i)=uvolscaled*acell(1)*acell(2)*acell(3)      
     cycle
   elseif (l>0 .and. j.lt.ndtset) then
     read(unit=readline,fmt='(21x,e18.10)') x
     write(6,*) x; call flush(6)
     j=j+1
     energy(j)=2*x                                ! Ryd units
     energys(j)=2*x*13.605693009d0                 ! eV units
     cycle
   else
     cycle        
   endif
           
enddo

close(7)
        if(ipop.lt.10)then
          write(cna,FMT="(I1)")ipop
        elseif(ipop.lt.100)then
          write(cna,FMT="(I2)")ipop
        endif
        cnb='pot'//trim(cna)//'/EvsVeVAng.dat'
open(8,file=trim(cnb), form='formatted')
        cnb='pot'//trim(cna)//'/EvsVRyBohr.dat'
open(9,file=trim(cnb), form='formatted')
!        cnb='pot'//trim(cna)//'/EvsVRyBohr.dat'
!open(9,file='EvsVRyBohr.dat', form='formatted')

x=MINVAL(energy)
energy=energy-x 
x=MINVAL(energys)
energys=energys-x
!write(6,*) energy; call flush(6)
!write(6,*) vol; call flush(6)
do i=1,ndtset  
  write(9, '(1p2e16.8)') vol(i),   energy(i)
  write(8, '(1p2e16.8)') vols(i),   energys(i)
  call flush(8)
  call flush(9)
enddo
!write(8,*) '#   vol (ang**3)       energy (eV)'
!write(9,*) '#   vol (Bohr**3)       energy (Ry)'

close(8)
close(9)
return
end
!end program           
