#! /usr/bin/env python3
# usage: ./euler.py <λ=1> <h=0.05>#
# $ apt install python3-matplotlib python3-tk

import math
import matplotlib.pyplot as plt
import sys

x0 = 0.
h = 0.05
T = 5.
λ = 1.
y0 = 1.

# Right-hand side and initial value
# y' = λ y
def f(x, y):
    return λ * y

# Analytical solution for comparison
def y(x):
    return math.exp(λ*x)

# Read command-line arguments
if len(sys.argv) > 1:
    λ = float(sys.argv[1])
if len(sys.argv) > 2:
    h = float(sys.argv[2])

# =========

def getX(τ, T):
    # returns vector (x₀, x₁, ..., xₙ = T)
    x = []
    xᵢ = x0
    while xᵢ < T:
        x.append(xᵢ)
        xᵢ += τ
    return x

# Explicit Euler:
# ===============
def explicit(f, y0, h):
    # returns vector (y₀, y₁, ..., yₙ)
    y = [y0]
    for i in range(0, len(x)-1):
        yᵢ = y[i] + h * f(x[i], y[i])
        y.append(yᵢ)
    return y

# Implicit Euler:
# ===============
def implicit(f, y0, h):
    # returns vector (y₀, y₁, ..., yₙ)
    y = [y0]
    for i in range(0, len(x)-1):
        # Only correct if f(x,y) is λy
        yᵢ = y[i] / (1 - h*λ)
        y.append(yᵢ)
    return y

# ==================================

x = getX(h, T)
yₑ = explicit(f, y0, h)
#yᵢ = implicit(f, y0, h)

# higher sample rate for exact solution
xᵣ = getX(h/10, T)
yᵣ = [ y(xᵢ) for xᵢ in xᵣ ]

fig = plt.figure(figsize=(18, 10))
plt.title('λ = ' + str(λ) +',   h = ' + str(h)  )
plt.rc('xtick', labelsize=20)
plt.rc('ytick', labelsize=20)
plt.rc('legend', fontsize=20)

plt.plot(xᵣ, yᵣ, linewidth=2, label="exact")
plt.plot(x, yₑ, linewidth=2, label="explicit")
#plt.plot(x, yᵢ, linewidth=2, label="implicit")
plt.legend()
plt.show()
#fig.savefig("explicit-euler-lambda-" + str(λ) + "-h-" + str(h) + ".pdf", bbox_inches='tight')
