(define (problem p_3_3_6_4)

	(:domain majsp)

	(:objects
		r0 r1 r2 - Robot
		p0 p1 p2 p3 p4 p5 - Position
		t0 t1 t2 t3 - Treatment
		b0 b1 b2 - Pallet 
		zero one two three four five - Nat 
	)

        (:init
              (next_nat zero one)
              (next_nat one two)
              (next_nat two three)
              (next_nat three four)
              (next_nat four five)

              (robot_at r0 p5)
              (robot_free r0)
              (battery_level r0 five)
              (robot_at r1 p5)
              (robot_free r1)
              (battery_level r1 five)
              (robot_at r2 p5)
              (robot_free r2)
              (battery_level r2 five)

              (pallet_at b0 p5)
              (pallet_at b1 p5)
              (pallet_at b2 p5)

              (is_depot p5)

              (position_free p5)
              (position_free p5)
              (position_free p5)
              (position_free p5)
              (position_free p5)
              (position_free p5)

              (can_do p0 t0)
              (can_do p1 t1)
              (can_do p2 t2)
              (can_do p3 t3)
              (connected p0 p1)
              (connected p1 p0)
              (connected p1 p2)
              (connected p2 p1)
              (connected p2 p3)
              (connected p3 p2)
              (connected p3 p4)
              (connected p4 p3)
              (connected p4 p5)
              (connected p5 p4)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b0 t1)
              (treated b0 t2)
              (treated b0 t3)
              (treated b1 t0)
              (treated b1 t1)
              (treated b1 t2)
              (treated b1 t3)
              (treated b2 t0)
              (treated b2 t1)
              (treated b2 t2)
              (treated b2 t3)
              )
	)
)
