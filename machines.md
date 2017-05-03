# Overview

Abstract machine

~ An interpreter

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
1 + State = DONE | Run State 
```

Abstract machines can be used to map sequences to sequences. Let $u$ be some
sequence $(a, b, c, \dotsc)$ with values in `In`. The output sequence, $y_1,
y_2, \dotsc$ (with values in `Out`) is:

    (S_1, y1) = m(S_0, a);
    (S_2, y2) = m(S_1, b);
    (S_3, y3) = m(S_2, c); 
    ...

and terminates when `S_n == DONE`.

The idea is to write programs that compile to abstract machines, then compile
the abstract machine to a finite state automaton.


## Practical

A *practical machine* is a finite directed graph $(S, e)$ with nodes $S$ and
labelled edges $e$, and distinguished nodes $S_0$ and $S_\text{stop}$, such
that:

  1. Every edge is labelled with a pair $(x, y_i)$, where $x$ is a symbol from
     some alphabet and and $y_i$ is a (possibly empty) finite sequence of
     symbols from some (possibly different) alphabet;
       
  3. From every node except $S_\text{stop}$, and for each $x$ in the alphabet of
     input symbols, there is exactly one edge labelled $(x, ...)$.

Abstract machines also map sequences to sequences. To do so, one starts at
$S_0$. Then, for each symbol in the input sequences, one follows the arrow
labelled with that symbol (of which there is precisely one) and emits the
corresponding $y_i$. Continue until the node $S_\text{DONE}$ is reached, then
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
following $u$". Write $|u|$ for the length of $u$. Finally, $\varepsilon$ is the
empty sequence.

Then the conditions that a theoretical machine, $\mu$, must satisfy are:

1. (Strictness) $\mu(\varepsilon) = \varepsilon$;

2. (Determinism) $u\leq v$ implies $\mu(u) \leq \mu(v)$;
   
3. (Finiteness) There exists an integer $N$ (dependent on $\mu$) such that for
   any sequence $s$ longer than $N$, there is a prefix $u$, with $s = uv$, such
   that:
       
       i. $1 \leq |v| \leq N$;
       ii. For any $w$, $\mu(s)^{-1} \mu(sw) = \mu(u)^{-1}\mu(uw)$.
       
The third condition says that the result of applying $\mu$ to any sequence after
a certain point is the same as it would be if you applied $\mu$ to a shorter
subsequence first. Or: you only need to know the result of $\mu$ on sequences no
longer than $N$.

FIXME: Here the definition says that the domain of $\mu$ is all finite
sequences. 



# Programming the abstract machine

## Processes

A *reaction* is a form
```scheme
(-> 'a '(A B C))
```
It is interpreted as: on reading `'a`, emit the sequence `'(A B C)`.

A *process* takes as input a sequence of symbols and produces, as ouput, a pair
consisting of a sequence of symbols and a "continuation" process. A process is
of the form
```scheme 
(do reaction process)
``` 
or 

```scheme 
done
```

or
```scheme
(either process ...)
```

where the first reaction in each process must have a different input symbol. It
is interpreted as "on reading $x$, find the reaction with input symbol $x$ and
apply the corresponding process to $x$.

Processes may be named:
```scheme
(define/process name process)
```
after which they may be referred to (possibly recursively).

Processes can be applied to sequences:
```scheme
(run/process input-sequence process)
```
The output is a pair consisting of an output sequence and another process (which
may be the process `done`).


## Combinators

```scheme
(=> process ...)
```

The process that is: the first process until `done` is returned, then the second
process, and so on.

```scheme
(repeat process)
```

## Todo

Parallelisation? 

How to "pipe" the output of one process into the input of another ???

Abstraction?

How to reify state

























