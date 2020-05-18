#! /usr/bin/env python3
#
# Integrates the equations of the mathematical pendulum
# using two different Euler methods.
#
# usage: ./euler-pendel.py <h=0.05>#
# $ apt install python3-matplotlib python3-tk

import math
import matplotlib.pyplot as plt
import sys

q0 = 0.1    # Initial angle
p0 = 0.    # Initial momentum
m = 1.0    # Mass
l = 0.1     # Length of the pendulum
g = 9.81   # Gravitational acceleration

h = 0.05   # Time step size
T = 1000.     # Final time

# Read command-line arguments
if len(sys.argv) > 1:
    h = float(sys.argv[1])

# Right-hand side
def minus_dHdq(p,q):
    return + m * g * l * math.sin(q)

def dHdp(p,q):
    return p / (m*l**2)

# Exact energy for comparison
def energy(p,q):
    return p**2 / (2*m*l**2) + m*g*l*math.cos(q)

# =========

# Create a time grid (for visualization only)
def getX(τ, T):
    # returns vector (x₀, x₁, ..., xₙ = T)
    x = []
    xᵢ = 0.   # Initial time
    while xᵢ < T:
        x.append(xᵢ)
        xᵢ += τ
    x.append(T)
    return x

# Explicit Euler:
# ===============
def explicit(p0, q0, h):
    p = [p0]
    q = [q0]
    for i in range(0, len(x)-1):
        pᵢ = p[i] + h * minus_dHdq(p[i],q[i])
        qᵢ = q[i] + h *       dHdp(p[i],q[i])
        p.append(pᵢ)
        q.append(qᵢ)
    return [p,q]

# Symplectic Euler:
# ===============
def symplectic(p0, q0, h):
    p = [p0]
    q = [q0]
    for i in range(0, len(x)-1):
        pᵢ = p[i] + h * minus_dHdq(p[i],q[i])    # First argument should be p[i+1], but is not used anyway
        qᵢ = q[i] + h *       dHdp(pᵢ,q[i])
        p.append(pᵢ)
        q.append(qᵢ)
    return [p,q]

# ==================================

x = getX(h, T)
[p_exp, q_exp] = explicit(p0, q0, h)
[p_sym, q_sym] = symplectic(p0, q0, h)

# The energy of the exact solution: it is a constant
yᵣ = [ energy(p0,q0) for xᵢ in x ]

# The energy of the explicit Euler method
energy_exp = []
for i in range(0, len(p_exp)):
    energy_exp.append(energy(p_exp[i], q_exp[i]))

# The energy of the symplectic Euler method
energy_sym = []
for i in range(0, len(p_sym)):
    energy_sym.append(energy(p_sym[i], q_sym[i]))

# Plot pendulum positions
plt.figure(1)
#plt.plot(x, q_exp, linewidth=2, label="explicit")
plt.plot(x, q_sym, linewidth=2, label="symplectic")
plt.legend()
#plt.show()

# Plot total energy
plt.figure(2)
plt.ylim(0,2)
#plt.plot(x, energy_exp, linewidth=2, label="explicit")
plt.plot(x, energy_sym, linewidth=1, label="symplectic")
plt.plot(x, yᵣ, linewidth=1, label="exact")
plt.legend()
plt.show()
