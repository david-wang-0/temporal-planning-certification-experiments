(define (problem p_2_2_3_2)

	(:domain majsp)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 - Position
		t0 t1 - Treatment
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

              (pallet_at b0 p2)
              (pallet_at b1 p2)

              (is_depot p2)

              (position_free p2)
              (position_free p2)
              (position_free p2)

              (can_do p0 t0)
              (can_do p1 t1)
              (connected p0 p1)
              (connected p1 p0)
              (connected p1 p2)
              (connected p2 p1)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b0 t1)
              (treated b1 t0)
              (treated b1 t1)
              )
	)
)
