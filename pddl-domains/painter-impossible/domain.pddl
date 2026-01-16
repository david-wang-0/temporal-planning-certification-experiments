(define (domain new)

    (:requirements :equality :typing :durative-actions :fluents :strips :conditional-effects)

    (:types Item Treatment Nat)

    (:predicates
        (busy)
        (not_busy)
        (treated ?i - Item ?t - Treatment)
        (not_treated ?i - Item ?t - Treatment)
        (started ?i - Item ?t - Treatment)
        (not_started ?i - Item ?t - Treatment)
        (ready ?i - Item ?t - Treatment)
        (consecutive ?t ?next - Treatment)
        (s1 ?i - Item ?t ?next - Treatment)
        (s2 ?i - Item ?t ?next - Treatment)
        (s3 ?i - Item ?t ?next - Treatment)
        (s4 ?i - Item ?t ?next - Treatment)
        (not_is_end ?t - Treatment)
        (joined)
        (true)

        (next_count ?n ?m - Nat)
        (item_id ?i - Item ?n - Nat)
        (counter ?t - Treatment ?n - Nat)
    )


    (:constants
        last_t - Treatment
        zero - Nat
    )

    (:action join
        :parameters (?i1 ?i2 - Item ?t - Treatment)
        :precondition (and
                        (not (= ?i1 ?i2))
                        (not_is_end ?t)
                        (not_treated ?i1 ?t)
                        (not_treated ?i2 ?t)
                        (started ?i1 ?t)
                        (started ?i2 ?t)
                        (ready ?i1 ?t)
                        (ready ?i2 ?t)
                      )
        :effect (joined)
    )

    (:action reset
        :parameters ()
        :precondition (and (true))
        :effect (and
                  (forall (?t - Treatment) (and
                    (forall (?i - Item) (and
                      (not (started ?i ?t))
                      (not (treated ?i ?t))
                    ))
                    (counter ?t zero)
                  ))
                )
    )


    (:durative-action make_treatment1
        :parameters (?i - Item ?t ?next - Treatment ?n ?m - Nat )
        :duration (= ?duration 4)
        :condition
            (and
                (at start (and
                              (s1 ?i ?t ?next)
                              (item_id ?i ?n) 
                              (counter ?t ?n)
                              (not_busy)
                              (consecutive ?t ?next)
                              (not_treated ?i ?t)
                              (not_started ?i ?t)
                              (ready ?i ?t)
                              (next_count ?n ?m)
                              ))
            )
        :effect
            (and
                (at start (and
                              (not (s1 ?i ?t ?next))

                              (counter ?t ?m)
                              (busy)
                              (not (not_busy))
                              (not (not_started ?i ?t))
                              (started ?i ?t)))
                (at end (and
                            (s2 ?i ?t ?next)
                            (treated ?i ?t)
                            (not (not_treated ?i ?t))
                            (not_busy)
                            (not (busy))))
            )
    )

    (:durative-action make_treatment2
        :parameters (?i - Item ?t ?next - Treatment)
        :duration (= ?duration 6)
        :condition (and
                    (at start (s2 ?i ?t ?next))
                   )
        :effect
            (and
                (at start (not (s2 ?i ?t ?next)))
                (at end (and
                            (s3 ?i ?t ?next)
                            (ready ?i ?next)))
            )
    )

    (:durative-action make_treatment3
        :parameters (?i - Item ?t ?next - Treatment)
        :duration (= ?duration 5)
        :condition
            (and
                (at start (s3 ?i ?t ?next))
                (at end (started ?i ?next))
            )
        :effect
            (and
                (at start (not (s3 ?i ?t ?next)))
                (at end (s4 ?i ?t ?next))
            )
    )

    (:durative-action make_treatment_container
        :parameters (?i - Item ?t ?next - Treatment)
        :duration (= ?duration 16)
        :condition (and
                    (at end (s4 ?i ?t ?next))
                   )
        :effect (and
                    (at start (s1 ?i ?t ?next))
                    (at end (not (s4 ?i ?t ?next)))
                 )
    )

)
