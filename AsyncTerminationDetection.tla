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

\* TODO Fire up the TLA+ repl (`tlcrepl` in the Terminal > New Terminal) and 
 \* TODO find out what TLC returns for the following expressions:
 \* TODO 23 = "frob"
 \* TODO 23 # "frob"                       \* # is pretty-printed as ≠
 \* TODO {1,2,2,3,3} = {3,1,1,2,3,1}
 \* TODO 1 \div 4
 \* TODO 1 \div 0
 \* TODO {1,2,3} \cap {2,3,4}              \* \cap pp'ed as ∩
 \* TODO {1,2,3} \cup {2,3,4}              \* \cap pp'ed as ∪
 \* TODO {1,2,3} \ {2,3,4}
 \* TODO 23 \in {0}                        \* \in pp'ed as ∈
 \* TODO 23 \in {23, "frob"}
 \* TODO 23 \in {23} \ 23
 \* TODO 23 \in {23} \ {23}
 \* TODO 23 \notin {23} \ {23}
 \* TODO 10 \in 1..10

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

-----------------------------------------------------------------------------

\* * Each one of the actions below represent atomic transitions, i.e., define
 \* * the next state of the current behavior (a state is an assignment of
 \* * values to variables). Two or more actions do *not* happen simultaneously;
 \* * if we want to e.g. model things to happen at two nodes at once, we are free
 \* * to choose an appropriate level of granularity for those actions.

\* * Node i terminates.
Terminate(i) ==
    UNCHANGED vars \* Short-hand saying that the variables do not change.

\* * Node i sends a message to node j.
SendMsg(i, j) ==
    UNCHANGED vars

\* * Node I receives a message.
Wakeup(i) ==
    UNCHANGED vars

=============================================================================
