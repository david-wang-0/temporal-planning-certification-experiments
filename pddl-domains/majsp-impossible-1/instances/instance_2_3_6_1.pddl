(define (problem p_2_3_6_1)

	(:domain new)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 p3 p4 p5 - Position
		t0 - Treatment
		b0 b1 b2 - Pallet 
		zero one two three four five - Nat 
	)

        (:init
              (next-nat zero one)
              (next-nat one two)
              (next-nat two three)
              (next-nat three four)
              (next-nat four five)

              (robot-at r0 p5)
              (robot-free r0)
              (battery-level r0 five)
              (robot-at r1 p5)
              (robot-free r1)
              (battery-level r1 five)

              (pallet-at b0 p5)
              (pallet-at b1 p5)
              (pallet-at b2 p5)

              (is-depot p5)

              (position-free p5)
              (position-free p5)
              (position-free p5)
              (position-free p5)
              (position-free p5)
              (position-free p5)

              (can-do p0 t0)
              (connected p0 p1)
              (connected p1 p2)
              (connected p2 p3)
              (connected p3 p4)
              (connected p4 p5)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b1 t0)
              (treated b2 t0)
              )
	)
)
