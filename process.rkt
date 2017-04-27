#lang racket


;; A process representing successful completion
(define done 'DONE)

(define (done? p) (eq? p done))


;; 

