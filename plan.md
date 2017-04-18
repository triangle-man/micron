# A scheme for the BBC micro:bit

I'd like to create a Scheme programming environment for the micro:bit. I'd
*really* like it to be R7RS. 

My rough plan is: 

- write a compiler (in Racket) from Scheme to "bytecode". (The compiler will run
  on a big machine.)
  
- write a bytecode interpreter  in C (or C++ I suppose) to run on the micro:bit.

Ideally, one would want a full, interactive Scheme running on the micro:bit,
offering a REPL (over the serial port, perhaps). It might be too hard to store
the parser and compiler though. 

Specifically, I plan to compile by macro-expansion down to some minimal form,
followed by CPS transformation, followed by whatever optimisations I can figure
out how to do. The interpreter will be a CESK machine.

When optimising, I plan to prioritise space over speed. The micro:bit has only
16k of RAM and 256k of flash ROM.

In order to make this more interesting, it would be fun to think of whether we
could "maximimally optimise (for space) at least small pieces of code". What I
mean is that, as I understand it, most optimisations are *ad hoc*. We can't do
some kind of principled optimisation because that takes exponential time. (Eg,
there's apparently something called k-CFA for various values of k.) But
... maybe that's okay, for small bits of code?

### Phase I

1. Write, in Racket, a parser for a very tiny lambda-calculus:

 2. Write, in Racket, a program to convert this to CPS-style
 
 3. Write (in Racket? or C?) a CESK machine for this language.


Language: 

   Application: (f x y ...)
   Single-barelled let: (let (x exp) (exp ...))
   letrec (?)
   set!
   If: (if test exp-if-true exp-if-false)
   
Primitive values:
   '(), (cons x y)
   #t, #f, 
   integers, 
   (lambda (x y ...) (exp ...))
           

Primitive procedures:
   +, -, *, / (int), mod, =, >, <, not
   cons, car, cdr,
   null?, number?, procedure?, pair?, boolean?





### Exisiting Schemes

Chibi scheme is R7RS compliant and targets embedded devices with a byte-compiler
approach. It would presumably be easier to port it than to write my own, but I
just don't understand enough of all the parts involved. Writing my own will
clearly produce a worse Scheme but I might learn more.
