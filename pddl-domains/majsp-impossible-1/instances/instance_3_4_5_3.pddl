(define (problem p_3_4_5_3)

	(:domain new)

	(:objects
		r0 r1 r2 - Robot
		p0 p1 p2 p3 p4 - Position
		t0 t1 t2 - Treatment
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

              (robot-at r0 p4)
              (robot-free r0)
              (battery-level r0 six)
              (robot-at r1 p4)
              (robot-free r1)
              (battery-level r1 six)
              (robot-at r2 p4)
              (robot-free r2)
              (battery-level r2 six)

              (pallet-at b0 p4)
              (pallet-at b1 p4)
              (pallet-at b2 p4)
              (pallet-at b3 p4)

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
              (treated b2 t0)
              (treated b2 t1)
              (treated b2 t2)
              (treated b3 t0)
              (treated b3 t1)
              (treated b3 t2)
              )
	)
)
