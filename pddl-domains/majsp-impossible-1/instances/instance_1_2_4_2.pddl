(define (problem p_1_2_4_2)

	(:domain new)

	(:objects
		r0 - Robot
		p0 p1 p2 p3 - Position
		t0 t1 - Treatment
		b0 b1 - Pallet 
		zero one two three four - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)
              (next-nat three four)

              (robot-at r0 p3)
              (robot-free r0)
              (battery-level r0 four)

              (pallet-at b0 p3)
              (pallet-at b1 p3)

              (is-depot p3)

              (position-free p3)
              (position-free p3)
              (position-free p3)
              (position-free p3)

              (can-do p0 t0)
              (can-do p1 t1)
              (connected p0 p1)
              (connected p1 p2)
              (connected p2 p3)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b0 t1)
              (treated b1 t0)
              (treated b1 t1)
              )
	)
)
