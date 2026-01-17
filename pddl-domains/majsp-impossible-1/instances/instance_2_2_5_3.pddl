(define (problem p_2_2_5_3)

	(:domain new)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 p3 p4 - Position
		t0 t1 t2 - Treatment
		b0 b1 - Pallet 
		zero one two three - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)

              (robot-at r0 p4)
              (robot-free r0)
              (battery-level r0 three)
              (robot-at r1 p4)
              (robot-free r1)
              (battery-level r1 three)

              (pallet-at b0 p4)
              (pallet-at b1 p4)

              (is-depot p4)

              (position-free p4)
              (position-free p4)
              (position-free p4)
              (position-free p4)
              (position-free p4)

              (can-do p0 t0)
              (can-do p1 t1)
              (can-do p2 t2)
              (connected p0 p1)
              (connected p1 p2)
              (connected p2 p3)
              (connected p3 p4)

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
