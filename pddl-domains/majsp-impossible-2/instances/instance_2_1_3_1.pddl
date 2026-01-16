
(define (problem instance2_3_1)

(:domain majsp)

(:objects
  r0 r1 - Robot
  p0 p1 p2 - Position
  t0 - Treatment
  b0 - Pallet
)

(:init
  (robot-at r0 p2)
  (robot-at r1 p2)

  (robot-free r0)
  (robot-free r1)

  (= (battery-level r0) 1)
  (= (battery-level r1) 1)


  (pallet-at b0 p2)
  (is-depot p2)

  (position-free p0)
  (position-free p1)
  (position-free p2)

  (can-do p0 t0)

  (= (distance p1 p0) 2)
  (= (distance p1 p2) 2)
  (= (distance p0 p2) 4)
  (= (distance p0 p1) 2)
  (= (distance p2 p1) 2)
  (= (distance p2 p0) 4)


)

(:goal
  (and
  (>= (battery-level r0) 0)
  (>= (battery-level r1) 0)
  (treated b0 t0)

  )
)
)
