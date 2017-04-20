
Anyway, here's where I've got to so far. 

Suppose `State`, `In`, and `Out` are types, each of which is inhabited by only
finitely many values. 

An *abstract machine* is a function, 
```
m :: (1 + State) x In -> (1 + State) x Out
```
Here, `1 + T` is the coproduct of the "Unit" type with T, that is
```
1 + T = Nothing | Just T
```



distinguished value $S_0$, and a distinguished set of values $S_f$, where, for
any practical machine:

    - $S$, $S'$, and $S_0$ are values of type `State`, of which there are only
      finitely many values;
      
    - $x$ is a symbol in some finite alphabet, with the addition of a special
      symbols `start` and `end`;
      
    - $ys$ is a finite list of symbols from some other finite alphabet, possibly
      empty, and possibly ending with the special symbol `end`.
      
Practical machines can be used to map finite sequences to finite sequences
too. Let $u$ be some sequence $(a, b, c, \dotsc, d)$. To do so, we compute:

    (S_1, y1) = m(S_0, start);
    (S_2, y2) = m(S_1, a);
    (S_3, y3) = m(S_2, b); 
    ...
    (S_n, yn) = m(S_n-1, `end`)

and return the catenation y1 y2 y3 ... yn.

A *theoretical machine* maps finite sequences of symbols (from some alphabet) to
finite sequences of symbols (from some possibily different alphabet), subject to
a couple of conditions. To state these conditions, a few definitions are
required.

For any two sequences, $u$ and $v$, write $uv$ for the catenation of $u$ and
$v$; that is, the sequence whose symbols are those of $u$ followed by those of
$v$. For sequences $u$ and $v$ write $u\leq v$ if $u$ is a prefix of $v$; that
is, if there is some $s$ such that $v = us$. (Note that "$\leq$"is a partial
ordering.) For sequences $u\leq v$, write $u^{-1}v$ for "the part of $v$
following $u$". Finally, write $|u|$ for the length of $u$.

Then the conditions that a theoretical machine, $\mu$, must satisfy are:

1. $u\leq v$ implies $\mu(u) \leq \mu(v)$;
   
2. There exists an integer $N$ (dependent on $\mu$) such that for any sequence
   $s$ longer than $N$, there is a prefix $u$, with $s = uv$, such that:
       
       i. $1 \leq |v| \leq N$;
       ii. For any $w$, $(\mu(s)^{-1} \mu(sw) = (\mu(u)^{-1}\mu(uw)$).
       
The first condition is called "determinism" (or "monotonicity"). It says you can
evaluate the maps bit by bit without fear that the results so far might change.

The second condition is about finiteness. It says that the result of applying
$\mu$ to any sequence after a certain point is the same as it would be if you
applied $\mu$ to a shorter subsequence first. Or, you only need to know the
result of $\mu$ on sequences no longer than $N$.




A *practical machine* is a directed graph (S, e) with nodes S and labelled edges
e, and a distinguished node $S_0$, such that:

  1. Each edge is labelled with a pair (x, ys), where x is a symbol from some
       alphabet (including the symbols `start` and `end`), and ys is a finite
       sequence from some (possibly different) alphabet (including the symbols
       `start` and `end`);
       
  2. There is only one edge from S_0; it is labelled (start, ys_0);
    
  3. From every other node, and for every symbol x, there is exactly one edge
     labelled (x, ...).

Abstract machines *also* map finite sequences to finite sequences. To do so, one
starts at S_0 and emits ys_0 (which might be empty); then, for each symbol in
the input sequences, one follows the arrow labelled with that symbol (of which
there is precisely one) and emits the corresponding ys. Continue until either 





    WorldState x Event -> WorldState x Effect
    
Here an `Event` is a signal from the runtime and an `Effect` is a signal to the
runtime. (I still haven't figured out whether "no effect" or "multiple effects"
are allowed. I think multiple effects are allowed if they are to
"no-overalapping systems". For example "turn off the lights and emit a buzz" is
fine, but "turn off the lights and turn on the lights" is not fine. Hm)







A *State* is an algebraic data type (no recursion):

    <State> = Unit
              | name <State> "|" name <State> T "|" ...
              | name <State> <State> <State> ... 

by convention, `name Unit` is abbreviated as `name`. eg, 
    
    data Room = Room1 | Room2 | Room3

and we write functions as, eg,

    button_press :: Room Event -> Room Effect 
    button_press (Room x) ev = 
        if x == Room1 room1_button_press 



One writes a (pure) function, `main`, of type

    main :: WorldState Event -> WorldState Effect
    
A value of type `Event` is one of a finite set of possible inputs; and a
value of type `Effect` is one of a finite set of posible outputs. The `WorldState`
is the type of possible states.

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














