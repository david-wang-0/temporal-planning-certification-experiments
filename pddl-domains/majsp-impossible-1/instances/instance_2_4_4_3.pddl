(define (problem p_2_4_4_3)

	(:domain majsp)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 p3 - Position
		t0 t1 t2 - Treatment
		b0 b1 b2 b3 - Pallet 
		zero one two three four five six seven - Nat 
	)

        (:init
              (next_nat zero one)
              (next_nat one two)
              (next_nat two three)
              (next_nat three four)
              (next_nat four five)
              (next_nat five six)
              (next_nat six seven)

              (robot_at r0 p3)
              (robot_free r0)
              (battery_level r0 seven)
              (robot_at r1 p3)
              (robot_free r1)
              (battery_level r1 seven)

              (pallet_at b0 p3)
              (pallet_at b1 p3)
              (pallet_at b2 p3)
              (pallet_at b3 p3)

              (is_depot p3)

              (position_free p3)
              (position_free p3)
              (position_free p3)
              (position_free p3)

              (can_do p0 t0)
              (can_do p1 t1)
              (can_do p2 t2)
              (connected p0 p1)
              (connected p1 p0)
              (connected p1 p2)
              (connected p2 p1)
              (connected p2 p3)
              (connected p3 p2)

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
