
(define (problem instance2_2_2)

(:domain majsp)

(:objects
  r0 r1 - Robot
  p0 p1 - Position
  t0 t1 - Treatment
  b0 b1 - Pallet
)

(:init
  (robot-at r0 p1)
  (robot-at r1 p1)

  (robot-free r0)
  (robot-free r1)

  (= (battery-level r0) 1)
  (= (battery-level r1) 1)


  (pallet-at b0 p1)
  (pallet-at b1 p1)
  (is-depot p1)

  (position-free p0)
  (position-free p1)

  (can-do p0 t0)
  (can-do p0 t1)

  (= (distance p1 p0) 2)
  (= (distance p0 p1) 2)


)

(:goal
  (and
  (>= (battery-level r0) 0)
  (>= (battery-level r1) 0)
  (treated b0 t0)
  (treated b1 t0)
  (treated b0 t1)
  (treated b1 t1)

  )
)
)
