(define (problem p_2_4_3_2)

	(:domain majsp)

	(:objects
		r0 r1 - Robot
		p0 p1 p2 - Position
		t0 t1 - Treatment
		b0 b1 b2 b3 - Pallet 
		zero one two three four - Nat 
	)

        (:init
              (next_nat zero one)
              (next_nat one two)
              (next_nat two three)
              (next_nat three four)

              (robot_at r0 p2)
              (robot_free r0)
              (battery_level r0 four)
              (robot_at r1 p2)
              (robot_free r1)
              (battery_level r1 four)

              (pallet_at b0 p2)
              (pallet_at b1 p2)
              (pallet_at b2 p2)
              (pallet_at b3 p2)

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
              (treated b2 t0)
              (treated b2 t1)
              (treated b3 t0)
              (treated b3 t1)
              )
	)
)
