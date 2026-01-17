(define (problem p_2_4_3_1)

	(:domain new)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 - Position
		t0 - Treatment
		b0 b1 b2 b3 - Pallet 
		zero one two three - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)

              (robot-at r0 p2)
              (robot-free r0)
              (battery-level r0 three)
              (robot-at r1 p2)
              (robot-free r1)
              (battery-level r1 three)

              (pallet-at b0 p2)
              (pallet-at b1 p2)
              (pallet-at b2 p2)
              (pallet-at b3 p2)

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
              (treated b2 t0)
              (treated b3 t0)
              )
	)
)
