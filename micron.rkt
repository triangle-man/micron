#lang racket/base

(require redex)

(define-language kit
  (<expr> ::= (<expr> <expr>)      ; composition
              id)           
  (<con> ::= (<con> <expr>)
             (<expr> <con>)
             hole))

(define red
  (reduction-relation
   kit
   (--> (in-hole <con> ((<expr>_1 <expr>_2) <expr>_3))
        (in-hole <con> (<expr>_1 (<expr>_2 <expr>_3)))
        "asc")
   (--> (in-hole <con> (id <expr>))
        (in-hole <con> <expr>)
        "id")))


(define-extended-language kit-pr
  kit
  (<expr> ::= ....
              (pr <expr> <expr>) ; pairing
              fst
              snd)
  (<con> ::= ....
             (pr <con> <expr>)
             (pr <expr> <con>)))

(define red-pr
  (extend-reduction-relation
   red
   kit-pr
   (--> (in-hole <con> (pr fst snd))
        (in-hole <con> id)
        "pri")
   (--> (in-hole <con> (fst (pr <expr>_1 <expr>_2)))
        (in-hole <con> <expr>_1)
        "fst")
   (--> (in-hole <con> (snd (pr <expr>_1 <expr>_2)))
        (in-hole <con> <expr>_2)
        "snd")
   (--> (in-hole <con> ((pr <expr>_1 <expr>_2) <expr>_3))
        (in-hole <con> (pr (<expr>_1 <expr>_3) (<expr>_2 <expr>_3)))
        "abs")
   (--> (in-hole <con> (pr (fst <expr>) (snd <expr>)))
        (in-hole <con> <expr>)
        "prd")))


