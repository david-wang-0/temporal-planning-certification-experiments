(define (problem p_2_2_3_3)

	(:domain new)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 - Position
		t0 t1 t2 - Treatment
		b0 b1 - Pallet 
		zero one two - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)

              (robot-at r0 p2)
              (robot-free r0)
              (battery-level r0 two)
              (robot-at r1 p2)
              (robot-free r1)
              (battery-level r1 two)

              (pallet-at b0 p2)
              (pallet-at b1 p2)

              (is-depot p2)

              (position-free p2)
              (position-free p2)
              (position-free p2)

              (can-do p0 t0)
              (can-do p1 t1)
              (can-do p2 t2)
              (connected p0 p1)
              (connected p1 p2)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b0 t1)
              (treated b0 t2)
              (treated b1 t0)
              (treated b1 t1)
              (treated b1 t2)
              )
	)
)
