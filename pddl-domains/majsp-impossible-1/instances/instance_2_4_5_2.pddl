(define (problem p_2_4_5_2)

	(:domain new)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 p3 p4 - Position
		t0 t1 - Treatment
		b0 b1 b2 b3 - Pallet 
		zero one two three four five six seven - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)
              (next-nat three four)
              (next-nat four five)
              (next-nat five six)
              (next-nat six seven)

              (robot-at r0 p4)
              (robot-free r0)
              (battery-level r0 seven)
              (robot-at r1 p4)
              (robot-free r1)
              (battery-level r1 seven)

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
              (treated b2 t0)
              (treated b2 t1)
              (treated b3 t0)
              (treated b3 t1)
              )
	)
)
