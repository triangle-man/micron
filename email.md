Hi Tomas,

I'm more and more liking your idea of writing a little language that generates a
finite state machine for the micro:bit, and I'm really liking this idea of doing
it in a functional-reactive-programming style.

(By the way, after reading around a bit, I believe that the "equivalent of the
lambda calculus for finite state machines" is something called a "process
algebra"; and I've also decided to stop reading around a bit.)

Also -- I can't help thinking that this is all about co-effects ... 

Anyway, here's where I've got to so far.

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














