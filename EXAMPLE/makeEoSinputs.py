#!/usr/bin/python

import subprocess
import numpy as np
import os
import shutil as su 
from datetime import datetime

here=os.getcwd()

npot=10 # number of PAW data-sets considered in each generation; Plz do not change the number for this version of the code.
neos=15 # number of volume points at which SCF calculations will be performed.


# =========================================================================================== make necessary folders to run scf calculations for different data-sets at different volume points
def make_folders(npot,neos):
    subprocess.call(' for f in `seq 1 '+str(npot)+' `; do mkdir pot$f 2> /dev/null; cd pot$f; for e in `seq 1 '+str(neos)+' `; do mkdir eos$e 2> /dev/null; done; cd ..; done ', shell=True)
    for f in range(npot):
        for e in range(neos):
            subprocess.call(' mkdir /scratch.global/`whoami` 2> /dev/null ', shell=True)
            subprocess.call(' mkdir /scratch.global/`whoami`/pawopt 2> /dev/null ', shell=True)
            subprocess.call(' mkdir /scratch.global/`whoami`/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' 2> /dev/null ', shell=True)
            subprocess.call(' ln -s /scratch.global/`whoami`/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' '+here+'/pot'+str(f+1)+'/eos'+str(e+1)+'/tmp  2> /dev/null ', shell=True)
            subprocess.call(' echo pot'+str(f+1)+'.eos'+str(e+1)+' folder is created ', shell=True)
make_folders(npot,neos)
# ===========================================================================================


ibrav=2   # Bravais-lattice index.
#         For example, ibrav=2 (cubic F (fcc): define only 'a'), ibrav=3 (cubic I (bcc): define only 'a'), ibrav=4 (Hexagonal and Trigonal P: define only 'a', and 'c') are included. Edit accordingly for other ibrav Bravais-lattice indexes. For comfort, use ibrav=0, and define both lattice vectors and positions.
 
a=5.52507  # has no effect, when ibrav=0
c=5.52507  # has no effect, when ibrav=0

nbnd=10    # uncomment the line in make_scfin routine if require

kx=12
ky=12
kz=12
kshift='1 1 1'

# define these lattice vectors only if ibrav=0.
cp11=1.72616
cp12=0.0
cp13=0.0
cp21=0.0
cp22=3.05589
cp23=0.0
cp31=0.0
cp32=0.0
cp33=2.95471


starting='atomic' # starting potential from atomic charge superposition
#starting='file'  # start from existing "charge-density.xml" file


pos = ['  0.0000000000000  0.0000000000000  0.0000000000000     ',
       ];


# =========================================================================================== ###
def make_scfin(scale,pf,ibrav,a,c,pos):    # for with cell parameters
    
    if ibrav == 2:
        acline = 'a='+str(format(scale*a, '.5f'))
    elif ibrav == 3:
        acline = 'a='+str(format(scale*a, '.5f'))
    elif ibrav == 4:        
        acline = 'a='+str(format(scale*a, '.5f'))+', c='+str(format(scale*c, '.5f')) 
    elif ibrav == 0:            
        acline = '   '+str(format(scale*cp11, '.5f'))+'   '+str(format(scale*cp12, '.5f'))+'   '+str(format(scale*cp13, '.5f'))  
        bcline = '   '+str(format(scale*cp21, '.5f'))+'   '+str(format(scale*cp22, '.5f'))+'   '+str(format(scale*cp23, '.5f'))
        ccline = '   '+str(format(scale*cp31, '.5f'))+'   '+str(format(scale*cp32, '.5f'))+'   '+str(format(scale*cp33, '.5f'))        
    
    fo = open('scf.in', 'w')
    fo.write('&control                                                                 \n')  
    fo.write('calculation=\'scf\'                                                      \n')  
    fo.write('lkpoint_dir = .false.                                                    \n')    
    fo.write('pseudo_dir=\'../\'                                                       \n')  
    fo.write('outdir=\'./tmp\'                                                         \n') #
    fo.write('disk_io=\'low\'                                                          \n') #
    fo.write('prefix=\''+pf+'\'                                                        \n')   
    fo.write('etot_conv_thr=1.0E-6                                                     \n') #
    fo.write('verbosity = \'low\'                                                      \n') #    
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&system                                                                  \n')  
    fo.write('ibrav='+str(ibrav)+',                                                    \n') 
#   fo.write('celldm(1)=1.0                                                            \n') #uncomment for ibrav=0    
    fo.write(acline+'                                                                  \n') #comment for ibrav=0    
    fo.write('nat='+str(len(pos))+', ntyp=1, nspin=1                                   \n') #
    fo.write('ecutwfc=100, ecutrho=500                                                 \n') #Kinetic energy cutoff (Ry) for wavefunctions, for charge density and potential: Change accordingly
    fo.write('occupations=\'smearing\', smearing=\'fd\', degauss=0.001                 \n') #smearing 
#   fo.write('nbnd='+str(nbnd)+'                                                       \n')  
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&electrons                                                               \n')  
    fo.write('mixing_beta=0.5                                                          \n') #mixing factor for self-consistency
    fo.write('startingwfc= \''+starting+'\'                                            \n') 
    fo.write('startingpot= \''+starting+'\'                                            \n')     
    fo.write('conv_thr=1.0d-8                                                          \n') # 
    fo.write('electron_maxstep=20, scf_must_converge = .false.                         \n') # 
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&ions                                                                    \n')  
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&cell                                                                    \n')  
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('ATOMIC_SPECIES                                                           \n') #Change the name of the atomic species
    fo.write('Ca  1.00            epaw.UPF                                             \n')  
    fo.write('                                                                         \n')  
    fo.write('K_POINTS {automatic}                                                     \n')  
    fo.write(' '+str(kx)+' '+str(ky)+' '+str(kz)+'  '+kshift+'                         \n')  
    fo.write('                                                                         \n')   
#   fo.write('CELL_PARAMETERS (alat=  1.88972600)                                      \n') #uncomment for ibrav=0    
#   fo.write(acline+'                                                                  \n') 
#   fo.write(bcline+'                                                                  \n') #uncomment for ibrav=0    
#   fo.write(ccline+'                                                                  \n') #uncomment for ibrav=0    
#   fo.write('                                                                         \n') #uncomment for ibrav=0    
    fo.write('ATOMIC_POSITIONS crystal                                                 \n')
    for p in range(len(pos)):
        fo.write('Ca '+pos[p]+'        \n')
    fo.close()     
    return

# =========================================================================================== ###
#def make_folders(npot,neos):
    #subprocess.call(' for f in `seq 1 '+str(npot)+' `; do mkdir pot$f 2> /dev/null; cd pot$f; for e in `seq 1 '+str(neos)+' `; do mkdir eos$e 2> /dev/null; done; cd ..; done ', shell=True)
    #for f in range(npot):
        #for e in range(neos):
            #subprocess.call(' mkdir /scratch.global/`whoami` 2> /dev/null ', shell=True)  
            #subprocess.call(' mkdir /scratch.global/`whoami`/pawopt 2> /dev/null ', shell=True)             
            #subprocess.call(' mkdir /scratch.global/`whoami`/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' 2> /dev/null ', shell=True)
            #subprocess.call(' ln -s /scratch.global/`whoami`/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' '+here+'/pot'+str(f+1)+'/eos'+str(e+1)+'/tmp  2> /dev/null ', shell=True)  
            #subprocess.call(' echo pot'+str(f+1)+'.eos'+str(e+1)+' folder is created ', shell=True)              
#make_folders(npot,neos) 

# =========================================================================================== ###
def put_inputs(npot,neos):
    
    scale = np.linspace(0.78,1.06,neos)
    for p in range(npot):
        os.chdir('pot'+str(p+1))
        for e in range(neos):
            os.chdir('eos'+str(e+1))
            pf='eos'+str(e+1)
            s=scale[e]
            make_scfin(s,pf,ibrav,a,c,pos)
            os.chdir('..')
        os.chdir('..')       
put_inputs(npot,neos) 

### =========================================================================================== ###



### =========================================================================================== ###
subprocess.call(' chmod +x maketmp ', shell=True)
def run_calc(npot,neos):

    sf = open('scf_script.sh', 'w')
    sf.write('#!/bin/bash  \n ')    
    sf.write('             \n ')   
    sf.write('orig=0       \n ')   
    sf.write('for j in `seq 1 '+ str(npot) +' `; do \n ')
    sf.write('for i in `seq 1 '+ str(neos) +' `; do \n ')
    sf.write('cd pot$j/eos$i/ \n ')   
    sf.write('rm -r tmp \n ')   
    sf.write('cp ../../maketmp . \n ')   
    sf.write('maketmp \n ')   
    sf.write('ibrun -n 4 -o $orig pw.x -nk 2 -in scf.in >scf.out & \n ')   
    sf.write('             \n ')   
    sf.write('             \n ')   
    sf.write('let orig=orig+4  \n ')   
    sf.write('             \n ')   
    sf.write('sleep 1      \n ')   
    sf.write('             \n ')   
    sf.write('cd ../../    \n ')   
    sf.write('             \n ')   
    sf.write('done         \n ')   
    sf.write('done         \n ')   
    sf.write('             \n ')   
    sf.write('             \n ')   
    sf.write('wait         \n ')   
run_calc(npot,neos) 

## =========================================================================================== ###
subprocess.call(' chmod +x scf_script.sh ', shell=True)
subprocess.call(' mkdir SUPERINDIVIDUAL', shell=True)


### =========================================================================================== ###
def replace():
#    strng=grep -lE "atomic" **/**/scf.in| xargs sed -in 's/atomic/file/g'
    sf = open('replace.sh', 'w')
    sf.write('#!/bin/bash  \n ')    
    sf.write('             \n ')   
    sf.write('grep -lE '+'"atomic"'+' **/**/scf.in| xargs sed -in '+'\''+'s/atomic/atomic/g'+'\''+'    \n ')   
replace()


subprocess.call(' chmod +x replace.sh ', shell=True)
#subprocess.call(' ./replace.sh ', shell=True)

