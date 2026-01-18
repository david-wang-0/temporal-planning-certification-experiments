(define (problem p_4_2)

	(:domain new)

	(:objects
		i0 i1 - Item
		t0 t1 t2 t3 last_t - Treatment
	)

        (:init
              (start_item i0)
              (next_item i0 i1)

              (consecutive t0 t1)
              (consecutive t1 t2)
              (consecutive t2 t3)
              (consecutive t3 last_t)
              (started i0 last_t)
              (ready i0 t0)
              (started i1 last_t)
              (ready i1 t0)
              (not_started i0 t0)
              (not_treated i0 t0)
              (not_started i0 t1)
              (not_treated i0 t1)
              (not_started i0 t2)
              (not_treated i0 t2)
              (not_started i0 t3)
              (not_treated i0 t3)
              (not_started i1 t0)
              (not_treated i1 t0)
              (not_started i1 t1)
              (not_treated i1 t1)
              (not_started i1 t2)
              (not_treated i1 t2)
              (not_started i1 t3)
              (not_treated i1 t3)
              (next_to_treat t0 i0)
              (not_is_end t0)
              (next_to_treat t1 i0)
              (not_is_end t1)
              (next_to_treat t2 i0)
              (not_is_end t2)
              (next_to_treat t3 i0)
              (not_is_end t3)
        )

	(:goal
              (and
                (joined)
              )
	)
)
