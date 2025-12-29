
(define (control-knowledge pddltaCk) (:domain sync) (:problem instance_1_2)
    (:temporal-constraints
        (and


            (t-forall (?s - (compiled_d_start r0 p0)) (t-exists (?e - (compiled_d_end r0 p0)) (and (>= (- ?e ?s) (dur_d r0 p0)) (<= (- ?e ?s) (dur_d r0 p0)))))
            (t-forall (?e - (compiled_d_end r0 p0)) (t-exists (?s - (compiled_d_start r0 p0)) (and (>= (- ?e ?s) (dur_d r0 p0)) (<= (- ?e ?s) (dur_d r0 p0)))))

            (t-forall (?s - (compiled_d_start r0 p1)) (t-exists (?e - (compiled_d_end r0 p1)) (and (>= (- ?e ?s) (dur_d r0 p1)) (<= (- ?e ?s) (dur_d r0 p1)))))
            (t-forall (?e - (compiled_d_end r0 p1)) (t-exists (?s - (compiled_d_start r0 p1)) (and (>= (- ?e ?s) (dur_d r0 p1)) (<= (- ?e ?s) (dur_d r0 p1)))))

            (t-forall (?s - (compiled_c1_start r0)) (t-exists (?e - (compiled_c1_end r0)) (and (>= (- ?e ?s) (dur_c1 r0)) (<= (- ?e ?s) (dur_c1 r0)))))
            (t-forall (?e - (compiled_c1_end r0)) (t-exists (?s - (compiled_c1_start r0)) (and (>= (- ?e ?s) (dur_c1 r0)) (<= (- ?e ?s) (dur_c1 r0)))))
            (t-forall (?s - (compiled_c2_start r0)) (t-exists (?e - (compiled_c2_end r0)) (and (>= (- ?e ?s) (dur_c2 r0)) (<= (- ?e ?s) (dur_c2 r0)))))
            (t-forall (?e - (compiled_c2_end r0)) (t-exists (?s - (compiled_c2_start r00)) (and (>= (- ?e ?s) (dur_c2 r0)) (<= (- ?e ?s) (dur_c2 r0)))))

        )
    )
)