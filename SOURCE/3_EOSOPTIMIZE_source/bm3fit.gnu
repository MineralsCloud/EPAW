p23        =2.0/3.0           
p73        =7.0/3.0           
p53        =5.0/3.0           
echarge    = 1.60217733e-19   
#unitconv   = echarge * 1.0e21 
unitconv   = 1.0 

E0              =      0.00507
V0              =    153.46700
B0              =     94.69300
B0p             =      3.95800

Vmin            =    137.84200
Vmax            =    176.24230
Vincr           =      0.00000

f(x)=E0 + (9.0*sqrt(V0*V0)*sqrt((B0/unitconv)*(B0/unitconv))/16.0) * ( ( ((sqrt(V0*V0)/x)**p23 - 1)**3.0 )*sqrt(B0p*B0p) + ( ((sqrt(V0*V0)/x)**p23 - 1)**2.0 )*(6.0-4.0*((sqrt(V0*V0)/x)**(2.0/3.0))) ) 

#fit f(x) 'LIO_AE.dat' u ($1/6.74833449394997):($2*13.60569253) via E0,V0,B0,B0p           
fit f(x) 'LIO_AE.dat' u 1:2 via E0,V0,B0,B0p           

#plot f(x),'LIO_AE.dat' u ($1/6.74833449394997):($2*13.60569253) w l                      

#B0= B0*160.217595773527      

set print "ON_ELAST" #append 

##p(x)= 1.5*(B0) * ( (V0/x)**p73 - (V0/x)**p53 ) * ( 1.0 + 0.75*(B0p-4.0) * ((V0/x)**p23 - 1.0) )   

print E0,V0,B0,B0p            
###do for [x=32:40:2]  {print x, ' ',p(x)}                                           
#list(start,end,increment)=system(sprintf("seq %g %g %g", start, increment, end))   
#do for [x in list(Vmin/6.74833449394997,Vmax/6.74833449394997,Vincr/6.74833449394997)]{print x*6.74833449394997, ' ', p(x)}     
##print '# E0= ',E0,'  V0= ',V0,'  B0= ',B0,'  B0p= ',B0p                            
###set print "IN_TARGET2" #append                                                    
###print E0,'   ',V0,'   ',B0,'   ',B0p                                              
set print         
set output        
