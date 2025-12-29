
(define (control-knowledge pddltaCk) (:domain sync) (:problem instance_1_9)
    (:temporal-constraints
        (and


            (t-forall (?s - (compiled_d_start r0 p0)) (t-exists (?e - (compiled_d_end r0 p0)) (and (>= (- ?e ?s) (dur_d r0 p0)) (<= (- ?e ?s) (dur_d r0 p0)))))
            (t-forall (?e - (compiled_d_end r0 p0)) (t-exists (?s - (compiled_d_start r0 p0)) (and (>= (- ?e ?s) (dur_d r0 p0)) (<= (- ?e ?s) (dur_d r0 p0)))))

            (t-forall (?s - (compiled_d_start r0 p1)) (t-exists (?e - (compiled_d_end r0 p1)) (and (>= (- ?e ?s) (dur_d r0 p1)) (<= (- ?e ?s) (dur_d r0 p1)))))
            (t-forall (?e - (compiled_d_end r0 p1)) (t-exists (?s - (compiled_d_start r0 p1)) (and (>= (- ?e ?s) (dur_d r0 p1)) (<= (- ?e ?s) (dur_d r0 p1)))))

            (t-forall (?s - (compiled_d_start r0 p2)) (t-exists (?e - (compiled_d_end r0 p2)) (and (>= (- ?e ?s) (dur_d r0 p2)) (<= (- ?e ?s) (dur_d r0 p2)))))
            (t-forall (?e - (compiled_d_end r0 p2)) (t-exists (?s - (compiled_d_start r0 p2)) (and (>= (- ?e ?s) (dur_d r0 p2)) (<= (- ?e ?s) (dur_d r0 p2)))))

            (t-forall (?s - (compiled_d_start r0 p3)) (t-exists (?e - (compiled_d_end r0 p3)) (and (>= (- ?e ?s) (dur_d r0 p3)) (<= (- ?e ?s) (dur_d r0 p3)))))
            (t-forall (?e - (compiled_d_end r0 p3)) (t-exists (?s - (compiled_d_start r0 p3)) (and (>= (- ?e ?s) (dur_d r0 p3)) (<= (- ?e ?s) (dur_d r0 p3)))))

            (t-forall (?s - (compiled_d_start r0 p4)) (t-exists (?e - (compiled_d_end r0 p4)) (and (>= (- ?e ?s) (dur_d r0 p4)) (<= (- ?e ?s) (dur_d r0 p4)))))
            (t-forall (?e - (compiled_d_end r0 p4)) (t-exists (?s - (compiled_d_start r0 p4)) (and (>= (- ?e ?s) (dur_d r0 p4)) (<= (- ?e ?s) (dur_d r0 p4)))))

            (t-forall (?s - (compiled_d_start r0 p5)) (t-exists (?e - (compiled_d_end r0 p5)) (and (>= (- ?e ?s) (dur_d r0 p5)) (<= (- ?e ?s) (dur_d r0 p5)))))
            (t-forall (?e - (compiled_d_end r0 p5)) (t-exists (?s - (compiled_d_start r0 p5)) (and (>= (- ?e ?s) (dur_d r0 p5)) (<= (- ?e ?s) (dur_d r0 p5)))))

            (t-forall (?s - (compiled_d_start r0 p6)) (t-exists (?e - (compiled_d_end r0 p6)) (and (>= (- ?e ?s) (dur_d r0 p6)) (<= (- ?e ?s) (dur_d r0 p6)))))
            (t-forall (?e - (compiled_d_end r0 p6)) (t-exists (?s - (compiled_d_start r0 p6)) (and (>= (- ?e ?s) (dur_d r0 p6)) (<= (- ?e ?s) (dur_d r0 p6)))))

            (t-forall (?s - (compiled_d_start r0 p7)) (t-exists (?e - (compiled_d_end r0 p7)) (and (>= (- ?e ?s) (dur_d r0 p7)) (<= (- ?e ?s) (dur_d r0 p7)))))
            (t-forall (?e - (compiled_d_end r0 p7)) (t-exists (?s - (compiled_d_start r0 p7)) (and (>= (- ?e ?s) (dur_d r0 p7)) (<= (- ?e ?s) (dur_d r0 p7)))))

            (t-forall (?s - (compiled_d_start r0 p8)) (t-exists (?e - (compiled_d_end r0 p8)) (and (>= (- ?e ?s) (dur_d r0 p8)) (<= (- ?e ?s) (dur_d r0 p8)))))
            (t-forall (?e - (compiled_d_end r0 p8)) (t-exists (?s - (compiled_d_start r0 p8)) (and (>= (- ?e ?s) (dur_d r0 p8)) (<= (- ?e ?s) (dur_d r0 p8)))))

            (t-forall (?s - (compiled_c1_start r0)) (t-exists (?e - (compiled_c1_end r0)) (and (>= (- ?e ?s) (dur_c1 r0)) (<= (- ?e ?s) (dur_c1 r0)))))
            (t-forall (?e - (compiled_c1_end r0)) (t-exists (?s - (compiled_c1_start r0)) (and (>= (- ?e ?s) (dur_c1 r0)) (<= (- ?e ?s) (dur_c1 r0)))))
            (t-forall (?s - (compiled_c2_start r0)) (t-exists (?e - (compiled_c2_end r0)) (and (>= (- ?e ?s) (dur_c2 r0)) (<= (- ?e ?s) (dur_c2 r0)))))
            (t-forall (?e - (compiled_c2_end r0)) (t-exists (?s - (compiled_c2_start r00)) (and (>= (- ?e ?s) (dur_c2 r0)) (<= (- ?e ?s) (dur_c2 r0)))))

        )
    )
)