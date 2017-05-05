#lang racket

;; Untyped Processes
;; =================

;; integer integer integer [State => [symbol => [symbol State]]] -> Machine
;; A Machine is a finite state transducer. States are indexed by integers. 
(struct Machine
  (states         ; One less than the number of states
   initial-state  ; The starting state
   done-state     ; The terminal state (if there is one) or #f
   transitions)   ; Key is states, and the value is an association list of
                  ; (in . (out . next))
  )

;; Machine -> boolean
;; Test whether a Machine contains a done state
(define (has-done-state? m)
  (if (Machine-done-state m) #t #f))

;; Machine
;; The machine that successfully halts without consuming input
(define done
  (Machine 0                        ; One state
           0                        ; The initial state is the only state
           0                        ; The 'done' machine terminates immediately
           '( (0 . ()) )            ; No transitions from the sole state
           ))

;; Machine
;; The machine that accepts no symbols and is stuck
(define stuck
  (Machine 0 0 #f '( (0 . ()) )))

;; symbol symbol -> Machine
;; The machine that consumes only `in`, produces `out`, and halts
(define (-> in out)
  (Machine 1   ; Two states
           0   ; Initial state
           1   ; Final state
           `( (0 . ( (,in . (,out . 1))))
              (1 . ()))
           ))

;; Machine Machine -> Machine
;;
;; Do one machine, then the other, joining on the done state of the first. It is
;; an error if the first machine does not have a done state.
(define (do2 m1 m2)
  (when (not (has-done-state? m1))
      (raise-argument-error 'do2 "Machine containing a done state" 0 m1))
  12) 

;; Machine ... -> Machine
;; Do one machine, then the other, then the other, ...


;; (either0 m1 m2 ... ) : m's must have non-ovelapping accepting symbols in initital state
;; (loop m) : Machine

;; (accepted-symbols machine? <state>) : list-of symbol?

;; (step/machine machine? <state> symbol?) : 
;; (run/machine machine? (list-of symbol?)) : 









  
