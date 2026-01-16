
(define (problem instance1_4_3)

(:domain majsp)

(:objects
  r0 - Robot
  p0 p1 p2 p3 - Position
  t0 t1 t2 - Treatment
  b0 b1 b2 - Pallet
)

(:init
  (robot-at r0 p3)

  (robot-free r0)

  (= (battery-level r0) 9)


  (pallet-at b0 p3)
  (pallet-at b1 p3)
  (pallet-at b2 p3)
  (is-depot p3)

  (position-free p0)
  (position-free p1)
  (position-free p2)
  (position-free p3)

  (can-do p0 t0)
  (can-do p1 t1)
  (can-do p2 t2)

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
  (treated b0 t0)
  (treated b1 t0)
  (treated b2 t0)
  (treated b0 t1)
  (treated b1 t1)
  (treated b2 t1)
  (treated b0 t2)
  (treated b1 t2)
  (treated b2 t2)

  )
)
)
