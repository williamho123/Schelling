# Schelling Simulation

Thomas Schelling's spatial proximity segregation [model](https://www.stat.berkeley.edu/~aldous/157/Papers/Schelling_Seg_Models.pdf) as an agent-based simulation. Written in MATLAB.

This simulation supports interactions between two mock groups conveniently assigned the colors red and blue. All parameters can be specified in order to tailor to each simulation's requirements.

## Getting Started

The main simulation is started from the `Schelling_Simulation.m` file. The sole function defined in the file, 

```
function result = Schelling_Simulation(pn,prrown,prrother,pbrown,pbrother,pred,pblue,prounds)
```

has arguments that are specified as follows:

```
pn        ->  N x N grid for the world of agents
prrown    ->  In-group preference for red agents (as a percentage)
prrother  ->  Out-group preference for red agents (as a percentage)
pbrown    ->  In-group preference for blue agents (as a percentage)
pbrother  ->  Out-group preference for blue agents (as a percentage)
pred      ->  Number of red agents
pblue     ->  Number of blue agents
prounds   ->  Number of rounds this simulation should run
```

Three preconditions must be met for the simulation to run as expected:

```
1. prrown + prrother <= 1
2. pbrown + pbrother <= 1
3. pred + pblue < pn * pn (ideally about 20% less)
```

After the simulation is complete, the `result` matrix contains simulation statistics (all for ith round):

```
1. Total Population Satisfied
2. Percent Red Agents Satisfied (average)
3. Percent Blue Agents Satisfied (average)
4. Percent Others for Red Agents (average)
5. Percent Others for Blue Agents (average)
6. Percent Others for Total Population (average)
7. Index of Dissimilarity
```

If you would like to see a visual representation of the simulation (before & after), then remove the comments around the code section dealing with figures and plots.

## Further

The `sim_multiple.m` file allows for running the Schelling simulation with a different set of parameters all at once and then consolidating statistics across the runs for the 5th, 50th, and 95th percentiles.

The code is extensively documented if you would like to see how the simulation is run.
