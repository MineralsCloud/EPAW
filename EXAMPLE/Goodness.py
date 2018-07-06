#!/usr/bin/python
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERATE PV DATA FROM EV DATA THROUGH BM FITTING
# CALCULATE DIFFERENCE BETWEEN TWO CURVE AS OBJECTIVE FUNCTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
from   sys   import stdin
from sys import argv
from   math  import sqrt
from   math  import factorial
from   pylab import *
from scipy.integrate import simps
import pylab             as pyl
import numpy  as np            
import sys
import os  
import math 
import numpy
import subprocess
from   scipy import *
from   scipy.optimize import leastsq
from scipy import integrate
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#subprocess.call('rm -rf q.out', shell=True)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# READ DATA FROM FILE
def readtwocol(file,col1,col2):
    f = open(file,"r")
    d1 = [] ; d2 = []
    while True:
        line = f.readline()
        line = line.strip()
        if len(line) == 0: break
        if line[0] == '#': continue
        if line[0] == '%': continue
        if line[0] == '&': continue  
        d1.append(float(line.split()[col1-1]))
        d2.append(float(line.split()[col2-1]))        
    #d1 = numpy.array(d1) ; d2 = numpy.array(d2)
    return d1, d2
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
formatkey=0 #for VASP 1 else 0
savekey=0
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# adapted from Delta_v3-0 package off Ugent
def BM(data,formatkey,savekey,NVPOINTS,Vmin,Vmax):

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
    
 #   vfit = np.linspace(min(VV),max(VV),NVPOINTS);
    vfit = np.linspace(Vmin,Vmax,NVPOINTS);
    
    vv = (volume0 / vfit) ** (2. / 3)
    ff = vv - 1.0
    efit = energy0 + 9. * (bulk_modulus0 / unitconv) * volume0 / 16.0 * (ff ** 3 * bulk_deriv0+ (6.0 - 4.0 * vv) * ff ** 2)
    pfit = 3. * (bulk_modulus0) / 2. * ((volume0 / vfit) ** (7. / 3) - (volume0 / vfit) ** (5. / 3)) * (1 + 3. * ff * (bulk_deriv0 - 4) / 4.)

    v0, e0, b0, bp, res, vd, ed, vf, ef, pf =  volume0, energy0, bulk_modulus0, bulk_deriv0, round(residuals0,7), VV, EE, vfit, efit, pfit
    
    if savekey == 1:
        np.savez('ev.npz', v0=v0, e0=e0, b0=b0, bp=bp, res=res, vd=vd, ed=ed, vf=vf, ef=ef, pf=pf)

    return v0, e0, b0, bp, res, vd, ed, vf, ef, pf
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NUMBER OF EQUIDISTANT VOLUME POINTS AT WHICH FITTED PRESSURE WILL BE CALCULATED : NVPOINT
NVPOINTS=50000
###################
datax = np.loadtxt('3_EOSOPTIMIZE/SUPERINDIVIDUAL/ev.in', usecols=(0, 1))
xmx1=  max(datax[:,0])# comment for vasp
xmn1=  min(datax[:,0])# comment for vasp
###################
dataw = np.loadtxt('IN_TARGET', usecols=(0, 1))
wmx1=  max(dataw[:,0])
wmn1=  min(dataw[:,0])
Vmax=min(xmx1,wmx1)/6.74833449394997
Vmin=max(xmn1,wmn1)/6.74833449394997
###################
v0, e0, b0, bp, res, vd, ed, vf, ef, pf = BM(datax,formatkey,savekey,NVPOINTS,Vmin,Vmax)
formatkey=0
v0w, e0w, b0w, b1w, resw, vdw, edw, vfw, efw, pfw = BM(dataw,formatkey,savekey,NVPOINTS,Vmin,Vmax)
###################
eshift=e0-e0w
esftw=efw+eshift
###################  
dif = lambda s: [x-s[i] for i,x in enumerate(s[1:])]
difn = lambda s, n: difn(dif(s), n-1) if n else s
##
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# arc length for difference curve : P-V curve(dDp), E-V curve(dDe), Eshift-V(ddesftvw) curve curve by Summation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DP=abs(pfw- pf)
DE=abs(efw- ef)
DshE=abs(esftw- ef)
dV=(Vmax-Vmin)/(NVPOINTS-1)
###################
dDp=difn(DP,1)#P-V curve(dpvw)
dds1w=dDp/dV
dds2w =sqrt(1+(dds1w*dds1w))*dV
LDPV=np.sum(dds2w)
#I1 = integrate.simps(ds2w, vfw)
dDe=difn(DE,1)#E-V curve(devw)
dds3w=dDe/dV
dds4w =sqrt(1+(dds3w*dds3w))*dV
LDEV=np.sum(dds4w)
#I2 = integrate.simps(devw, dvW)
ddesftvw=difn(DshE,1)#Eshift-V(desftvw) should be same as E-V curve(devw)
dds5w=ddesftvw/dV
dds6w =sqrt(1+(dds5w*dds5w))*dV
LDEsV=np.sum(dds6w)
#I2 = integrate.simps(desftvw, dvW)

###################
DPww=abs(pfw- pfw)
dDpww=difn(DPww,1)#P-V curve(dpvw)
dds1ww=dDpww/dV
dds2ww =sqrt(1+(dds1ww*dds1ww))*dV
LDPVww=np.sum(dds2ww)
#
dDeww=difn(DPww,1)#E-V curve(devw)
dds3ww=dDeww/dV
dds4ww =sqrt(1+(dds3ww*dds3ww))*dV
LDEVww=np.sum(dds4ww)


#%%%%%%%%%%%%%%%%%
DP=abs(pfw- pf)*dV
DE=abs(efw- ef)
DshE=abs(esftw- ef)*dV

ADEs=np.sum(DshE)/(Vmax-Vmin)
ADP=np.sum(DP)/(Vmax-Vmin)

Delta_U_P=ADP*(LDPV/LDPVww)
Delta_U_Es=ADEs*(LDEsV/LDEVww)

print " "
print "# Please see K. Sarkar et al. Journal of Computational Physics 347 (2017) 39-55"
print "# Page number 51 for the following goodness measures of a data-set performance. "
print " "
print "A(Delta E) ==>  ",ADEs
print "L(Delta E) ==>  ",LDEsV/(Vmax-Vmin)
print "Delta_U(E) ==>  ",Delta_U_Es
print " "
print " "
print "A(Delta P) ==>  ",ADP
print "L(Delta P) ==>  ",LDPV/(Vmax-Vmin)
print "Delta_U(P) ==>  ",Delta_U_P
print " "



# NUMBER OF EQUIDISTANT VOLUME POINTS AT WHICH FITTED PRESSURE WILL BE CALCULATED : NVPOINT
NVPOINTS=45
###################
v0, e0, b0, bp, res, vd, ed, vf, ef, pf = BM(datax,formatkey,savekey,NVPOINTS,Vmin,Vmax)
v0w, e0w, b0w, b1w, resw, vdw, edw, vfw, efw, pfw = BM(dataw,formatkey,savekey,NVPOINTS,Vmin,Vmax)


sm= np.sum((pfw- pf) *   (pfw- pf))
smm=  (pfw- pf) * (pfw- pf)
smmm= sm/( Vmax*6.74833449394997 -  Vmin*6.74833449394997   )

# Difference with target EoS for fitted equidistant volume points
diffrnc=sqrt(smm)

out = np.column_stack((vf*6.74833449394997,diffrnc))
print " "
print "# Difference with target EoS for fitted equidistant volume points "
print "# Divide the volume by number of atoms in the unit-cell when required "
print " "
print "#       Volume       pressure (GPa) "
print "# "
print out
#np.savetxt('Difference.out', out, delimiter=" ", fmt="%10.5f     %10.5f") 
