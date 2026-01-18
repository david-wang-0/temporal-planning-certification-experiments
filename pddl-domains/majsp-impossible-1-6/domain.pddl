(define (domain majsp)
    (:requirements :strips :typing :equality :durative-actions)

    (:types
        Robot - object
        Pallet - object
        Position - object
        Treatment - object
        Nat - object
    )

    (:predicates
        (robot_at ?r - Robot ?p - Position)
        (pallet_at ?b - Pallet ?p - Position)
        (can_do ?b - Position ?t - Treatment)
        (robot_free ?r - Robot)
        (position_free ?p - Position)
        (robot_has ?r - Robot ?b - Pallet)
        (treated ?b - Pallet ?t - Treatment)
        (ready ?b - Pallet ?p - Position ?t - Treatment)
        (is_depot ?p - Position)

        ;;clipping unload with load
        (unload_started ?b - Pallet ?p - Position ?t - Treatment)
        (unload_ended ?b - Pallet ?p - Position ?t - Treatment)
        (unload_clip_started ?b - Pallet ?p - Position ?t - Treatment)
        (unload_max_timeout ?b - Pallet ?p - Position ?t - Treatment)
        (unload_max_timeout_can_start ?b - Pallet ?p - Position ?t - Treatment)
        (unload_max_timeout_started ?b - Pallet ?p - Position ?t - Treatment)
        (unload_min_timeout ?b - Pallet ?p - Position ?t - Treatment)
        (unload_min_timeout_can_start ?b - Pallet ?p - Position ?t - Treatment)
        (unload_min_timeout_started ?b - Pallet ?p - Position ?t - Treatment)
        
        ;; removing functions
        (connected ?l - Position ?m - Position)
        (battery_level ?r - Robot ?n - Nat)
        (next_nat ?b ?c - Nat)
        
    )
    
    (:action move
        :parameters (?r - Robot ?from ?to - Position ?l ?n - Nat)
        :precondition
            (and
                (not (= ?from ?to))
                (connected ?from ?to)
                (robot_at ?r ?from)
                (battery_level ?r ?n)
                (next_nat ?l ?n)
            )
        :effect
            (and
                (not (robot_at ?r ?from))
                (robot_at ?r ?to)
                (not (battery_level ?r ?n))
                (battery_level ?r ?l)
            )
    )

    (:action unload_at_depot
        :parameters (?r - Robot ?b - Pallet ?p - Position )
        :precondition
            (and
                (is_depot ?p)
                (robot_at ?r ?p)
                (robot_has ?r ?b)
            )
        :effect
            (and
                (pallet_at ?b ?p)
                (robot_free ?r)
                (not (robot_has ?r ?b))
            )
    )

    (:action load_from_depot
        :parameters (?r - Robot ?b - Pallet ?p - Position )
        :precondition
            (and
                (is_depot ?p)
                (robot_at ?r ?p)
                (robot_free ?r)
                (pallet_at ?b ?p)
            )
        :effect
            (and
                (not (robot_free ?r))
                (not (pallet_at ?b ?p))
                (robot_has ?r ?b)
            )
    )

    (:durative-action unload
        :parameters (?r - Robot ?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 10)
        :condition
            (and
                (at start (can_do ?p ?t))
                (at start (position_free ?p))
                (at start (robot_at ?r ?p))
                (at start (robot_has ?r ?b))
                (at end (unload_clip_started ?b ?p ?t))
            )
        :effect
            (and
                (at start (not (position_free ?p)))
                (at start (not (robot_has ?r ?b)))
                (at end (pallet_at ?b ?p))
                (at start (unload_started ?b ?p ?t))
                (at end (unload_ended ?b ?p ?t))
                (at end (robot_free ?r))
            )
    )

    (:durative-action unload_clip
        :parameters (?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 3)
        :condition (and
                        (at start (unload_started ?b ?p ?t))
                        (at end (unload_ended ?b ?p ?t))
                        (at end (unload_min_timeout_started ?b ?p ?t))
                        (at end (unload_max_timeout_started ?b ?p ?t))
                   )
        :effect (and
                    (at start (unload_clip_started ?b ?p ?t))
                    (at start (unload_min_timeout_can_start ?b ?p ?t))
                    (at start (unload_max_timeout_can_start ?b ?p ?t))
                    (at end (not (unload_min_timeout_started ?b ?p ?t)))
                    (at end (not (unload_max_timeout_started ?b ?p ?t)))

                )
    )

    (:durative-action unload_min_timeout
        :parameters (?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 1000)
        :condition (and
                        (at start (unload_min_timeout_can_start ?b ?p ?t))
                   )
        :effect (and
                    (at start (unload_min_timeout_started ?b ?p ?t))
                    (at start (not (unload_min_timeout_can_start ?b ?p ?t)))
                    (at end (ready ?b ?p ?t))
                )
    )

    (:durative-action unload_max_timeout
        :parameters (?b - Pallet ?p - Position ?t - Treatment)
        :duration (= ?duration 2000)
        :condition (and
                        (at start (unload_max_timeout_can_start ?b ?p ?t))
                   )
        :effect (and
                    (at start (unload_max_timeout_started ?b ?p ?t))
                    (at start (not (unload_max_timeout_can_start ?b ?p ?t)))
                    (at end (not (ready ?b ?p ?t)))
                )
    )


    (:action load
        :parameters (?r - Robot ?b - Pallet ?p - Position ?t - Treatment)
        :precondition
            (and
                (pallet_at ?b ?p)
                (robot_free ?r)
                (robot_at ?r ?p)
                (ready ?b ?p ?t)
            )
        :effect
            (and
                (not (ready ?b ?p ?t))
                (not (pallet_at ?b ?p))
                (not (robot_free ?r))
                (robot_has ?r ?b)
                (treated ?b ?t)
                (position_free ?p)
            )
    )



)
