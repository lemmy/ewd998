1) Set of all permutations of {"T","L","A"} including repetitions.
    [{0,1,2} -> {"T","L","A"}] or [0..2 -> {"T","L","A"}]
2) All pairs (including repetitions) of the natural numbers (think: a two-digit lock).
    [1..2 -> 0..9] or [1..2 -> Nat]
3) All triples... 
    [1..3 -> 0..9] or [1..3 -> Nat]
4) ...without repetitions

5) Set of all pairs and triples...
    [1..2 -> Nat] \cup [1..3 -> Nat]

---- MODULE F ----

TBD == TRUE

==================
