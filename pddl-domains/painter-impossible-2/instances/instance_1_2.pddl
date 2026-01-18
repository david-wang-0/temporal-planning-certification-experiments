(define (problem p_1_2)

	(:domain new)

	(:objects
		i0 i1 - Item
		t0 last_t - Treatment
	)

        (:init
              (start_item i0)
              (next_item i0 i1)

              (consecutive t0 last_t)
              (started i0 last_t)
              (ready i0 t0)
              (started i1 last_t)
              (ready i1 t0)
              (not_started i0 t0)
              (not_treated i0 t0)
              (not_started i1 t0)
              (not_treated i1 t0)
              (next_to_treat t0 i0)
              (not_is_end t0)
        )

	(:goal
              (and
                (joined)
              )
	)
)
