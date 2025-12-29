(define (domain sync)
(:requirements :strips :typing :fluents :conditional-effects)
(:types
   robot - object
   parallel - object)
(:predicates
   (pA ?r - robot)
   (pB ?r - robot ?p - parallel)
   (pX ?r - robot ?p - parallel)
   (pG ?r - robot)
   (exD ?r - robot)
   (exC ?r - robot)
   (compiled_d_started ?r - robot ?p - parallel)
   (compiled_c1_started ?r - robot)
   (compiled_c2_started ?r - robot))
(:functions
   (dur_c1 ?r - Robot)
   (dur_c2 ?r - Robot)
   (dur_d ?r - Robot ?p - Parallel)
)
(:action compiled_d_start
   :parameters (?r - robot ?p - parallel)
   :precondition (and (not (compiled_d_started ?r ?p)) (pA ?r))
   :effect (and (compiled_d_started ?r ?p) (not (exD ?r)) (pB ?r ?p)))
(:action compiled_d_end
   :parameters (?r - robot ?p - parallel)
   :precondition (and (compiled_d_started ?r ?p))
   :effect (and (not (compiled_d_started ?r ?p)) (exD ?r) (pX ?r ?p)))

(:action compiled_c1_start
   :parameters (?r - robot)
   :precondition (and (not (compiled_c1_started ?r)) (exD ?r) (exC ?r))
   :effect (and (compiled_c1_started ?r) (not (exC ?r)) (forall (?p - Parallel) (not (pB ?r ?p))) (pA ?r)))
(:action compiled_c1_end
   :parameters (?r - robot)
   :precondition (and (compiled_c1_started ?r) (forall (?p - Parallel) (pB ?r ?p)))
   :effect (and (not (compiled_c1_started ?r)) (exC ?r) (not (pA ?r))))

(:action compiled_c2_start
   :parameters (?r - robot)
   :precondition (and (not (compiled_c2_started ?r)) (exC ?r))
   :effect (and (compiled_c2_started ?r) (not (exC ?r)) (forall (?p - Parallel) (not (pX ?r ?p)))))
(:action compiled_c2_end
   :parameters (?r - robot)
   :precondition (and (compiled_c2_started ?r) (forall (?p - Parallel) (pX ?r ?p)))
   :effect (and (not (compiled_c2_started ?r)) (exC ?r) (pG ?r)))
)
