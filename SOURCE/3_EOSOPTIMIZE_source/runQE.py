#!/usr/bin/python

import subprocess
import numpy as np
import os
import shutil as su 
from datetime import datetime


# qsub  -l walltime=12:55:55,nodes=10:ppn=24 -I
#cat $PBS_NODEFILE | uniq > nodes.dat     # do this after interactive login
# put epaw.UPF here once
# do hyap "cp ../epaw.UPF ." once


with open('nodes.dat') as f:
    lines = f.readlines()
nodelist = []    
for i, line in enumerate(lines):
    n = lines[i].split()[0] 
    nodelist.append(n)
    
    

here=os.getcwd()
moduleload='module load intel/2015/update3 impi/5.0.3.048/intel'
#exe='/panfs/roc/groups/6/wentzcov/topsakal/bin/setups/pwscf/espresso-5.3.0/mesabi/bin/pw.x'
exe='/home/wentzcov/shared/rg-bin/code/QE/espresso-5.3.0/mesabi/bin/pw.x'


npot=1   # number of pots
neos=11   # neos
cpeos=24  # core-per-pot


ibrav=2
a=5   #see /home/wentzcov/shared/RE-PAW/_database/STRUCTURES2.dat
c=5
nbnd=10     # has no effect
kx=8
ky=8
kz=8
kshift='0 0 0'


starting='atomic'
#starting='file'


pos = ['  0.8750000000000000  0.8750000000000000  0.8750000000000000     ',
       '  0.1250000000000000  0.1250000000000000  0.1250000000000000     ',
       ];






# =========================================================================================== ###
def make_scfin(scale,pf,ibrav,a,c,pos):
    
    if ibrav == 2:
        acline = 'a='+str(format(scale*a, '.5f'))
    elif ibrav == 3:
        acline = 'a='+str(format(scale*a, '.5f'))
    elif ibrav == 4:        
        acline = 'a='+str(format(scale*a, '.5f'))+', c='+str(format(scale*c, '.5f')) 
    
    fo = open('scf.in', 'w')
    fo.write('&control                                                                 \n')  
    fo.write('calculation=\'scf\'                                                      \n')  
    fo.write('lkpoint_dir = .false.                                                    \n')    
    fo.write('pseudo_dir=\'../\'                                                       \n')  
    fo.write('outdir=\'./tmp\'                                                        \n')      
    fo.write('disk_io=\'low\'                                                          \n')
    fo.write('prefix=\''+pf+'\'                                                        \n')    
    fo.write('etot_conv_thr=1.0E-6                                                     \n') 
    fo.write('verbosity = \'low\'                                                      \n')     
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&system                                                                  \n')  
    fo.write('ibrav='+str(ibrav)+',                                                    \n')  
    fo.write(acline+'                                                                  \n')  
    fo.write('nat='+str(len(pos))+', ntyp=1, nspin=1                                   \n')  
    fo.write('ecutwfc=40, ecutrho=160                                                \n')  
    fo.write('occupations=\'smearing\', smearing=\'fd\', degauss=0.001                 \n')  
    fo.write('! nbnd='+str(nbnd)+'                                                       \n')  
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&electrons                                                               \n')  
    fo.write('mixing_beta=0.5                                                          \n')
    fo.write('startingwfc= \''+starting+'\'                                            \n') 
    fo.write('startingpot= \''+starting+'\'                                            \n')     
    fo.write('conv_thr=1.0d-8                                                          \n')  
    fo.write('electron_maxstep=20, scf_must_converge = .false.                         \n')  
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&ions                                                                    \n')  
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('&cell                                                                    \n')  
    fo.write('/                                                                        \n')  
    fo.write('                                                                         \n')  
    fo.write('ATOMIC_SPECIES                                                           \n')  
    fo.write('Sn  1.00            epaw.UPF                                             \n')  
    fo.write('                                                                         \n')  
    fo.write('K_POINTS {automatic}                                                     \n')  
    fo.write(' '+str(kx)+' '+str(ky)+' '+str(kz)+'  '+kshift+'                         \n')  
    fo.write('                                                                         \n')  
    fo.write('ATOMIC_POSITIONS crystal                                                 \n')
    for p in range(len(pos)):
        fo.write('Sn '+pos[p]+'        \n')
    fo.close()     
    return





# =========================================================================================== ###
def make_folders(npot,neos,nodelist):
    
    #subprocess.call(' for f in `seq 1 '+str(npot)+' `; do mkdir pot$f 2> /dev/null; cd pot$f; for e in `seq 1 '+str(neos)+' `; do mkdir eos$e 2> /dev/null; done; cd ..; done ', shell=True)
    #for f in range(npot):
        #for e in range(neos):
            #subprocess.call(' ssh '+nodelist[f]+' "mkdir /scratch/pawopt 2> /dev/null" ', shell=True)            
            #subprocess.call(' ssh '+nodelist[f]+' "mkdir /scratch/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' 2> /dev/null" ', shell=True)
            #subprocess.call(' ssh '+nodelist[f]+' "ln -s /scratch/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' '+here+'/pot'+str(f+1)+'/eos'+str(e+1)+'/tmp  2> /dev/null" ', shell=True)  
            #subprocess.call(' echo pot'+str(f+1)+'.eos'+str(e+1)+' folder is created ', shell=True)  
            
    subprocess.call(' for f in `seq 1 '+str(npot)+' `; do mkdir pot$f 2> /dev/null; cd pot$f; for e in `seq 1 '+str(neos)+' `; do mkdir eos$e 2> /dev/null; done; cd ..; done ', shell=True)
    for f in range(npot):
        for e in range(neos):
            subprocess.call(' mkdir /scratch.global/`whoami` 2> /dev/null ', shell=True)  
            subprocess.call(' mkdir /scratch.global/`whoami`/pawopt 2> /dev/null ', shell=True)             
            subprocess.call(' mkdir /scratch.global/`whoami`/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' 2> /dev/null ', shell=True)
            subprocess.call(' ln -s /scratch.global/`whoami`/pawopt/pot'+str(f+1)+'.eos'+str(e+1)+' '+here+'/pot'+str(f+1)+'/eos'+str(e+1)+'/tmp  2> /dev/null ', shell=True)  
            subprocess.call(' echo pot'+str(f+1)+'.eos'+str(e+1)+' folder is created ', shell=True)              
make_folders(npot,neos,nodelist) 



# =========================================================================================== ###
def put_inputs(npot,neos):
    
    scale = np.linspace(0.90,1.10,neos)
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
def run_calc(npot,neos,nodelist):

    sf = open('calc_script', 'w')
    sf.write('#!/bin/bash  \n ')    
    sf.write('             \n ')   
    
    for e in range(neos):
        sf.write('  \n ')
        sf.write('  \n ')
        for f in range(npot):
            
            potfile = here+'/pot'+str(f+1)+'/epaw.UPF'
            if ( not os.path.isfile(potfile) ):
                print("Error: %s file not found, skipping this folder" % potfile)
            else:
                sf.write('ssh '+nodelist[f]+' " '+moduleload+'; cd '+here+'/pot'+str(f+1)+'/eos'+str(e+1)+'; mpirun -np '+str(cpeos)+' '+exe+' < scf.in > scf.out " & \n')
      
        sf.write('wait \n ')
        sf.write('echo eos'+str(e+1)+' done  \n ')     
        sf.write('date \n ')

        
    sf.write('  \n ')
    sf.write('  \n ')    
    sf.close()              
run_calc(npot,neos,nodelist) 



## =========================================================================================== ###
subprocess.call(' chmod +x calc_script ', shell=True)

a = datetime.now()
subprocess.call(' time ./calc_script ', shell=True)
b = datetime.now()

d = b - a
time = d.seconds

t = open('timing.dat', 'a')
t.write(str(time)+'\n')   
t.close()



# =========================================================================================== ###
def run_eos(npot,neos):
    
    for f in range(npot):
        os.chdir('pot'+str(f+1))
        subprocess.call('> ev.in ', shell=True)        
        subprocess.call('dir=`ls -d eos*/`; for i in $dir; do cd $i; E=`grep \'!    total energy              =\' scf.out | awk \'{print $5}\' `; V=`grep "unit-cell volume" scf.out | tail -1 | awk  \'{print $4}\'`; echo  "$V $E" >> ../ev.in ;  cd .. ; done   ', shell=True)
        subprocess.call('python2 ../script.py ev.in 1 ', shell=True)
        #subprocess.call('module load python-epd/1.4.1; python ../eos_script.py  ', shell=True)        
        #module load python-epd/1.4.1                                             
        #python script.py 
        os.chdir('..')  
run_eos(npot,neos) 



