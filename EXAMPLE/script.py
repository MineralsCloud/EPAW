#!/usr/bin/python
# Obtained from Kanchan Sarkar who modified code from delta factor project3
import sys
import numpy as np
from sys import argv
#from pylab import *
import subprocess

subprocess.call('rm -rf qerun.out', shell=True)


# ### inputs  <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> ### |
inputs = sys.argv
ilen   = len(inputs)

if ilen == 1:
    inputs.extend(['ev.in',0,0])
if ilen == 2:
    inputs.extend([0,0])
if ilen == 3:
    inputs.extend([0])
    
evin      = inputs[1]
formatkey = int(inputs[2])
savekey   = int(inputs[3])

#formatkey =1 

# ### read <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> ### |
# adapted from Delta_v3-0 package off Ugent
def BM(data,formatkey,savekey):

    if formatkey == 0:
        VV = data[:,0]/6.74833449394997
        EE = data[:,1]*13.60569253 
    else:
        VV = data[:,0]
        EE = data[:,1]
        print 'Attention : NOT converting "a.u.^3 > A^3"  "Ry > eV" '

    fitdata = np.polyfit(VV**(-2./3.), EE, 3, full=True)

    ssr = fitdata[1]
    sst = np.sum((EE - np.average(EE))**2.)
    residuals0 = ssr/sst
    deriv0 = np.poly1d(fitdata[0])
    deriv1 = np.polyder(deriv0, 1)
    deriv2 = np.polyder(deriv1, 1)
    deriv3 = np.polyder(deriv2, 1)

    volume0 = 0
    x = 0
    for x in np.roots(deriv1):
        if x > 0 and deriv2(x) > 0:
            volume0 = x**(-3./2.)
            energy0 = fitdata[0][0]*x*x*x + fitdata[0][1]*x*x + fitdata[0][2]*x + fitdata[0][3]
            break

    if volume0 == 0:
        print('Error: No minimum could be found')
        exit()

    derivV2 = 4./9. * x**5. * deriv2(x)
    derivV3 = (-20./9. * x**(13./2.) * deriv2(x) -
        8./27. * x**(15./2.) * deriv3(x))
    
    echarge = 1.60217733e-19 ; unitconv = echarge * 1.0e21
    
    bulk_modulus0 = unitconv * derivV2 / x**(3./2.)
    bulk_deriv0 = -1 - x**(-3./2.) * derivV3 / derivV2
    
    vfit = np.linspace(min(VV),max(VV),400);
    
    vv = (volume0 / vfit) ** (2. / 3)
    ff = vv - 1.0
    efit = energy0 + 9. * (bulk_modulus0 / unitconv) * volume0 / 16.0 * (ff ** 3 * bulk_deriv0+ (6.0 - 4.0 * vv) * ff ** 2)
    pfit = 3. * (bulk_modulus0) / 2. * ((volume0 / vfit) ** (7. / 3) - (volume0 / vfit) ** (5. / 3)) * (1 + 3. * ff * (bulk_deriv0 - 4) / 4.)

    v0, e0, b0, bp, res, vd, ed, vf, ef, pf =  volume0, energy0, bulk_modulus0, bulk_deriv0, round(residuals0,7), VV, EE, vfit, efit, pfit
    
    if savekey == 1:
        np.savez('ev.npz', v0=v0, e0=e0, b0=b0, bp=bp, res=res, vd=vd, ed=ed, vf=vf, ef=ef, pf=pf)

    return v0, e0, b0, bp, res, vd, ed, vf, ef, pf


data = np.loadtxt(evin, usecols=(0, 1))
v0, e0, b0, bp, res, vd, ed, vf, ef, pf = BM(data,formatkey,savekey)


if isinstance(pf[0], complex):
    print(" Complex pressure !!!!")
    print(" This potential is really BAD Kanchan !!!")
    sys.exit(1)

out = np.column_stack((vf*6.74833449394997,pf))
#out = np.column_stack((vf,pf))
np.savetxt('qerun.out', out, delimiter=" ", fmt="%10.4f   %10.5f ") 

out = np.column_stack((v0*6.74833449394997,b0,bp))
#out = np.column_stack((v0,b0,bp))
np.savetxt('bm.out', out, delimiter=" ", fmt="%10.4f   %10.5f   %10.5f ") 

subprocess.call('cat bm.out >> qerun.out', shell=True)
subprocess.call('rm -rf bm.out', shell=True)
