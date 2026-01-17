(define (problem p_1_3_3_4)

	(:domain majsp)

	(:objects
		r0 - Robot
		p0 p1 p2 - Position
		t0 t1 t2 t3 - Treatment
		b0 b1 b2 - Pallet 
		zero one two three four five six seven eight nine ten - Nat 
	)

        (:init
              (next_nat zero one)
              (next_nat one two)
              (next_nat two three)
              (next_nat three four)
              (next_nat four five)
              (next_nat five six)
              (next_nat six seven)
              (next_nat seven eight)
              (next_nat eight nine)
              (next_nat nine ten)

              (robot_at r0 p2)
              (robot_free r0)
              (battery_level r0 ten)

              (pallet_at b0 p2)
              (pallet_at b1 p2)
              (pallet_at b2 p2)

              (is_depot p2)

              (position_free p2)
              (position_free p2)
              (position_free p2)

              (can_do p2 t0)
              (connected p0 p1)
              (connected p1 p0)
              (connected p1 p2)
              (connected p2 p1)

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
