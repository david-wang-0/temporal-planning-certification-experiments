(define (problem p_2_2_3_1)

	(:domain new)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 - Position
		t0 - Treatment
		b0 b1 - Pallet 
		zero one - Nat 
	)

        (:init
              (next-nat zero one)

              (robot-at r0 p2)
              (robot-free r0)
              (battery-level r0 one)
              (robot-at r1 p2)
              (robot-free r1)
              (battery-level r1 one)

              (pallet-at b0 p2)
              (pallet-at b1 p2)

              (is-depot p2)

              (position-free p2)
              (position-free p2)
              (position-free p2)

              (can-do p0 t0)
              (connected p0 p1)
              (connected p1 p2)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b1 t0)
              )
	)
)
