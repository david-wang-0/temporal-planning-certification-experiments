(define (domain driverlog)
  (:requirements :typing :durative-actions) 
  (:types location locatable - object
		driver truck obj - locatable)

  (:predicates 
		(in ?obj1 - obj ?obj - truck)
		(driving ?d - driver ?v - truck)
		(loc ?obj - locatable ?loc - location)
		(link ?x ?y - location) 
		(path ?x ?y - location)
		(empty ?v - truck)
  )

(:durative-action LOAD_TRUCK
  :parameters
   (?obj - obj
    ?truck - truck
    ?loc - location)
  :duration (= ?duration 2)
  :condition
   (and 
   (over all (loc ?truck ?loc)) (at start (loc ?obj ?loc)))
  :effect
   (and (at start (not (loc ?obj ?loc))) (at end (in ?obj ?truck))))

(:durative-action UNLOAD_TRUCK
  :parameters
   (?obj - obj
    ?truck - truck
    ?loc - location)
  :duration (= ?duration 2)
  :condition
   (and
        (over all (loc ?truck ?loc)) (at start (in ?obj ?truck)))
  :effect
   (and (at start (not (in ?obj ?truck))) (at end (loc ?obj ?loc))))

(:durative-action BOARD_TRUCK
  :parameters
   (?driver - driver
    ?truck - truck
    ?loc - location)
  :duration (= ?duration 1)
  :condition
   (and 
   (over all (loc ?truck ?loc)) (at start (loc ?driver ?loc)) 
	(at start (empty ?truck)))
  :effect
   (and (at start (not (loc ?driver ?loc))) 
	(at end (driving ?driver ?truck)) (at start (not (empty ?truck)))))

(:durative-action DISEMBARK_TRUCK
  :parameters
   (?driver - driver
    ?truck - truck
    ?loc - location)
  :duration (= ?duration 1)
  :condition
   (and (over all (loc ?truck ?loc)) (at start (driving ?driver ?truck)))
  :effect
   (and (at start (not (driving ?driver ?truck))) 
	(at end (loc ?driver ?loc)) (at end (empty ?truck))))

(:durative-action DRIVE_TRUCK
  :parameters
   (?truck - truck
    ?loc-from - location
    ?loc-to - location
    ?driver - driver)
  :duration (= ?duration 10)
  :condition
   (and (at start (loc ?truck ?loc-from))
   (over all (driving ?driver ?truck)) (at start (link ?loc-from ?loc-to)))
  :effect
   (and (at start (not (loc ?truck ?loc-from))) 
	(at end (loc ?truck ?loc-to))))

(:durative-action WALK
  :parameters
   (?driver - driver
    ?loc-from - location
    ?loc-to - location)
  :duration (= ?duration 20)
  :condition
   (and (at start (loc ?driver ?loc-from)) 
	(at start (path ?loc-from ?loc-to)))
  :effect
   (and (at start (not (loc ?driver ?loc-from)))
	(at end (loc ?driver ?loc-to))))
)