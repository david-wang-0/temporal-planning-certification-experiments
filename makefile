BENCHMARKS=-b tck-aLU -b tck-covreach -b tamer-ctp-ground -b tamer-ftp-ground -b nuxmv-ground -b uppaal-ground -b cert-conv -b muntac-cert-check -b tfd -b optic -b popf3-ground -b nextflap 

BENCHMARKS2=-b tamer-ftp-ground -b uppaal-ground -b nextflap

# the -ground suffix is needed, because sometimes tamer's parser does not recognise the lifted pddl files (when subtyping is involved)
# popf3 also segfaults on some domains...

RESULTS=results.csv
TEMP_RESULTS=results.temp.csv

TIMEOUT=900s
MEMORY=56000000 # in kB. Should be 56 GB

clean:
	rm $(RESULTS)
	rm $(TEMP_RESULTS)

benchmarks_temp:
	./run.sh -f $(TEMP_RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/MatchCellar-impossible $(BENCHMARKS)
	./run.sh -f $(TEMP_RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/sync-impossible $(BENCHMARKS)
	./run.sh -f $(TEMP_RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/driverlog $(BENCHMARKS)

benchmarks:
	./run.sh -f $(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/MatchCellar-impossible $(BENCHMARKS)
	./run.sh -f $(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/sync-impossible $(BENCHMARKS)
	./run.sh -f $(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/driverlog $(BENCHMARKS)

sync_benchmarks:
	./run.sh -f sync_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/sync-impossible $(BENCHMARKS)

benchmarks_rep:
	./run.sh -f more_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/MatchCellar-impossible $(BENCHMARKS2)
	./run.sh -f more_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/driverlog $(BENCHMARKS2)