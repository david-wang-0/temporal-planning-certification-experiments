clean:
	rm results.csv
	rm results-temp.csv

benchmarks:
	./run.sh -f results.temp.csv -t 900s -m 56000000 -p pddl-domains/MatchCellar-impossible -b tck-covreach -b tamer-ctp-ground -b nuxmv-ground -b uppaal-ground -b cert-conv -b muntac-cert-check -b tfd
	./run.sh -f results.temp.csv -t 900s -m 56000000 -p pddl-domains/sync-impossible -b tck-covreach -b tamer-ctp-ground -b nuxmv-ground -b uppaal-ground -b cert-conv -b muntac-cert-check -b tfd
	./run.sh -f results.temp.csv -t 900s -m 56000000 -p pddl-domains/driverlog -b tck-covreach -b tamer-ctp-ground -b nuxmv-ground -b uppaal-ground -b cert-conv -b muntac-cert-check -b tfd
# runs the given benchmarks with a timeout of 900s and 56000000 kB of memory
# the -ground suffix is needed, because sometimes tamer's parser does not recognise the lifted pddl files (when subtyping is involved)