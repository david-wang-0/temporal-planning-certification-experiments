BENCHMARKS=-b tck-aLU -b tck-covreach -b nuxmv-ground -b uppaal-ground -b cert-conv -b muntac-cert-check -b tamer-ctp-ground -b tamer-ftp-ground -b tfd -b optic -b popf3-ground -b nextflap 

GROUNDING=-b ground -b encode

MODEL_CONV=-b model-convert

# the -ground suffix is needed, because sometimes tamer's parser does not recognise the lifted pddl files (when subtyping is involved)
# popf3 also segfaults on some domains...

RESULTS=results.csv
TEMP_RESULTS=results.temp.csv

TIMEOUT=900s
LONGER_TIMEOUT=1800s
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

crew_planning_benchmarks:
	./run.sh -f crew_plan_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/crew-planning $(BENCHMARKS)

benchmark_nextflap:
	./run.sh -f nextflap_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/driverlog -b nextflap
	./run.sh -f nextflap_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/sync-impossible -b nextflap
	./run.sh -f nextflap_$(RESULTS) -t $(TIMEOUT) -m $(MEMORY) -p pddl-domains/MatchCellar-impossible -b nextflap
	
benchmark_conversion:
	./run.sh -f encode_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p pddl-domains/MatchCellar-impossible $(GROUNDING)
	./run.sh -f encode_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p pddl-domains/sync-impossible $(GROUNDING)
	./run.sh -f encode_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p pddl-domains/driverlog $(GROUNDING)

benchmark_longer_matchcellar:
	./run.sh -f longer_MatchCellar_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p pddl-domains/MatchCellar-impossible $(BENCHMARKS)

benchmark_longer_sync:
	./run.sh -f longer_sync_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p pddl-domains/sync-impossible $(BENCHMARKS)

benchmark_longer_painter:
	./run.sh -f longer_painter_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p pddl-domains/painter-impossible $(BENCHMARKS)

benchmark_longer_driverlog:
	./run.sh -f longer_painter_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p pddl-domains/driverlog $(BENCHMARKS)


benchmark_longer_all:
	benchmark_longer_driverlog
	benchmark_longer_matchcellar
	benchmark_longer_sync
	benchmark_longer_painter