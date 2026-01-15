(define (problem instance)
 (:domain matchcellar)
 (:objects
    match0 - match
    fuse0 fuse1 - fuse
)
 (:init
  (handfree)
  (unused match0)
)
 (:goal
  (and
     (mended fuse0)
     (mended fuse1)
))
 (:metric minimize (total-time))
)
