(define (problem p_1_2_5_2)

	(:domain new)

	(:objects
		r0 - Robot
		p0 p1 p2 p3 p4 - Position
		t0 t1 - Treatment
		b0 b1 - Pallet 
		zero one two three four five - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)
              (next-nat three four)
              (next-nat four five)

              (robot-at r0 p4)
              (robot-free r0)
              (battery-level r0 five)

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
              (connected p0 p1)
              (connected p1 p2)
              (connected p2 p3)
              (connected p3 p4)

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
