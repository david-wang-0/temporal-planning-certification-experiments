(define (problem p_1_4_3_1)

	(:domain new)

	(:objects
		r0 - Robot
		p0 p1 p2 - Position
		t0 - Treatment
		b0 b1 b2 b3 - Pallet 
		zero one two three four five six - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)
              (next-nat three four)
              (next-nat four five)
              (next-nat five six)

              (robot-at r0 p2)
              (robot-free r0)
              (battery-level r0 six)

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
