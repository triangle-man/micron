#lang racket

;; Untyped Processes
;; =================

;; Internals
;; ---------

;; A /machine/ is a set of states together with a set of transitions between
;; states. The states are identified by integers. The process starts in state
;; 0 and terminates in the state held in `done-state`.
;;
;; (machine integer? assoc-list? integer? integer?) 

(struct machine
  (states        ; One less than the number of states
   transitions   ; Key is states, and
                 ; the value is an association list of
                 ; (in . (out next))
   initial-state ; The starting state
   done-state)   ; The terminal state (if there is one) or #f
  )


;; CONFUSED
;;
;; I don't really understand what testing for the done machine looks like. That
;; is, I don't know whether any machine with these fields is the done machine,
;; or whether only this one is. I guess the answer depends on what happens if
;; you "run" this machine; and I'm not sure what running the done machine is
;; supposed to do. For example, it could, for any input symbol, return a special
;; symbol (say #t), indicating completion, without consuming any input.

(define done-machine
  (machine 0                        ; One state
           '(0 . ())                ; No transitions from the sole state
           0                        ; initial state
           0                        ; The 'done' machine terminates successfully
           ))

;; constant-machine pair? -> machine?

(define (constant-machine in/out)
  )

;; Helper functions
;; ----------------

;; Get list of symbols accepted by machine in given state

;; Check whether machine accepts given symbol


;; Building machines
;; -----------------

;; Using let

;; Using combinators


;; Running machines
;; ----------------

;; (step/machine machine in-state in-symbol) -> (out-state out-symbols)
;; (run/process machine in-symbols) -> (out-symbols unconsumed-symbols)


;; Constructions
;; -------------



;; A process is either
;; - done; or
;; - (when reaction ...)


;; FIXME: Probably `->` and `done` should be syntax within a when-form

;; A "reaction", ->, represents the action of reading a symbol, outputting a
;; list of symbols and returning a process
;;
;; -> :: symbol symbol-or-list machine -> reaction

(define (-> in-symbol out-symbols next)
  ;; make sure `out` is a list
  (let ([out-list
         (if (list? out-symbols) out-symbols (list out-symbols))])
    (cons in-symbol (cons out-list next))))

;; A when-process is a set of possible reactions
;; If the list is empty, the process is "stuck".
;;
;; when : (list-of reaction) -> process
;; (define (when . reactions)
;;   (if (all-unique? (map car reactions))
;;       reactions
;;       (raise-argument-error 'when "unique in symbols" reactions)))

;; check that all elements of a list are unique, using eq? for comparison
;; list -> boolean

  
  
  
