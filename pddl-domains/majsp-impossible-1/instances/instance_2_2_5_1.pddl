(define (problem p_2_2_5_1)

	(:domain majsp)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 p3 p4 - Position
		t0 - Treatment
		b0 b1 - Pallet 
		zero one two - Nat 
	)

        (:init
              (next_nat zero one)
              (next_nat one two)

              (robot_at r0 p4)
              (robot_free r0)
              (battery_level r0 two)
              (robot_at r1 p4)
              (robot_free r1)
              (battery_level r1 two)

              (pallet_at b0 p4)
              (pallet_at b1 p4)

              (is_depot p4)

              (position_free p4)
              (position_free p4)
              (position_free p4)
              (position_free p4)
              (position_free p4)

              (can_do p0 t0)
              (connected p0 p1)
              (connected p1 p0)
              (connected p1 p2)
              (connected p2 p1)
              (connected p2 p3)
              (connected p3 p2)
              (connected p3 p4)
              (connected p4 p3)

        )

	(:goal
              (and
              (treated b0 t0)
              (treated b1 t0)
              )
	)
)
