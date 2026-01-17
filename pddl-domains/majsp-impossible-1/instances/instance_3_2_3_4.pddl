(define (problem p_3_2_3_4)

	(:domain majsp)

	(:objects
		r0 r1 r2 - Robot
		p0 p1 p2 - Position
		t0 t1 t2 t3 - Treatment
		b0 b1 - Pallet 
		zero one - Nat 
	)

        (:init
              (next_nat zero one)

              (robot_at r0 p2)
              (robot_free r0)
              (battery_level r0 one)
              (robot_at r1 p2)
              (robot_free r1)
              (battery_level r1 one)
              (robot_at r2 p2)
              (robot_free r2)
              (battery_level r2 one)

              (pallet_at b0 p2)
              (pallet_at b1 p2)

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
              )
	)
)
