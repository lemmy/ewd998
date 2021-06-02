---------------------- MODULE AsyncTerminationDetection ---------------------
\* * TLA+ is an expressive language and we usually define operators on-the-fly.
 \* * That said, the TLA+ reference guide "Specifying Systems" (download from:
 \* * https://lamport.azurewebsites.net/tla/book.html) defines a handful of
 \* * standard modules.  Additionally, a community-driven repository has been
 \* * collecting more modules (http://modules.tlapl.us). In our spec, we are
 \* * going to need operators for natural numbers.
EXTENDS Naturals

\* * A constant is a parameter of a specification. In other words, it is a
 \* * "variable" that cannot change throughout a behavior, i.e., a sequence
 \* * of states. Below, we declares N to be a constant of this spec.
 \* * We don't know what value N has or even what its type is; TLA+ is untyped and
 \* * everything is a set. In fact, even 23 and "frob" are sets and 23="frob" is 
 \* * syntactically correct.  However, we don't know what elements are in the sets 
 \* * 23 and "frob" (nor do we care). The value of 23="frob" is undefined, and TLA+
 \* * users call this a "silly expression".
CONSTANT N

\* * It's a good idea to tell readers of the spec what value we assume of constants
 \* * In this spec, we assume constant N to be a (positive) natural number, by
 \* * stating that N is in the set of Nat (defined in Naturals.tla) without 0 (zero).
 \* * Note that the TLC model-checker, which we will meet later, checks assumptions
 \* * upon startup.
ASSUME NIsPosNat == N \in Nat \ {0}

\* * A definition Id == exp defines Id to be synoymous with an expression exp.
 \* * Here, we define Node to be synoymous with the set of naturals numbers
 \* * 0 to N-1.  Semantically, Node is going to represent the ring of nodes.
 \* * Note that the definition Node is a zero-arity (parameter-less) operator.
Node == 0 .. N-1                           \* == pp'ed as ≜


\* * Contrary to constants above, variables may change value in a behavior:
 \* * The value of active may be 23 in one state and "frob" in another.
 \* * For EWD998, active will maintain the activation status of our nodes,
 \* * while pending counts the in-flight messages from other nodes that a
 \* * node has yet to receive.
VARIABLES 
  active,               \* activation status of nodes
  pending               \* number of messages pending at a node

\* * A definition that lets us refer to the spec's variables (more on it later).
vars == << active, pending >>

-----------------------------------------------------------------------------

\* * Initially, all nodes are active and no messages are pending.
Init ==
    \* * ...all nodes are active.
     \* * The TLA+ language construct below is a function. A function has a domain
     \* * and a co-domain/range. Lamport: ["In the absence of types, I don't know
     \* * what a partial function would be or why it would be useful."]
     \* * (http://discuss.tlapl.us/msg01536.html).
     \* * Here, we "map" each element in Node to the value TRUE (it is just
     \* * coincidence that the elements of Node are 0, 1, ..., N-1, which could
     \* * suggest that functions are just zero-indexed arrays found in programming
     \* * languages. As a matter of fact, the domain of a function can be any set,
     \* * even infinite ones: [n \in Nat |-> n]).
    \* * /\ is logical And (&& in programming). Conjunct lists usually make it easier
     \* * to read. However, indentation is significant!
    \* * So far, the initial predicate defined a single state.  That seems natural as
     \* * most programs usually start with all variables initialized to some fixed
     \* * value.  In a spec, we don't have to be this strict.  Instead, why not let
     \* * the system start from any (type-correct) state?
     \* * Besides, syntax to define a specific function, TLA+ also has syntax to define
     \* * a set of functions mapping from some set S (the domain) to some other set T:
     \* *   [ S -> T ] or, more concretely:  [ {0,1,2,3} -> {TRUE, FALSE} ]
    /\ active \in [ Node -> BOOLEAN ]
    /\ pending \in [ Node -> Nat ]

-----------------------------------------------------------------------------

\* * Each one of the actions below represent atomic transitions, i.e., define
 \* * the next state of the current behavior (a state is an assignment of
 \* * values to variables). Two or more actions do *not* happen simultaneously;
 \* * if we want to e.g. model things to happen at two nodes at once, we are free
 \* * to choose an appropriate level of granularity for those actions.

\* * Node i terminates.
Terminate(i) ==
    \* * Assuming active is a function (can we be sure?), function application
     \* * is denoted by square brakets.  A mathmatician would expect parens, but TLA+
     \* * uses parenthesis for (non-zero-arity) operator application.
    \* * If node i is active *in this state*, it can terminate...
    /\ active[i]
    \* * ...in the next state (the prime operator ').
    \* * The previous expression didn't say anything about the other values of the
     \* * function, or even state that active' is a function (function update).
    /\ active' = [ active EXCEPT ![i] = FALSE ]
    \* * Also, the variable active is no longer unchanged.
    /\ pending' = pending

\* * Node i sends a message to node j.
SendMsg(i, j) ==
    /\ active[i]
    /\ pending' = [pending EXCEPT ![j] = @ + 1]
    /\ UNCHANGED active

\* * Node I receives a message.
Wakeup(i) ==
    /\ pending[i] > 0
    /\ active' = [active EXCEPT ![i] = TRUE]
    /\ pending' = [pending EXCEPT ![i] = @ - 2]

-----------------------------------------------------------------------------

\* * The next-state relation should somehow plug concrete values into the 
 \* * (sub-) actions Terminate, SendMsg, and Wakeup.
Next ==
        \* * A TLA+ specification is a formula and TLC evaluates it.  With the
         \* * conjunct list, ignoring the temporal logic for now, we essentially
         \* * stated the following formula 
         \* *   /\ active = [n \in Node |-> FALSE]
         \* *   /\ active[0] = TRUE
         \* *   /\ active[1] = TRUE
         \* *   /\ active[2] = TRUE
         \* *   /\ active[3] = TRUE
         \* * which is FALSE causing TLC to terminate after printing the initial state.
        \* * (Existential/Universal) Quantification generalizes (disjunct/conjunct) lists.
    \E i,j \in Node:   
        \/ Terminate(i)
        \/ Wakeup(i)
        \* ? Is it correct to let node i send a message to node j with i = j?
        \/ SendMsg(i, j)

=============================================================================
