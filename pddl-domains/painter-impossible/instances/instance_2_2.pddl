(define (problem p_2_2)

	(:domain new)

	(:objects
		i0 i1 - Item
		t0 t1 - Treatment
     zero one two - Nat
	)

        (:init
              (next_count zero one)
              (next_count one two)
              (not_busy)
              (true)
              (not_treated i0 t0)
              (not_treated i0 t1)
              (not_treated i1 t0)
              (not_treated i1 t1)
              (not_started i0 t0)
              (not_started i0 t1)
              (not_started i1 t0)
              (not_started i1 t1)
              (item_id i0 zero)
              (item_id i1 one)
              (consecutive t0 t1)
              (consecutive t1 last_t)
              (started i0 last_t)
              (ready i0 t0)
              (started i1 last_t)
              (ready i1 t0)
              (counter t0 zero)
              (not_is_end t0)
              (counter t1 zero)
              (not_is_end t1)
              (counter last_t zero)
        )

	(:goal
              (and
                (joined)
              )
	)
)
