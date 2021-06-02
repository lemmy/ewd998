---------------------- MODULE AsyncTerminationDetection_apalache ---------------
\* This module contains special setup for Apalache.

\* Fix the number of nodes, as Apalache works with bounded sets
N == 20

\* A copy of variables from AsyncTerminationDetection,
\* in order to define an instance
VARIABLES 
  \* @type: Int -> Bool;
  active,
  \* @type: Int -> Int;
  pending,
  \* @type: Bool;
  terminationDetected

\* Introduce an instance with N fixed
INSTANCE AsyncTerminationDetection

\* We want to prove the temporal property Stable, which is defined as:
\*
\* Stable == [](terminationDetected => []terminated)
\*
\* For the moment, Apalache supports only invariant checking.
\* Nevertheless, we can prove the property Stable with Apalache.
\* If we look carefully at the temporal formula Stable,
\* we can see that it is sufficient to prove the following:
\*
\* 1. Init => StableInv
\* 2. StableInv /\ Next => StableInv'
\* 3. StableInv /\ Next => StableActionInv
\*
\* We can check that by issuing the following three queries:
\*
\* $ apalache-mc check --init=Init --inv=StableInv --length=1 \
\*    AsyncTerminationDetection_apalache.tla
\* $ apalache-mc check --init=StableInv --inv=StableInv --length=2 \
\*    AsyncTerminationDetection_apalache.tla
\* $ apalache-mc check --init=StableInv --inv=StableActionInv --length=2 \
\*    AsyncTerminationDetection_apalache.tla
\*
\* We issue query 1 for a computation of length 1
\* (predicate Init is counted as a step),
\* whereas we issue queries 2-3 for computations of length 2
\* (StableInv, then Next).

\* This is a state invariant.
StableInv ==
    /\ TypeOK
    /\ (terminationDetected => terminated)

\* This is an action invariant.
StableActionInv ==    
    terminated => terminated'
=============================================================================
