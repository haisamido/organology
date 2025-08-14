#!/usr/bin/env python3

import math
import matplotlib.pyplot as plt
import numpy as np

# Objectives:
#   code:
#     https://drive.google.com/file/d/19aP8p5_P4ctM7Y8fg74ErdViTrfGOENZ/view?usp=share_link
#     Below equation numbers come from this link ^^^
#

# Sources: 
#   https://inside-guitar.com/the-ultimate-guide-to-classical-guitar-strings/
#   https://euphonics.org/publication-list-jim-woodhouse/
#   https://www.ingentaconnect.com/contentone/dav/aaua/2019/00000105/00000003/art00012
#   https://www.ingentaconnect.com/content/dav/aaua/2019/00000105/00000003/art00012#
#   https://drive.google.com/file/d/19aP8p5_P4ctM7Y8fg74ErdViTrfGOENZ/view?usp=share_link
#   https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5459001/
#   https://publicwebuploads.uwec.edu/documents/Musical-string-inharmonicity-Chris-Murray.pdf
π = pi =math.pi

def area(d):
    # String cross-sectional area, m**2
    return π*(d**2)/4

def mass(d,L,rho):
    # Calculate string mass per scale length
    #   rho in kg/m**3
    #   d in m
    #   L in m
    return rho * (π*(d**2)/4) * L

def diameter_from_fltr(f,L,T,rho,n):
    # Return diameter if f, L, T, rho, and n are known
    return (n/(f*L))*math.sqrt(T/(rho*pi))

# https://courses.physics.illinois.edu/phys406/sp2017/Lecture_Notes/Waves/PDF_FIles/Waves_2.pdf
def diameter_from_Z0():
    # Z0 = πρd2α/2

    return 1

def mu(mass,L):
    # Calculate μ = mass / L
    # linear mass density
    return mass/L

#------------------------------------------------------------------------------
# Tension calculations
#------------------------------------------------------------------------------
def tension_from_flmu(f,L,mu,n):
    # Equation 1: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5459001/
    return mu *((2 * f * L)/n)**2

def tension_from_fldr(f,L,d,rho):
    # Tension from frequency, length, diameter, and density
    # Page 522
    return π * rho * d**2 * (f*L)**2

def tension_from_ds(d,sigma):
    # Tension from diameter (m), and stress (Pa)
    # Page 522
    return π * d**2 * sigma/4

def tension_from_vmu(v,mu):
    # Tension from wave velocity, and μ == mu
    return mu*v**2
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Velocity calculations
#------------------------------------------------------------------------------
def velocity_from_fl(f,L,n):
    # Return wave velocity when frequency and length are known
    #   f == Hz
    #   L == m
    #   n == nth harmonic
    #   v == m/s
    return 2*f*L*n

def velocity_from_tmu(T,mu):
    # Return wave velocity when tension and μ (mu) are provided
    #   T == N
    #   μ == mu == kg unit lengthe
    #   v == m/s
    return math.sqrt(T/mu)
#------------------------------------------------------------------------------

def mu_from_tension(f,L,T,n):
    return T/(2*f*L/n)**2

def alpha(f,L):
    # Equation 18: α = Lf on page 521
    # Units: m/s**2
    return f*L

def β(d,L):
    # Equation 18: β = d/L on page 521
    # Units: none
    return d/L

#------------------------------------------------------------------------------
# σ stress
#------------------------------------------------------------------------------
def sigma_from_flr(f,L,rho,n):
    # Equation 19: String Stress
    # Units: N/m**2 or pascal (Pa)
    return 4 * rho * ((f*L)**2)/n

def sigma_from_ta(T,A):
    # Sigma derived from Tension and Area
    return T/A
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Young's Modulous
#------------------------------------------------------------------------------
def E(sigma):
    # Equation 16: Young'e Modulous, page 519
    # Units: σ, sigma, is in GPa
    # Ep ≈ 3.2 + 41σ GPa, (fluorocarbon).
    return 4.5 + 39 * sigma + 0.25
#------------------------------------------------------------------------------

def λ(E,d,n,rho,L,f):
    # Equation 7: governs the degree of inharmonicity
    #
    # "λ also governs the degree of inharmonicity of a string. This
    # means that design guidelines based on a threshold value
    # of λ will set a limit on inharmonicity as well as damp-
    # ing. Both damping and inharmonicity have been associ-
    # ated in earlier literature with the perceptual discrimination
    # of “warmth” versus “brightness”. The damping roll-off af-
    # fects the spectral centroid, and there is a well-established
    # correlation of perceived brightness with variation in spec-"
    return ( E * (π**2) * (d**2) * (n**2) ) / ( 64 * rho * (L**4) * (f**2) )

def gama(T,L):
    # Equation 10: the "feel", gama = Fp/δ ≈ 4T/L
    return 4 * T/L

def Z0(f,L,d,rho):
     # Equation 8: Z0 = π rho d**2alpha/2, wave impedance, page 517
     # "If one wished to select a set of strings with constant impedance, 
     # in the interests of equal loud-ness, these lines indicate the 
     # trend that should be followed." page 522
     return ( π * (d**2) * rho * f * L )/ 2

#
# Pitches
#
def frequency(f0,a,n):
    # https://pages.mtu.edu/~suits/NoteFreqCalcs.html
    # https://pages.mtu.edu/~suits/notefreqs.html
    # n = the number of half intervals away from the fixed note you are
    f = f0 * (a)**n
    return f

def nth_root_of_2(n):
    return (2)**(1/n)

# Below semi-tone intervals would only work with a starting point of pitch G2
intervals = np.array([ 0, 2, 4, 5, 7, 9,10])
intervals = np.append(intervals, [12,14,16,17,19,21,22])
intervals = np.append(intervals, [24,26,28,29,31,33,34])
intervals = np.append(intervals, [36,38,40,41,43])

a  = nth_root_of_2(12)
f0 = 98

frequencies = frequency(f0,a,intervals)

#print(frequencies)
#print(np.transpose(intervals))
#print(frequency(f0,a,intervals))

rho = 1800
d = 0.00088
n = 1
f = 261.6
L = 0.550
A = area(d)

mass = mass(d,L,rho)
mu   = mu(mass,L)

Tf     = tension_from_flmu(f,L,mu,n)
stress = sigma_from_ta(Tf,A)
vt     = velocity_from_tmu(Tf,mu)
vf     = velocity_from_fl(f,L,n)
Tv     = tension_from_vmu(vt,mu)

#print("XXXXXX",diameter_from_fltr(f,L,Tf,rho,n))

#print(mass,mu,Tf,f*L, stress,vt,vf, Tv)

alpha = alpha(f,L)
T= tension_from_fldr(f,L,d,rho)
gama  = gama(T,L)
β     = β(d,L)

sigma     = sigma_from_flr(f,L,rho,n)
sigma_GPa = sigma/1000000000

E  = E(sigma_GPa)
λ  = λ(E,d,n,rho,L,f)

y0 = 0.755
yf = 0.165

x0 = 0.000
xf = 0.393

dx = xf/25

f0=98
x  = np.arange(0., xf, dx)
x  = np.append(x, xf)

y = ((yf-y0)/xf) * x + y0
Ls = y

# Desired tension for all strings
T0 = 100

diameters = diameter_from_fltr(frequencies,Ls,T0,rho,n)
Z0s       = Z0(frequencies,Ls,diameters,rho)

def generate_course_strings(diameters,Ls):
    course=1
    # Below semi-tone intervals would only work with a starting point of pitch G2
    intervals = np.array([ 0, 2, 4, 5, 7, 9,10])
    intervals = np.append(intervals, [12,14,16,17,19,21,22])
    intervals = np.append(intervals, [24,26,28,29,31,33,34])
    intervals = np.append(intervals, [36,38,40,41,43])

    a  = nth_root_of_2(12)
    f0 = 98

    frequencies = frequency(f0,a,intervals)
    for freq in frequencies:
        for string in range(1,4):
            print("%s,%s,%d,%d,%6.2f,%6.4f,%5.3f,%6.2f,%s" %("qanun","turkish",course,string,freq,Ls[course-1],1000*diameters[course-1],1800,"flurocarbon nylon"))
        course += 1

generate_course_strings(diameters,Ls)

print("frequencies = \n",frequencies)
print("Ls = \n", Ls)
print("diameters = \n",1000*diameters)
print("wave impedance =\n", Z0s)
#print(frequencies, Ls, 1000*diameters,Z0s)

#print(diameter_from_fltr(98,.755,T0,rho,n))

#print(x,y)
#alpha   = np.arange(0., 300., 10.)
#d       = np.arange(0., 0.003, .0001)
#T       = π * rho * d**2 * alpha**2
#Z0      = ( π * (d**2) * rho * alpha )/ 2

#print(alpha,T,d)
#plt.plot( frequencies, Z0s)
#plt.show()
