TCHECKER_CERT=-b tck-covreach -b cert-conv -b muntac-cert-check


# the -ground suffix is needed, because sometimes tamer's parser does not recognise the lifted pddl files (when subtyping is involved)
# popf3 also segfaults on some domains...

TAMER=-b tamer-ctp -b tamer-ftp
TAMER_GROUND=-b tamer-ctp-ground -b tamer-ftp-ground

PLANNERS=-b tfd -b optic -b popf3-ground -b nextflap 

MODEL_CHECKERS=-b tck-aLU -b nuxmv-ground -b nuxmv -b uppaal-ground -b uppaal

GROUNDING=-b grounder

VERIFIED_ENCODER=-b verified-encoder

MODEL_CONV=-b model-converter

PIPELINE=$(GROUNDING) $(VERIFIED_ENCODER) $(MODEL_CONV) $(TCHECKER_CERT)

BENCHMARKS=$(PIPELINE) $(TAMER) $(TAMER_GROUND) $(PLANNERS) $(MODEL_CHECKERS)

RESULTS=results.$(shell date +%s).csv

# time out and memory
TIMEOUT=900s
LONGER_TIMEOUT=1800s

MEMORY=56000000 # in kB. Should be 56 GB

MATCHCELLAR=pddl-domains/MatchCellar-impossible
SYNC=pddl-domains/sync-impossible
PAINTER=pddl-domains/painter-impossible
DRIVERLOG=pddl-domains/driverlog
MAJSP=pddl-domains/majsp-impossible-1

clean:
	rm $(RESULTS)
	rm $(TEMP_RESULTS)

create_painter_instances:
	cd pddl-domains/painter-impossible; python -m generator

create_driverlog_instances:
	cd pddl-domains/driverlog; python -m generator

create_instances: create_painter_instances create_driverlog_instances

benchmark_longer_matchcellar:
	./run.sh -f longer_MatchCellar_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MATCHCELLAR) $(BENCHMARKS)

benchmark_longer_sync:
	./run.sh -f longer_sync_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(SYNC) $(BENCHMARKS)

benchmark_longer_painter: create_painter_instances
	./run.sh -f longer_painter_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(PAINTER) $(BENCHMARKS)

benchmark_longer_driverlog: create_driverlog_instances
	./run.sh -f longer_driverlog_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(DRIVERLOG) $(BENCHMARKS)

benchmark_longer_majsp:
	./run.sh -f longer_majsp_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MAJSP) $(BENCHMARKS)

benchmark_longer_all: benchmark_longer_driverlog benchmark_longer_matchcellar benchmark_longer_sync benchmark_longer_painter benchmark_longer_majsp


benchmark_short_matchcellar:
	./run.sh -f short_MatchCellar_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MATCHCELLAR)  $(BENCHMARKS)

benchmark_short_sync:
	./run.sh -f short_sync_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(SYNC) $(BENCHMARKS)

benchmark_short_painter: create_painter_instances
	./run.sh -f short_painter_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(PAINTER) $(BENCHMARKS)

benchmark_short_driverlog: create_driverlog_instances
	./run.sh -f short_driverlog_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(DRIVERLOG) $(BENCHMARKS)

benchmark_short_majsp:
	./run.sh -f short_majsp_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MAJSP) $(BENCHMARKS)

benchmark_short_all: benchmark_short_driverlog benchmark_short_matchcellar benchmark_short_sync benchmark_short_painter benchmark_short_majsp


benchmark_short_majsp_tamer:
	./run.sh -f short_majsp_tamer_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MAJSP) $(TAMER)

benchmark_short_matchcellar_tamer:
	./run.sh -f short_matchcellar_tamer_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(MATCHCELLAR) $(TAMER)

benchmark_short_sync_tamer:
	./run.sh -f short_sync_tamer_$(RESULTS) -t $(LONGER_TIMEOUT) -m $(MEMORY) -p $(SYNC) $(TAMER)
