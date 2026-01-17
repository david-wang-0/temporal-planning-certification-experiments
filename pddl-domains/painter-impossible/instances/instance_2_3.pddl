(define (problem p_2_3)

	(:domain new)

	(:objects
		i0 i1 i2 - Item
		t0 t1 last_t - Treatment
	)

        (:init
              (start_item i0)
              (next_item i0 i1)

              (next_item i1 i2)

              (consecutive t0 t1)
              (consecutive t1 last_t)
              (started i0 last_t)
              (ready i0 t0)
              (started i1 last_t)
              (ready i1 t0)
              (started i2 last_t)
              (ready i2 t0)
              (next_to_treat t0 i0)
              (not_is_end t0)
              (next_to_treat t1 i0)
              (not_is_end t1)
        )

	(:goal
              (and
                (joined)
              )
	)
)
