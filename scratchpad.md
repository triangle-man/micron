# Scratchpad for random ideas

A *transitor* is a function that:

    - accepts a value taken from a finite set (possibly empty) of possible inputs;
    - emits one of a finite set of outputs;
    - returns a transitor.
    
Fix, once and for all, a finite set of inputs, I, and a finite set of outputs, O.

eg, `stop` is the transitor that accepts no inputs.

`forever` accepts any inputs, emits no output, and returns `forever`.

`const o` accepts any input, emits o, and returns `stop`.

`on i emit o` accepts i, emits o, and returns `stop`.

Combinators:


    





## Proofs ...

Things we might wish to ask the compiler:

* From every state, is there a possible route to "Win" or "Lose"?
* From every state, is there a possible route to "Win"?

Does every state necessarily consume every input (even if the output is empty and
the transition returns to the same state)?





## What does a FSA-based game look like?

Example:

There are three locations, L1, L2, L3.
And two buttons, B1 and B2

The system starts in location L1. 

When in L1, the display cycles "-", "\", "|", "/" every 0.2s; pushing B1 does nothing.

When in L2, the display is "1", "2", "3", "4", or "5". Pushing B1 cycles through
this list (starting from "1" the first time the system lands in L2). 

When in L3, the display shows "o" or "e" depending on whether the system has
transitioned into L1 an even or odd number of times. B1 does nothing.

In any state, pushing B2 displays "*" until B2 is released.

## Imaginary language version of this game

wait-rotator :: WS ev -> WS ef

data Count = One | Two | Three | Four
here type WS = Count

data ev = Tick

data Display = "-" | "\" | "|" | "/"
type ef = Display





## Combining regexps:

A | B
AB
A*


## Combining FSAs



M1, M2 take a sequence of symbol and emits a sequence of symbols.

M1 :: WorldState1 Event1 -> WorldState1 Effect1

So ... could do --

M1 x M2 :: (WorldState1 WorldState2) (Event1 | Event2) -> (WS1 WS2) (Effect1 | Effect2) 

(ie, decide which of M1 or M2 to use, based on the type of the Event; then
update the WS appropriately and return whichever event it is).

M1 :: WS1 Event -> (WS1 | WS2) Effect1

Could do M1 then M2: ie, do M1 until it emites a WS2, then switch to
M2. (Although this seems to be done automatically by pattern matching on the
subtype of WS).


What about "and"? ie, do M1 and M2 (producing both effects?) but only when they
accept the same input? (But all automata "process" all input strings). So this
is more like "do both at the same time". 






## Categorical notions

### Functor

1. Type constructor, F, as in F t

2. fmap :: Functor F => (a -> b) -> F a -> F b

3. Satisfying:

    fmap id = id
    
    fmap (g . f) = fmap g . fmap f


### Applicative

1. Type constructor, A, as in A t

2. pure :: a -> A a

3. ap (or infix <*>)
   ap :: Applicative A => A (a -> b) -> A a -> A b

4. Satisfying:

```haskell
    pure (ap id) v = v
    ap (pure f) (pure x)  = pure (f x)
    ap u (pure y) = ap (pure ($ y) u)    where ($ x) f = f x 
    ap (ap u v) w = ap u (ap v w)
```

and A is a functor under 

    fmap f x = ap (pure f) x


### Monad

1. Type constructor M
   eg, Maybe, as in Maybe Int
   or, List as in List Int
   
2. return :: t -> M t
   
3. bind (or infix >>=)
   bind :: M t -> (t -> M t) -> M t
   
4. Satisfying:

```haskell
bind (return x) f = f x
bind m return = m
bind (bind m f) g = bind m ( \\x -> (bind (f x) g) )
```
 
 Alternatively, define in terms of return, join, and fmap
 
 ```haskell
   join :: M (M t) -> M t
   join n = bind n id
   
   fmap f m = bind m (return . f) 
```
where

```haskell
f . g = \\x -> f (g x)
``` 
