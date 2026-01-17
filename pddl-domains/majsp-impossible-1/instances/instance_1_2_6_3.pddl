(define (problem p_1_2_6_3)

	(:domain new)

	(:objects
		r0 - Robot
		p0 p1 p2 p3 p4 p5 - Position
		t0 t1 t2 - Treatment
		b0 b1 - Pallet 
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

              (robot-at r0 p5)
              (robot-free r0)
              (battery-level r0 seven)

              (pallet-at b0 p5)
              (pallet-at b1 p5)

              (is-depot p5)

              (position-free p5)
              (position-free p5)
              (position-free p5)
              (position-free p5)
              (position-free p5)
              (position-free p5)

              (can-do p0 t0)
              (can-do p1 t1)
              (can-do p2 t2)
              (connected p0 p1)
              (connected p1 p2)
              (connected p2 p3)
              (connected p3 p4)
              (connected p4 p5)

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
