(define (problem p_2_2_5_1)

	(:domain new)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 p3 p4 - Position
		t0 - Treatment
		b0 b1 - Pallet 
		zero one two - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)

              (robot-at r0 p4)
              (robot-free r0)
              (battery-level r0 two)
              (robot-at r1 p4)
              (robot-free r1)
              (battery-level r1 two)

              (pallet-at b0 p4)
              (pallet-at b1 p4)

              (is-depot p4)

              (position-free p4)
              (position-free p4)
              (position-free p4)
              (position-free p4)
              (position-free p4)

              (can-do p0 t0)
              (connected p0 p1)
              (connected p1 p2)
              (connected p2 p3)
              (connected p3 p4)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b1 t0)
              )
	)
)
