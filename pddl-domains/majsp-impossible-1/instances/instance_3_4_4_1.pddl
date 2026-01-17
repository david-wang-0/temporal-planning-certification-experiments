(define (problem p_3_4_4_1)

	(:domain majsp)

	(:objects
		r0 r1 r2 - Robot
		p0 p1 p2 p3 - Position
		t0 - Treatment
		b0 b1 b2 b3 - Pallet 
		zero one two three - Nat 
	)

        (:init
              (next_nat zero one)
              (next_nat one two)
              (next_nat two three)

              (robot_at r0 p3)
              (robot_free r0)
              (battery_level r0 three)
              (robot_at r1 p3)
              (robot_free r1)
              (battery_level r1 three)
              (robot_at r2 p3)
              (robot_free r2)
              (battery_level r2 three)

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
              (treated b1 t0)
              (treated b2 t0)
              (treated b3 t0)
              )
	)
)
