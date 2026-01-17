(define (problem p_3_3_4_3)

	(:domain new)

	(:objects
		r0 r1 r2 - Robot
		p0 p1 p2 p3 - Position
		t0 t1 t2 - Treatment
		b0 b1 b2 - Pallet 
		zero one two three - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)

              (robot-at r0 p3)
              (robot-free r0)
              (battery-level r0 three)
              (robot-at r1 p3)
              (robot-free r1)
              (battery-level r1 three)
              (robot-at r2 p3)
              (robot-free r2)
              (battery-level r2 three)

              (pallet-at b0 p3)
              (pallet-at b1 p3)
              (pallet-at b2 p3)

              (is-depot p3)

              (position-free p3)
              (position-free p3)
              (position-free p3)
              (position-free p3)

              (can-do p0 t0)
              (can-do p1 t1)
              (can-do p2 t2)
              (connected p0 p1)
              (connected p1 p2)
              (connected p2 p3)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b0 t1)
              (treated b0 t2)
              (treated b1 t0)
              (treated b1 t1)
              (treated b1 t2)
              (treated b2 t0)
              (treated b2 t1)
              (treated b2 t2)
              )
	)
)
