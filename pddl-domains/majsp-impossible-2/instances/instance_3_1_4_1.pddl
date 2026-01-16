
(define (problem instance3_4_1)

(:domain majsp)

(:objects
  r0 r1 r2 - Robot
  p0 p1 p2 p3 - Position
  t0 - Treatment
  b0 - Pallet
)

(:init
  (robot-at r0 p3)
  (robot-at r1 p3)
  (robot-at r2 p3)

  (robot-free r0)
  (robot-free r1)
  (robot-free r2)

  (= (battery-level r0) 1)
  (= (battery-level r1) 1)
  (= (battery-level r2) 1)


  (pallet-at b0 p3)
  (is-depot p3)

  (position-free p0)
  (position-free p1)
  (position-free p2)
  (position-free p3)

  (can-do p0 t0)

  (= (distance p3 p0) 6)
  (= (distance p2 p3) 2)
  (= (distance p1 p0) 2)
  (= (distance p3 p1) 4)
  (= (distance p1 p2) 2)
  (= (distance p1 p3) 4)
  (= (distance p0 p3) 6)
  (= (distance p0 p2) 4)
  (= (distance p3 p2) 2)
  (= (distance p0 p1) 2)
  (= (distance p2 p1) 2)
  (= (distance p2 p0) 4)


)

(:goal
  (and
  (>= (battery-level r0) 0)
  (>= (battery-level r1) 0)
  (>= (battery-level r2) 0)
  (treated b0 t0)

  )
)
)
