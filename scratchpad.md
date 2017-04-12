# Scratchpad for random ideas

What does a FSA-based game look like?

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



One can imagine two mindsets. Consider the program for L3. 




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
