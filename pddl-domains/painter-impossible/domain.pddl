(define (domain new)
    (:requirements :typing :equality :negative-preconditions :durative-actions) 
    (:types Item Treatment)

    (:predicates
        (busy)
        (treated ?i - Item ?t - Treatment)
        (started ?i - Item ?t - Treatment)
        (ready ?i - Item ?t - Treatment)
        (consecutive ?t ?next - Treatment)
        (s1 ?i - Item ?t ?next - Treatment)
        (s2 ?i - Item ?t ?next - Treatment)
        (s3 ?i - Item ?t ?next - Treatment)
        (s4 ?i - Item ?t ?next - Treatment)
        (not_is_end ?t - Treatment)
        (joined)

        (next_to_treat ?t - Treatment ?i - Item)
        (next_item ?i ?j - Item)
        (start_item ?i - Item)
    )

    (:action join
        :parameters (?i1 - Item ?i2 - Item ?t - Treatment)
        :precondition (and
                        (not (= ?i1 ?i2))
                        (not_is_end ?t)
                        (not (treated ?i1 ?t))
                        (not (treated ?i2 ?t))
                        (started ?i1 ?t)
                        (started ?i2 ?t)
                        (ready ?i1 ?t)
                        (ready ?i2 ?t)
                      )
        :effect (joined)
    )

    (:action reset
        :parameters (?j - Item)
        :precondition (start_item ?j)
        :effect (and
                  (forall (?t - Treatment) (and
                    (forall (?i - Item) (and
                      (not (started ?i ?t))
                      (not (treated ?i ?t))
                    ))
                    (next_to_treat ?t ?j)
                  ))
                )
    )


    (:durative-action make_treatment1
        :parameters (?i ?j - Item ?t ?next - Treatment)
        :duration (= ?duration 4)
        :condition
            (and
                (at start (and
                              (s1 ?i ?t ?next)
                              (next_to_treat ?t ?i)
                              (not (busy))
                              (consecutive ?t ?next)
                              (not (treated ?i ?t))
                              (not (started ?i ?t))
                              (ready ?i ?t)
                              (next_item ?i ?j)
                              ))
            )
        :effect
            (and
                (at start (and
                              (not (s1 ?i ?t ?next))
                              (not (next_to_treat ?t ?i))
                              (next_to_treat ?t ?j)
                              (busy)
                              (started ?i ?t)))
                (at end (and
                            (s2 ?i ?t ?next)
                            (treated ?i ?t)
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
