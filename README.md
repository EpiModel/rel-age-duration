# Relational Duration and the Age of Active Relationships

This Shiny app demonstrates the connection between relational duration (how long a relationship lasts) and relational age (how old an ongoing relationship is when observed). It is a teaching tool from the [Network Modeling for Epidemics](https://epimodel.github.io/sismid/) course and the broader EpiModel ecosystem.

Available at: https://epimodel.github.io/rel-age-duration

## The idea

When we sample the relationships that are active (ongoing) on a given day, we are more likely to observe long relationships than short ones, so the relationships we see are not a representative draw from the full duration distribution. The app makes this concrete: it simulates a set of relationships, picks a random observation day, and compares the durations of all relationships against the durations of those active on that day.

It also illustrates the counter-intuitive behavior of memoryless distributions. Because the model runs in discrete time, the relevant case is the geometric distribution (the discrete-time analogue of the exponential). For geometrically distributed durations, the expected age of an active relationship equals the overall mean duration, rather than being shorter than it as intuition might suggest.

## Using the app

Adjust the parameters in the sidebar:

- Window size: the span of time over which relationships can start.
- Expected relational duration: the target mean duration of a relationship.
- Number of relations: how many relationships to simulate.
- Duration distribution: geometric, uniform, or all equal.

For the relationships active on a randomly chosen observation day, the app reports their mean age, mean time remaining, and mean total duration, each compared against the overall mean duration.

## Authors

- Steven M. Goodreau, University of Washington
- Samuel M. Jenness, Emory University

See the full EpiModel team at [epimodel.org/team](https://www.epimodel.org/team.html).

## About

This app is part of the [EpiModel](https://www.epimodel.org/) ecosystem and is built with [Shiny](https://shiny.posit.co/) and [shinylive](https://posit-dev.github.io/r-shinylive/). It is released under the GPL-3 license, consistent with the EpiModel ecosystem.
