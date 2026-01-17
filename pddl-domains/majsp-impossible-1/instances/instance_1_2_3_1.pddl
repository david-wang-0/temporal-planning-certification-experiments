(define (problem p_1_2_3_1)

	(:domain majsp)

	(:objects
		r0 - Robot
		p0 p1 p2 - Position
		t0 - Treatment
		b0 b1 - Pallet 
		zero one two - Nat 
	)

        (:init
              (next_nat zero one)
              (next_nat one two)

              (robot_at r0 p2)
              (robot_free r0)
              (battery_level r0 two)

              (pallet_at b0 p2)
              (pallet_at b1 p2)

              (is_depot p2)

              (position_free p2)
              (position_free p2)
              (position_free p2)

              (can_do p0 t0)
              (connected p0 p1)
              (connected p1 p0)
              (connected p1 p2)
              (connected p2 p1)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b1 t0)
              )
	)
)
