# Overview

Abstract machine

~ Something to write programs for

Practical machine

~ A finite state automaton, to compile programs to

Theoretical machine

~ Maths of mappings of sequences


# Machines

## Abstract 

Suppose `State`, `In`, and `Out` are types, each of which is inhabited by only
finitely many values. 

An *abstract machine* is a function, 

```
m :: In x State -> Out x (1 + State)
```

and a distinguished value `S0 :: State`. Here, `1` is the unit type, intended to
indicate that the machine has terminated:

```
1 + State = Stop | Run State 
```

Abstract machines can be used to map sequences to sequences. Let $u$ be some
sequence $(a, b, c, \dotsc)$ with values in `In`. The output sequence, $y_1,
y_2, \dotsc$ (with values in `Out`) is:

    (S_1, y1) = m(S_0, a);
    (S_2, y2) = m(S_1, b);
    (S_3, y3) = m(S_2, c); 
    ...

and terminates when `S_n == Stop`.

The idea is to write programs that compile to abstract machines, then compile
the abstract machine to a finite state automaton.


## Practical

A *practical machine* is a finite directed graph $(S, e)$ with nodes $S$ and
labelled edges $e$, and distinguished nodes $S_0$ and $S_\text{stop}$, such
that:

  1. Every edge is labelled with a pair $(x, y)$, where $x$ is a symbol from
     some alphabet and and $y$ a symbol from some (possibly different) alphabet;
       
  3. From every node except $S_\text{stop}$, and for each $x$ in the alphabet of
     input symbols, there is exactly one edge labelled $(x, ...)$.

Abstract machines also map sequences to sequences. To do so, one starts at
$S_0$. Then, for each symbol in the input sequences, one follows the arrow
labelled with that symbol (of which there is precisely one) and emits the
corresponding $y$. Continue until the node $S_\text{stop}$ is reached, then
stop.

Both abstract machines and practical machines map sequences to sequences. 


## Theoretical

A *theoretical machine* maps finite sequences of symbols (from some alphabet) to
finite sequences of symbols (from some possibily different alphabet), subject to
a couple of conditions. To state these conditions, a few definitions are
required.

For any two sequences, $u$ and $v$, write $uv$ for the catenation of $u$ and
$v$; that is, the sequence whose symbols are those of $u$ followed by those of
$v$. For sequences $u$ and $v$ write $u\leq v$ if $u$ is a prefix of $v$; that
is, if there is some $s$ such that $v = us$. (Note that "$\leq$"is a partial
ordering.) For sequences $u\leq v$, write $u^{-1}v$ for "the part of $v$
following $u$". Write $|u|$ for the length of $u$. Finally, $\epsilon$ is the
empty sequence.

Then the conditions that a theoretical machine, $\mu$, must satisfy are:

1. (Strictness) $\mu(\epsilon) = \epsilon$. 

2. (Determinism) $u\leq v$ implies $\mu(u) \leq \mu(v)$;
   
3. (Finiteness) There exists an integer $N$ (dependent on $\mu$) such that for
   any sequence $s$ longer than $N$, there is a prefix $u$, with $s = uv$, such
   that:
       
       i. $1 \leq |v| \leq N$;
       ii. For any $w$, $\mu(s)^{-1} \mu(sw) = \mu(u)^{-1}\mu(uw)$.
       
The third condition says that the result of applying $\mu$ to any sequence after
a certain point is the same as it would be if you applied $\mu$ to a shorter
subsequence first. Or, you only need to know the result of $\mu$ on sequences no
longer than $N$.


Assertion (unproven): all three machines are equivalent.


# Programming the abstract machine

## Primitives

The machine `stop` has state `S0 = Stop` and inputs and outputs `In = Out =
Void`.

The machine `id` of type `In` copies its input to its output once, and then
stops.

The machine `const A` of type `In` produces `A` for any input in `In`. 


## Combinators

`m1; m2` does `m1` then `m2`, replacing the `Stop` state of `m1` with the
initial state of `m2`. Both machines must have the same input and output
alphabets.

`repeat m1` is `m1; m1; m1; ...`.

`m1 & m2` does `m1` and `m2` in parallel. Inputs are `In1 x In2` and outputs are
`Out1 x Out2`.

`m1 | m2` does the same, but inputs are `In1 | In2` and outputs are `Out1 |
Out2`.

`m1 => m2` "pipes" the input into `m1`, then into `m2`. Must have `Out1 = In2`.


## Abstraction? 


## Full state description

In general, an abstract machine is (must be) of the form

```
let X = (a -> x | 
         b -> B | 
         c -> C | 
         ...)
    Y = (a -> A' | 
         b -> y  |
         ...)
    Z = (a -> STOP |
         ...)
        ...
in START = X
```

where every state has the full alphabet; and A, B, ... are one of X, Y, ...








Suppose `m1` and `m2` are two abstract machines, with states and alphabets
respectively `State1`, `State2`, `In1`, `In2`, `Out1`, and `Out2`.






In principle, that's all one needs. To "compile" this program, we execute `main`
with an initial `WorldState` and all possible `Event`s. That produces a new set
of `WorldState`s (which are remembered) and one then executes `main` on those
`WorldState`s, again with all possible `Event`s. Eventually no new `WorldState`s
are generated. At this point one can generate the corresponding finite state
machine: the states are the generated `WorldState`s, and the transitions are
given by the application of `main`.

The nice thing here is that one can use any language features one likes to write
`main` -- as long as it terminates and produces only finitely many
`WorldStates`, the process above will produce a FSM.

I think it might be convenient to restrict `WorldState` so that is demonstrably
finite. For example, it could be: finite coproducts, finite products, or a unit
type.

(One could imagine interesting techniques that use the "Effect" as an instruction
to the runtime to raise a particular "Event", allowing the program to
communicate with itself. Though perhaps that crosses some boundary.)

Also, I think there might a nice "composability" approach. For example, suppose
we have two little programs

    prog1 :: WS_1 Event_1 -> WS_1 Effect_1
    
    prog2 :: WS_2 Event_2 -> WS_2 Effect_2
    
then a possible compound program is: "do `prog1` and `prog2` at the same
time". (They don't interfere with each other, because they have different Event
and Effect sets.)

The type of this program is 

    (WS_1 x WS_2) (Event_1 x Event_2) -> (WS_1 x WS_2) (Effect_1 x Effect_2)
    
where "x" is the product type operator. 

Another possibility -- when the events and effects are the same for both `prog`s
-- is: "do `prog1` and then, when it's finished, do `prog2`".





spinbar :: five-tick -> Display

spinbar = 
    loop
        do
            on five-tick (display "|");
            on five-tick (display "/");
            on five-tick (display "-");
            on five-tick (display "\");

room = 
    loop
        on enter-L1 (run spinbar)


If WS is a product, then we're "running the different bits in parallel". In this
case, the events and effects should be a disjoint union (so there's no interference).

If WS is a coproduct, then we're dispatching on the type of WS to the
appropriate function. In this case, the events and effects should be a product
(?) because we return the empty transition for the functions not selected.














