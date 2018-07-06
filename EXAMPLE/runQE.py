#!/usr/bin/python

import subprocess
import numpy as np
import os
import shutil as su
from datetime import datetime


here=os.getcwd()

npot=10   # number of pots
neos=15   # neos



### =========================================================================================== ###
subprocess.call(' chmod +x scf_script.sh ', shell=True)

a = datetime.now()
subprocess.call(' time ./scf_script.sh ', shell=True)
b = datetime.now()

d = b - a
time = d.seconds

t = open('timing.dat', 'a')
t.write(str(time)+'\n')
t.close()

## =========================================================================================== ###
def run_eos(npot,neos):

    for f in range(npot):
        os.chdir('pot'+str(f+1))
        subprocess.call('> ev.in ', shell=True)
        subprocess.call('dir=`ls -d eos*/`; for i in $dir; do cd $i; E=`grep \'!    total energy              =\' scf.out | awk \'{print $5}\' `; V=`grep "unit-cell volume" scf.out | tail -1 | awk  \'{print $4}\'`; echo  "$V $E" >> ../ev.in ;  cd .. ; done   ', shell=True)
        subprocess.call('python2 ../script.py ev.in  ', shell=True)
        os.chdir('..')
run_eos(npot,neos)

