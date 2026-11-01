# BESS-matlab
MATLAB Simulation of BESS Dispatch Using Rule Based and LP Methods. Simulations I built while reading up on battery storage optimization before a research internship. Work in progress!!...
MATLAB study of rule-based battery energy storage dispatch; LP optimisation planned
---

## Project 1 — Rule based dispatch

### What this does
runs a 24 hour simulation of a small battery (100 kwh) 
connected to a building and some rooftop solar. no 
optimization -just simple logic: if solar is producing 
more than needed, charge the battery. if not, use it.

### What I found
The battery drained itself in the first 5 hours (1am to 
5am) when the building load was actually pretty low. by 
the time the evening peak hit around hour 17-20 where 
grid import was highest, the battery was already empty 
and couldn't do anything useful.

So the rule based approach kind of does the opposite of 
what you'd want -- wastes the charge when its not needed 
and has nothing left when it is.

### Next step
Project 2 will use linear programming (linprog) to 
actually optimize when to charge and discharge based on 
electricity prices. should fix this problem.

### Setup
Just run dispatch_rule.m in matlab. no toolboxes needed.

### Parameters used
- capacity: 100 kwh
- max power: 50 kw
- efficiency: 95%
- soc range: 20 to 90%
- starting soc: 50%
